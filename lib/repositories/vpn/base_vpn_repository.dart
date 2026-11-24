import 'package:flutter/foundation.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/repositories/vpn/vpn_repository.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:talker/talker.dart';
import 'package:vpn_api/vpn_api.dart';

/// Bounds the disconnect notification, so a late one cannot outlive a quick
/// reconnect.
const _notifyWindow = Duration(seconds: 5);

abstract class BaseVpnRepository implements VpnRepository {
  BaseVpnRepository({required this.logger, required this.apiService});

  final Talker logger;
  final ApiService apiService;

  Future<bool>? _tunnelCheck;

  /// Collapses concurrent [isTunnelConfigured] calls onto one. On Apple the
  /// check is a NetworkExtension preferences round-trip, and parallel ones go
  /// stale — which the plugin reports back as "tunnel not configured".
  @protected
  Future<bool> singleFlightTunnelCheck(Future<bool> Function() check) =>
      _tunnelCheck ??= check().whenComplete(() => _tunnelCheck = null);

  /// Whether a teardown request should still reach the platform.
  ///
  /// `connecting` counts: the native profile keeps starting on its own, so a
  /// switch or a revoked subscription that only stopped a `connected` tunnel
  /// left the old one coming up after the teardown was asked for.
  @protected
  bool stoppable(VpnConnectionStatus status) =>
      status == VpnConnectionStatus.connected || status == VpnConnectionStatus.connecting;

  /// Rate the VPN connection by sending the relevant data to the API.
  @override
  Future<void> rateConnection({
    required String ipType,
    required String country,
    required String? feedback,
    required String? reasons,
    required RateConnectionMode mode,
  }) async {
    await apiService.rateConnection(
      request: RateConnectionRequest(
        mode: switch (mode) {
          RateConnectionMode.like => RateConnectionRequestModeEnum.like,
          RateConnectionMode.dislike => RateConnectionRequestModeEnum.dislike,
        },
        reasons: reasons,
        feedback: feedback,
        country: country,
        ipType: ipType,
      ),
    );
  }

  /// Notify the API that the user has disconnected from the VPN tunnel.
  ///
  /// Nothing waits on this, so it is bounded here: unbounded, it sat in the
  /// retry and domain-failover machinery for minutes after the user moved on.
  @override
  Future<void> notifyApiVpnDisconnected() async {
    try {
      await apiService.disconnect().timeout(_notifyWindow);
    } catch (e, stackTrace) {
      // Expected on a network still settling after the tunnel went down.
      logger.warning('Failed to notify the API of the disconnect', e, stackTrace);
    }
  }

  /// Disconnect all devices associated with the user's account.
  @override
  Future<void> disconnectAllDevices() async {
    try {
      await apiService.disconnectAllDevices();
    } catch (e, stackTrace) {
      logger.handle(e, stackTrace);
      Sentry.captureException(e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Check if UDP is blocked by making a request to the API.
  @override
  Future<void> udpBlockedCheck() async {
    try {
      await apiService.udpBlockedCheck();
      logger.info('UDP block check completed in less than 2sec and it is not blocked');
    } catch (e) {
      logger.handle(e);
      Sentry.captureException(e);
      rethrow;
    }
  }
}
