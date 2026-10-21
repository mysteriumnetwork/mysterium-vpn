import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mysterium_vpn/services/api/rest_external_api_service.dart';
import 'package:mysterium_vpn/services/network_health/tunnel_health_types.dart';
import 'package:talker/talker.dart';

/// Reuses the app's existing IP-echo host so it has a single owner.
/// Budget for each probe leg and the control connect.
const kProbeTimeout = Duration(seconds: 5);

const kTunnelledProbeUrl = kFetchIPAddress;
const kDirectProbeUrl = 'https://location.mysterium.network/api/v1/ip';

// ignore: one_member_abstracts
abstract class TunnelHealthProbe {
  Future<TunnelHealthSample> probe({required String? exitIp, required String controlIp});
}

/// Times a tunnelled request against one the backend excludes from the tunnel
/// route. Both legs run in parallel so they see the same network conditions.
class HttpTunnelHealthProbe implements TunnelHealthProbe {
  const HttpTunnelHealthProbe(this._dio, this._logger, {required this.timeout});

  final Dio _dio;
  final Talker _logger;
  final Duration timeout;

  @override
  Future<TunnelHealthSample> probe({required String? exitIp, required String controlIp}) async {
    final legs = await Future.wait([
      _timed(kTunnelledProbeUrl, _plainIp),
      _timed(kDirectProbeUrl, _jsonIp),
    ]);

    final tunnelled = legs[0];
    final direct = legs[1];

    // Only consulted when both legs failed, so connecting otherwise would cost
    // a handshake and a radio wake on every healthy resume for a value nothing
    // reads. Nothing is racing here either: both legs have already timed out.
    final bothLegsFailed = tunnelled.elapsed == null && direct.elapsed == null;
    final controlReachable = bothLegsFailed && await _controlReachable(controlIp);

    if (tunnelled.ip != null && exitIp != null && exitIp.isNotEmpty && tunnelled.ip != exitIp) {
      _logger.warning('Tunnelled probe returned ${tunnelled.ip}, expected exit $exitIp');
    }

    return TunnelHealthSample(
      tunnelled: tunnelled,
      direct: direct,
      bypassVerified:
          exitIp != null && exitIp.isNotEmpty && direct.ip != null && direct.ip != exitIp,
      controlReachable: controlReachable,
    );
  }

  /// Raw TCP to the control IP: no DNS, no TLS, no HTTP.
  /// See [TunnelHealthSample.controlReachable] for why that matters.
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
