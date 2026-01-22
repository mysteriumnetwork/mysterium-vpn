import 'package:app_settings/app_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/repositories/notifications/notifications_repository.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:talker/talker.dart';

class OnesignalNotificationsRepository implements NotificationsRepository {
  OnesignalNotificationsRepository({required this.logger}) {
    init();
  }

  final Talker logger;

  @override
  Future<void> init() async {
    if (!isMobile()) {
      return;
    }
    if (kDebugMode) {
      await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    }
    OneSignal.initialize(Env.oneSignalAppId);
  }

  @override
  Future<void> setUserId(String userId) async {}

  @override
  Future<bool> requestPermission() async {
    try {
      if (getPermissionStatus()) {
        return true;
      }
      if (!(await OneSignal.Notifications.canRequest())) {
        throw RequestPushNotificationsPermissionsNotAllowed();
      }
      final granted = await OneSignal.Notifications.requestPermission(false);
      if (!granted) {
        logger.info('Push notifications permission not granted by the user.');
      } else {
        logger.info('Push notifications permission granted by the user.');
        OneSignal.consentGiven(true);
      }
      return granted;
    } catch (e) {
      logger.error('Error requesting PN permissions: $e');
      rethrow;
    }
  }

  @override
  bool getPermissionStatus() => OneSignal.Notifications.permission;

  @override
  Future<bool> openAppNotificationsSettings() async {
    try {
      await AppSettings.openAppSettings(
        type: AppSettingsType.notification,
        asAnotherTask: true,
      );
      return getPermissionStatus();
    } catch (e) {
      logger.error('Error opening app notification settings: $e');
      rethrow;
    }
  }
}
