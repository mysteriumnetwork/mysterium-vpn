import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/services/api/rest_external_api_service.dart';
import 'package:mysterium_vpn/services/network_health/tunnel_health_types.dart';
import 'package:talker/talker.dart';

/// Reuses the app's existing IP-echo host so it has a single owner.
const kTunnelledProbeUrl = kFetchIPAddress;
const kDirectProbeUrl = 'https://location.mysterium.network/api/v1/ip';

// ignore: one_member_abstracts
abstract class TunnelHealthProbe {
  Future<TunnelHealthSample> probe({required String? exitIp, required List<String> controlIps});
}

/// Times a tunnelled request against one the backend excludes from the tunnel
/// route. Both legs run in parallel so they see the same network conditions.
class HttpTunnelHealthProbe implements TunnelHealthProbe {
  HttpTunnelHealthProbe(
    this._dio,
    this._logger, {
    required this.timeout,
    this.onControlAddressesStale,
    this.resolve = InternetAddress.lookup,
  });

  final Dio _dio;
  final Talker _logger;
  final Duration timeout;

  /// Called with the host's current addresses when none of the configured
  /// control IPs appear among them. A stale control IP is otherwise silent:
  /// the dial fails, every degraded tunnel reports as no network, and nothing
  /// says why. Fires only while DNS is healthy, so it cannot cry wolf during
  /// the outage it exists to describe.
  final void Function(List<String> resolved)? onControlAddressesStale;

  /// Injectable so tests do not depend on live DNS.
  final Future<List<InternetAddress>> Function(String host) resolve;

  /// The configured addresses this process has already resolved an answer for.
  /// Without it the same verdict is reported on every resume forever.
  String? _staleCheckedFor;

  @override
  Future<TunnelHealthSample> probe({
    required String? exitIp,
    required List<String> controlIps,
  }) async {
    final legs = await Future.wait([
      _timed(kTunnelledProbeUrl, _plainIp),
      _timed(kDirectProbeUrl, _jsonIp),
    ]);

    final tunnelled = legs[0];
    final direct = legs[1];

    // A healthy direct leg means DNS works, which is the only moment the
    // configured control IPs can be checked against reality. Not awaited: the
    // sample does not depend on it.
    if (direct.elapsed != null && onControlAddressesStale != null) {
      unawaited(_reportIfControlAddressesStale(controlIps));
    }

    final bothLegsFailed = tunnelled.elapsed == null && direct.elapsed == null;
    final controlReachable = bothLegsFailed && await _anyControlReachable(controlIps);

    if (tunnelled.ip != null && exitIp != null && exitIp.isNotEmpty && tunnelled.ip != exitIp) {
      // Addresses only in dev. CrashlyticsLoggerObserver forwards every level,
      // and this fires exactly when the probe escaped the tunnel - so
      // tunnelled.ip is the user's real public IP.
      _logger.warning(
        kDebugMode || Env.flavor.isDev
            ? 'Tunnelled probe returned ${tunnelled.ip}, expected exit $exitIp'
            : 'Tunnelled probe returned an address other than the tunnel exit',
      );
    }

    return TunnelHealthSample(
      tunnelled: tunnelled,
      direct: direct,
      bypassVerified:
          exitIp != null && exitIp.isNotEmpty && direct.ip != null && direct.ip != exitIp,
      controlReachable: controlReachable,
    );
  }

  /// Warns when the ConfigCat control IPs no longer appear in DNS for the
  /// host they were copied from.
  ///
  /// Reports at most once per configured value per process. The host answers
  /// differently per resolver, so a single disjoint answer is weak evidence on
  /// its own — the event carries the addresses seen instead, and a real
  /// rotation shows up as many devices naming the same new one.
  Future<void> _reportIfControlAddressesStale(List<String> controlIps) async {
    final checking = controlIps.join(',');
    if (_staleCheckedFor == checking) {
      return;
    }

    try {
      final host = Uri.parse(kDirectProbeUrl).host;
      final lookup = await resolve(host).timeout(timeout);
      final resolved = lookup
          .where((it) => it.type == InternetAddressType.IPv4)
          .map((it) => it.address)
          .toList();
      if (resolved.isEmpty) {
        return;
      }
      // Latched only on a conclusive answer, so a failed lookup is retried on
      // the next resume rather than silencing the check for the process.
      _staleCheckedFor = checking;
      // One overlapping address is enough: the host is load-balanced.
      if (controlIps.any(resolved.contains)) {
        return;
      }
      _logger.warning(
        'Control IPs $controlIps are no longer in DNS for $host (now $resolved) - '
        'a degraded tunnel will report as no network until ConfigCat is updated',
      );
      onControlAddressesStale?.call(resolved);
    } catch (e) {
      // Inconclusive, not stale: never raise the alarm on a failed lookup.
      _logger.debug('Could not check control addresses: $e');
    }
  }

  /// Any one answering proves the device has a network. Raced rather than
  /// tried in turn: the whole point is to answer fast while both HTTP legs
  /// have already timed out, and a dead address costs the full timeout.
  Future<bool> _anyControlReachable(List<String> ips) async {
    if (ips.isEmpty) {
      _logger.warning('No control IPs configured, cannot tell a bad node from no network');
      return false;
    }
    final results = await Future.wait(ips.map(_controlReachable));

    return results.any((it) => it);
  }

  Future<bool> _controlReachable(String ip) async {
    final address = InternetAddress.tryParse(ip);
    if (address == null) {
      _logger.warning('Control IP $ip is not a valid address');
      return false;
    }
    try {
      final socket = await Socket.connect(address, 443, timeout: timeout);
      socket.destroy();
      return true;
    } catch (e) {
      _logger.warning('Control connect to $ip failed: $e');
      return false;
    }
  }

  Future<TunnelHealthLeg> _timed(String url, String? Function(String) parse) async {
    final stopwatch = Stopwatch()..start();
    try {
      final response = await _dio
          .getUri<String>(
            _bust(url),
            options: Options(
              responseType: ResponseType.plain,
              headers: const {'Cache-Control': 'no-cache'},
              receiveTimeout: timeout,
            ),
          )
          .timeout(timeout);
      stopwatch.stop();

      if (response.statusCode != 200) {
        return (elapsed: null, ip: null, error: 'HTTP ${response.statusCode}');
      }
      return (elapsed: stopwatch.elapsed, ip: parse(response.data ?? ''), error: null);
    } catch (e) {
      stopwatch.stop();
      _logger.warning('Tunnel health probe failed for $url: $e');
      return (elapsed: null, ip: null, error: e);
    }
  }

  // Nothing is edge-cached today, but a cached response would silently turn
  // the tunnelled leg into a measurement of nothing.
  Uri _bust(String url) => Uri.parse(
    url,
  ).replace(queryParameters: {'_': DateTime.now().microsecondsSinceEpoch.toString()});

  String? _plainIp(String body) {
    final trimmed = body.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  String? _jsonIp(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final ip = decoded['ip'];
        return ip is String && ip.isNotEmpty ? ip : null;
      }
    } catch (e) {
      _logger.warning('Could not parse direct probe body: $e');
    }
    return null;
  }
}
