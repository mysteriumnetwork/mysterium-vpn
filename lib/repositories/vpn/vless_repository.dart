import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/repositories/vpn/base_vpn_repository.dart';
import 'package:vless_dart/vless_dart.dart';
import 'package:vpn_api/vpn_api.dart';

/// VLESS over the `/connection/connect-vless` endpoint, tunnelled by
/// `vless_dart`'s packet tunnel extension.
/// Warn once the extension passes this; iOS jetsam kills it around 50 MB.
const _footprintWarnBytes = 40 * 1024 * 1024;

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

  @override
  Future<void> init() async {
    await _service.initialize(
      providerBundleIdentifier: Env.vlessExtensionId,
      localizedDescription: Env.vlessExtensionName,
    );
  }

  @override
  Future<void> setupTunnel() async {
    try {
      await _service.setupTunnel();
      logger.info('VLESS tunnel setup completed');
    } catch (e) {
      logger.handle(e);
      rethrow;
    }
  }

  @override
  Future<void> connect({required String config, String? dnsAddress}) async {
    _connectPending = true;
    _connectCancelled = false;
    try {
      // The `vless://` URI carries no resolver, so unlike WireGuard and OpenVPN
      // the selection cannot come back from the API: it is applied here or not
      // at all, and the content blockers are exactly this selection.
      await _service
          .connect(config, dnsAddress: dnsAddress)
          .timeout(
            const Duration(seconds: vpnConnectionTimeoutSeconds),
            onTimeout: () {
              throw TimeoutException(
                'VLESS connection timed out after $vpnConnectionTimeoutSeconds seconds',
              );
            },
          );
    } on TimeoutException catch (e, stackTrace) {
      logger.handle(e, stackTrace);
      rethrow;
    } catch (e, stackTrace) {
      if (_connectCancelled) {
        logger.info('VLESS connect cancelled by a teardown');
        throw OperationCancelledException();
      }
      logger.handle(e, stackTrace);
      throw VpnConnectException(e.toString());
    } finally {
      _connectPending = false;
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
    } on MissingPluginException {
      rethrow;
    } catch (e) {
      logger.warning('Failed to read VLESS tunnel statistics: $e');
      return null;
    }
  }

  /// iOS terminates a Network Extension past roughly 50 MB of phys_footprint,
  /// which the extension measures and reports; the app cannot see it otherwise.
  /// Logged rather than surfaced so a tunnel nearing the limit is visible in
  /// Sentry breadcrumbs before jetsam kills it.
  void _warnOnFootprint(int? footprintBytes) {
    if (footprintBytes == null || footprintBytes < _footprintWarnBytes) {
      return;
    }
    final mb = (footprintBytes / 1024 / 1024).toStringAsFixed(1);
    logger.warning('VLESS tunnel footprint $mb MB, approaching the iOS extension limit');
  }

  @override
  Future<void> removeTunnelConfiguration() async {
    try {
      await _service.removeTunnelConfiguration();
      logger.info('VLESS tunnel configuration removed');
    } catch (e) {
      logger.handle(e);
      rethrow;
    }
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
    try {
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
    } catch (e) {
      logger.handle(e);
      rethrow;
    }
  }

  @override
  Future<void> resetApp() async {
    try {
      if (Platform.isAndroid || Platform.isWindows) {
        return;
      }
      await removeTunnelConfiguration();
    } catch (e) {
      logger.handle(e);
      rethrow;
    }
  }
}
