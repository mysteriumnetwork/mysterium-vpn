import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/repositories/notifications/notifications_repository.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:talker/talker.dart';

class OnesignalNotificationsRepository implements NotificationsRepository {
  OnesignalNotificationsRepository({required this.logger});

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

  @override
  Future<void> login({required String userId, required String userEmail}) async {
    try {
      await OneSignal.login(userId);
      await OneSignal.User.addEmail(userEmail);
    } catch (e) {
      logger.error('Error logging in to OneSignal: $e');
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await OneSignal.logout();
    } catch (e) {
      logger.error('Error logging out from OneSignal: $e');
      rethrow;
    }
  }

  @override
  Future<void> setTags(Map<String, String> tags) async {
    try {
      await OneSignal.User.addTags(tags);
    } catch (e) {
      logger.error('Error setting OneSignal tags: $e');
      rethrow;
    }
  }

  @override
  Stream<PushNotificationsUser> getUser() {
    final controller = StreamController<PushNotificationsUser>();

    // Emit initial state
    _emitCurrentUser(controller, null);

    // Listen for changes
    OneSignal.User.addObserver((state) {
      _emitCurrentUser(controller, state);
    });

    return controller.stream;
  }

  Future<void> _emitCurrentUser(
    StreamController<PushNotificationsUser> controller,
    OSUserChangedState? state,
  ) async {
    try {
      final oneSignalId = await OneSignal.User.getOnesignalId();
      final userId = await OneSignal.User.getExternalId();
      final tags = await OneSignal.User.getTags();
      final current = state?.jsonRepresentation();
      if (!controller.isClosed) {
        controller.add(
          PushNotificationsUser(
            pushNotificationsId: oneSignalId,
            userId: userId,
            tags: tags,
            current: current,
          ),
        );
      }
    } catch (e) {
      logger.error('Error getting OneSignal user/device state: $e');
      if (!controller.isClosed) {
        controller.addError(e);
      }
    }
  }
}
