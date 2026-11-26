import 'dart:async';
import 'dart:io';

import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/repositories/vpn/base_vpn_repository.dart';
import 'package:vless_dart/vless_dart.dart';
import 'package:vless_dart/vpn_status.dart';
import 'package:vpn_api/vpn_api.dart';

/// VLESS over the `/connection/connect-vless` endpoint, tunnelled by
/// `vless_dart`'s packet tunnel extension.
/// Warn once the extension passes this; iOS jetsam kills it around 50 MB.
const _footprintWarnBytes = 40 * 1024 * 1024;

class _TunnelDidNotStart implements Exception {
  const _TunnelDidNotStart();

  @override
  String toString() => 'the VLESS tunnel stopped before it came up';
}

class VlessRepository extends BaseVpnRepository {
  VlessRepository({required VlessDart service, required super.apiService, required super.logger})
    : _service = service;

  final VlessDart _service;

  /// Set while [connect] is in flight. The platform reports `disconnected`
  /// until the profile is saved and the tunnel actually starts, so a teardown
  /// in that window would otherwise never reach the plugin — and cancelling a
  /// connect that has not started yet is something only the plugin can do.
  bool _connectPending = false;

  /// Set when [disconnect] cancelled a pending connect, so the failure that
  /// cancellation provokes is reported as such instead of as a connection
  /// error with a snackbar and a crash report.
  bool _connectCancelled = false;

  /// The wait [connect] is in, which [disconnect] ends without the platform's help.
  Completer<void>? _outcome;

  @override
  Future<void> init() async {
    await _service.initialize(
      providerBundleIdentifier: Env.vlessExtensionId,
      localizedDescription: Env.vlessExtensionName,
    );
  }

  @override
  Future<void> setupTunnel() async {
    await _service.setupTunnel();
    logger.info('VLESS tunnel setup completed');
  }

  @override
  Future<void> connect({required String config, String? dnsAddress}) async {
    _connectPending = true;
    _connectCancelled = false;
    try {
      // The `vless://` URI carries no resolver, so unlike WireGuard and OpenVPN
      // the selection cannot come back from the API: it is applied here or not
      // at all, and the content blockers are exactly this selection.
      await _startTunnel(config, dnsAddress);
    } on TimeoutException {
      rethrow;
    } catch (e, stackTrace) {
      if (_connectCancelled) {
        logger.info('VLESS connect cancelled by a teardown');
        throw OperationCancelledException();
      }
      // Wrapped below, which keeps the message but drops the stack — so this
      // is the only place it survives. A node refusing a connection is
      // expected, so it is a warning rather than a crash report.
      logger.warning('VLESS connect failed', e, stackTrace);
      throw VpnConnectException(e.toString());
    } finally {
      _connectPending = false;
    }
  }

  /// The plugin answers on start requested; the outcome is on the status stream.
  Future<void> _startTunnel(String config, String? dnsAddress) async {
    final outcome = _outcome = Completer<void>();
    // A failure can land before anything awaits it.
    outcome.future.ignore();
    void fail(Object error) {
      if (!outcome.isCompleted) {
        outcome.completeError(error);
      }
    }

    var starting = false;
    final statuses = _service.statusStream().listen(
      (status) {
        if (outcome.isCompleted) {
          return;
        }
        if (status == ConnectionStatus.connected) {
          outcome.complete();
        } else if (status == ConnectionStatus.connecting) {
          starting = true;
        } else if (status == ConnectionStatus.disconnected && starting) {
          fail(const _TunnelDidNotStart());
        }
      },
      // Windows reports a failed start here, with the reason.
      onError: fail,
    );
    // Not awaited: a teardown has to be able to end the wait before it answers.
    unawaited(_service.connect(config, dnsAddress: dnsAddress).then((_) {}, onError: fail));
    try {
      await outcome.future.timeout(
        const Duration(seconds: vpnConnectionTimeoutSeconds),
        onTimeout: () {
          // Left starting, it could come up after the error was shown.
          unawaited(_service.disconnect().catchError((Object _) {}));
          throw TimeoutException(
            'VLESS connection timed out after $vpnConnectionTimeoutSeconds seconds',
          );
        },
      );
    } finally {
      unawaited(statuses.cancel());
      _outcome = null;
    }
  }

  @override
  Future<bool> disconnect() async {
    // Read before the status round-trip: the connect can finish during it,
    // leaving a stale `disconnected` to decide against a tunnel that is by
    // then already coming up.
    final cancellingConnect = _connectPending;
    if (!cancellingConnect && !stoppable(await currentStatus())) {
      return false;
    }
    _connectCancelled = cancellingConnect;
    if (cancellingConnect) {
      // Not left to the stream: Android reports `connected` before it stops.
      final outcome = _outcome;
      if (outcome != null && !outcome.isCompleted) {
        outcome.completeError(OperationCancelledException());
      }
    }
    await _service.disconnect();
    return true;
  }

  @override
  Future<bool> isTunnelConfigured() => singleFlightTunnelCheck(_service.checkTunnelConfiguration);

  @override
  Stream<VpnConnectionStatus> statusStream() =>
      _service.statusStream().map((status) => VpnConnectionStatus.fromString(status.name));

  @override
  Future<VpnConnectionStatus> currentStatus() async {
    final status = await _service.getVPNStatus();
    return VpnConnectionStatus.fromString(status.name);
  }

  @override
  Future<TunnelStats?> tunnelStatistics() async {
    try {
      final stats = await _service.tunnelStatistics();
      if (stats == null) {
        return null;
      }
      _warnOnFootprint(stats.footprintBytes);
      // VLESS has no handshake, so latestHandshake stays null.
      return TunnelStats(totalDownload: stats.totalDownload, totalUpload: stats.totalUpload);
    } catch (e) {
      // Rethrown rather than folded into the null above, as WireGuard does:
      // "the platform reported nothing" and "the read failed" are different
      // diagnoses, and tunnel health records them as different outcomes.
      logger.warning('Failed to read VLESS tunnel statistics: $e');
      rethrow;
    }
  }

  /// iOS terminates a Network Extension past roughly 50 MB of phys_footprint,
  /// which the extension measures and reports; the app cannot see it otherwise.
  /// Logged rather than surfaced so a tunnel nearing the limit is visible in
  /// Crashlytics breadcrumbs before jetsam kills it.
  void _warnOnFootprint(int? footprintBytes) {
    if (footprintBytes == null || footprintBytes < _footprintWarnBytes) {
      return;
    }
    final mb = (footprintBytes / 1024 / 1024).toStringAsFixed(1);
    logger.warning('VLESS tunnel footprint $mb MB, approaching the iOS extension limit');
  }

  @override
  Future<void> removeTunnelConfiguration() async {
    await _service.removeTunnelConfiguration();
    logger.info('VLESS tunnel configuration removed');
  }

  @override
  Future<VpnConfig> fetchVpnConfig({
    required String? countryOriginate,
    required String? country,
    required String? city,
    required String? ipType,
    required String? userIntent,
    required String? cluster,
    required bool? resetConnection,
    required String dnsAddress,
    String? targetIp,
  }) async {
    final response = await apiService.fetchVlessConfig(
      request: VlessConnectRequest(
        countryOriginate: countryOriginate,
        country: country,
        city: city,
        ipType: ipType,
        resetConnection: resetConnection,
        osType: Platform.operatingSystem,
        userIntent: userIntent,
        cluster: cluster,
        dns: dnsAddress,
        targetIp: targetIp,
      ),
    );
    return VpnConfig.fromVless(response);
  }

  @override
  Future<void> resetApp() async {
    if (Platform.isAndroid || Platform.isWindows) {
      return;
    }
    await removeTunnelConfiguration();
  }
}
