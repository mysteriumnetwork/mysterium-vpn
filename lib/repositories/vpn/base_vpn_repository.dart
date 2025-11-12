import 'package:mysterium_vpn/repositories/vpn/vpn_repository.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:talker/talker.dart';
import 'package:vpn_api/vpn_api.dart';

abstract class BaseVpnRepository implements VpnRepository {
  BaseVpnRepository({
    required this.logger,
    required this.apiService,
  });

  final Talker logger;
  final ApiService apiService;

  /// Rate the VPN connection by sending the relevant data to the API.
  @override
  Future<void> rateConnection({
    required String ipType,
    required String country,
    required String? feedback,
    required String? reasons,
    required RateConnectionRequestModeEnum mode,
  }) async {
    try {
      await apiService.rateConnection(
        request: RateConnectionRequest(
          mode: mode,
          reasons: reasons,
          feedback: feedback,
          country: country,
          ipType: ipType,
        ),
      );
    } catch (e) {
      logger.handle(e);
      rethrow;
    }
  }

  /// Notify the API that the user has disconnected from the VPN tunnel.
  @override
  Future<void> notifyApiVpnDisconnected() async {
    try {
      await apiService.disconnect();
    } catch (e) {
      logger.handle(e);
      Sentry.captureException(e);
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
      logger.info(
        'UDP block check completed in less than 2sec and it is not blocked',
      );
    } catch (e) {
      logger.handle(e);
      Sentry.captureException(e);
      rethrow;
    }
  }
}
