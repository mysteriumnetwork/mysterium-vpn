import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/repositories/notifications/notifications_repository.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:talker/talker.dart';

class OnesignalNotificationsRepository implements NotificationsRepository {
  OnesignalNotificationsRepository({required this.logger});

  final Talker logger;
  StreamController<PushNotificationsUser>? _controller;

  @override
  Future<void> init() async {
    if (kDebugMode) {
      await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    }

    OneSignal.initialize(Env.oneSignalAppId);

    debugPrint('INIT: OneSignal initialized');

    // Setup push subscription observer
    OneSignal.User.pushSubscription.addObserver((state) {
      logger.info('PushSubscription changed: ${state.current.jsonRepresentation()}');
      _emitCurrentUser(); // update stream whenever subscription changes
    });

    // Setup user observer
    OneSignal.User.addObserver((state) {
      logger.info('User state changed: ${state.current.jsonRepresentation()}');
      _emitCurrentUser(); // update stream whenever user changes
    });

    //
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      event.preventDefault();
      event.notification.display();
    });

    OneSignal.Notifications.addClickListener((event) {
      debugPrint(
        'NOTIFICATION CLICK LISTENER CALLED WITH EVENT: ${event.notification.title}',
      );
    });

    OneSignal.InAppMessages.addClickListener((event) {
      final debugLabelString =
          "In App Message Clicked: \n${event.result.jsonRepresentation().replaceAll(r"\n", "\n")}";
      debugPrint(debugLabelString);
    });
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      event.preventDefault();
      event.notification.display();
    });
  }

  @override
  Future<bool> requestPermission() async {
    try {
      if (await _isSubscribed()) {
        return true;
      }

      if (!(await OneSignal.Notifications.canRequest())) {
        throw RequestPushNotificationsPermissionsNotAllowed();
      }

      final granted = await OneSignal.Notifications.requestPermission(false);

      if (granted) {
        logger.info('Push notifications permission granted by the user.');
        // Opt-in if permission granted
        if (!(await _isSubscribed())) {
          OneSignal.User.pushSubscription.optIn();
        }
      } else {
        logger.info('Push notifications permission not granted by the user.');
      }

      return granted;
    } catch (e) {
      logger.error('Error requesting PN permissions: $e');
      rethrow;
    }
  }

  Future<bool> _isSubscribed() async {
    final subscription = OneSignal.User.pushSubscription;
    return (subscription.optedIn ?? false) && getPermissionStatus() && (subscription.token) != null;
  }

  @override
  bool getPermissionStatus() => OneSignal.Notifications.permission;

  @override
  Future<void> openAppNotificationsSettings() async {
    try {
      await AppSettings.openAppSettings(
        type: AppSettingsType.notification,
        asAnotherTask: true,
      );
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
    _controller ??= StreamController<PushNotificationsUser>.broadcast(
      onListen: _emitCurrentUser,
      onCancel: () => _controller?.close(),
    );
    return _controller!.stream;
  }

  Future<void> _emitCurrentUser() async {
    if (_controller == null || _controller!.isClosed) {
      return;
    }

    try {
      final oneSignalId = await OneSignal.User.getOnesignalId();
      final userId = await OneSignal.User.getExternalId();
      final tags = await OneSignal.User.getTags();
      final subscription = OneSignal.User.pushSubscription;
      final current = <String, String>{
        'optedIn': subscription.optedIn.toString(),
        'token': subscription.token ?? '',
        'id': subscription.id ?? '',
      };

      _controller!.add(
        PushNotificationsUser(
          pushNotificationsId: oneSignalId,
          userId: userId,
          tags: {
            ...tags,
            ...current,
          },
        ),
      );
    } catch (e) {
      logger.error('Error emitting OneSignal user/device state: $e');
      _controller!.addError(e);
    }
  }

  @override
  Stream<bool> getPermissionStatusStream() async* {
    await Future.delayed(const Duration(milliseconds: 300));
    final controller = StreamController<bool>();

    // Emit initial status
    final current = getPermissionStatus();
    controller.add(current);

    OneSignal.Notifications.addPermissionObserver((_) {
      if (!controller.isClosed) {
        final current = getPermissionStatus();
        debugPrint('INIT: Current permission status1: $current');
        controller.add(current);
      }
    });

    controller.onCancel = controller.close;

    yield* controller.stream;
  }

  @override
  Future<bool> canRequestPermission() async {
    try {
      return await OneSignal.Notifications.canRequest();
    } catch (e) {
      logger.error('Error checking if can request PN permissions: $e');
      return Future.value(false);
    }
  }
}
