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
  StreamController<PushNotification>? _notificationsController;
  StreamController<bool>? _permissionStatusController;
  bool _notificationListenerInitialized = false;
  bool _permissionListenerInitialized = false;
  bool _observersInitialized = false;
  bool _isInitializing = false;
  bool _isDisposed = false;

  @override
  Future<void> init() async {
    if (_isDisposed) {
      throw StateError('Cannot initialize a disposed repository');
    }

    if (_observersInitialized || _isInitializing) {
      return;
    }

    _isInitializing = true;
    try {
      if (kDebugMode) {
        await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
      }

      OneSignal.initialize(Env.oneSignalAppId);

      debugPrint('INIT: OneSignal initialized');

      // Setup push subscription observer
      OneSignal.User.pushSubscription.addObserver((state) {
        if (_isDisposed) {
          return;
        }
        logger.info('PushSubscription changed: ${state.current.jsonRepresentation()}');
        _emitCurrentUser(); // update stream whenever subscription changes
      });

      // Setup user observer
      OneSignal.User.addObserver((state) {
        if (_isDisposed) {
          return;
        }
        logger.info('User state changed: ${state.current.jsonRepresentation()}');
        _emitCurrentUser(); // update stream whenever user changes
      });

      // Handle foreground notifications
      OneSignal.Notifications.addForegroundWillDisplayListener((event) {
        if (_isDisposed) {
          return;
        }
        event.preventDefault();
        event.notification.display();
      });

      // Handle in-app message clicks
      OneSignal.InAppMessages.addClickListener((event) {
        if (_isDisposed) {
          return;
        }
        final debugLabelString =
            "In App Message Clicked: \n${event.result.jsonRepresentation().replaceAll(r"\n", "\n")}";
        debugPrint(debugLabelString);
      });

      _observersInitialized = true;
    } finally {
      _isInitializing = false;
    }
  }

  @override
  Future<bool> requestPermission() async {
    _checkDisposed();

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
  }

  Future<bool> _isSubscribed() async {
    final subscription = OneSignal.User.pushSubscription;
    return (subscription.optedIn ?? false) && getPermissionStatus() && (subscription.token != null);
  }

  @override
  bool getPermissionStatus() => OneSignal.Notifications.permission;

  @override
  Future<void> openAppNotificationsSettings() async {
    _checkDisposed();

    await AppSettings.openAppSettings(
      type: AppSettingsType.notification,
      asAnotherTask: true,
    );
  }

  @override
  Future<void> login({required String userId, required String userEmail}) async {
    _checkDisposed();

    await OneSignal.login(userId);
    await OneSignal.User.addEmail(userEmail);
  }

  @override
  Future<void> logout() async {
    _checkDisposed();
    await OneSignal.logout();
  }

  @override
  Future<void> setTags(Map<String, String> tags) async {
    _checkDisposed();
    await OneSignal.User.addTags(tags);
  }

  @override
  Stream<PushNotificationsUser> getUser() {
    _checkDisposed();

    _controller ??= StreamController<PushNotificationsUser>.broadcast();
    _emitCurrentUser();
    return _controller!.stream;
  }

  Future<void> _emitCurrentUser() async {
    if (_isDisposed || _controller == null || _controller!.isClosed) {
      return;
    }

    try {
      // Capture all state atomically to avoid race conditions
      final subscription = OneSignal.User.pushSubscription;
      final subscriptionData = {
        'optedIn': (subscription.optedIn ?? false).toString(),
        'token': subscription.token ?? '',
        'id': subscription.id ?? '',
      };

      // Fetch async data
      final oneSignalId = await OneSignal.User.getOnesignalId();
      final userId = await OneSignal.User.getExternalId();
      final tags = await OneSignal.User.getTags();

      // Check again after async operations
      if (_isDisposed || _controller == null || _controller!.isClosed) {
        return;
      }

      _controller!.add(
        PushNotificationsUser(
          pushNotificationsId: oneSignalId,
          userId: userId,
          tags: {
            ...tags,
            ...subscriptionData,
          },
        ),
      );
    } catch (e) {
      logger.error('Error emitting OneSignal user/device state: $e');
      if (!(_controller?.isClosed ?? true)) {
        _controller!.addError(e);
      }
    }
  }

  @override
  Stream<bool> getPermissionStatusStream() async* {
    _checkDisposed();

    _permissionStatusController ??= StreamController<bool>.broadcast();
    _initializePermissionListener();

    // Emit initial status once
    yield getPermissionStatus();

    // Then yield all future changes
    yield* _permissionStatusController!.stream;
  }

  void _initializePermissionListener() {
    if (_permissionListenerInitialized || _isDisposed) {
      return;
    }

    try {
      OneSignal.Notifications.addPermissionObserver((_) {
        if (_isDisposed || (_permissionStatusController?.isClosed ?? true)) {
          return;
        }
        final current = getPermissionStatus();
        debugPrint('INIT: Current permission status: $current');
        _permissionStatusController!.add(current);
      });
      _permissionListenerInitialized = true;
      logger.debug('OneSignal permission status listener initialized');
    } catch (e) {
      logger.error('Failed to initialize permission listener: $e');
    }
  }

  @override
  Future<bool> canRequestPermission() async {
    _checkDisposed();

    try {
      return await OneSignal.Notifications.canRequest();
    } catch (e) {
      logger.error('Error checking if can request PN permissions: $e');
      // Return false as a safe default, but log the error
      return false;
    }
  }

  @override
  Stream<PushNotification> getNotificationsStream() async* {
    _checkDisposed();

    _notificationsController ??= StreamController<PushNotification>.broadcast();
    _initializeNotificationListener();
    yield* _notificationsController!.stream;
  }

  void _initializeNotificationListener() {
    if (_notificationListenerInitialized || _isDisposed) {
      return;
    }

    try {
      OneSignal.Notifications.addClickListener(_handleNotificationClick);
      _notificationListenerInitialized = true;
      logger.debug('OneSignal notification click listener initialized');
    } catch (e) {
      logger.error('Failed to initialize notification listener: $e');
    }
  }

  void _handleNotificationClick(OSNotificationClickEvent event) {
    if (_isDisposed || (_notificationsController?.isClosed ?? true)) {
      return;
    }

    try {
      final notification = event.notification;
      final pushNotification = PushNotification(
        id: notification.notificationId,
        title: notification.title,
        body: notification.body,
        additionalData: notification.additionalData,
        launchUrl: notification.launchUrl,
        rawPayload: notification.rawPayload,
        category: notification.category,
      );
      _notificationsController!.add(pushNotification);
    } catch (e) {
      logger.error('Error processing notification click: $e');
      if (!(_notificationsController?.isClosed ?? true)) {
        _notificationsController!.addError(e);
      }
    }
  }

  /// Dispose of all resources and close all streams.
  /// Call this when the repository is no longer needed.
  Future<void> dispose() async {
    if (_isDisposed) {
      return;
    }

    _isDisposed = true;

    await _controller?.close();
    _controller = null;

    await _notificationsController?.close();
    _notificationsController = null;

    await _permissionStatusController?.close();
    _permissionStatusController = null;

    logger.debug('OnesignalNotificationsRepository disposed');
  }

  void _checkDisposed() {
    if (_isDisposed) {
      throw StateError('OnesignalNotificationsRepository has been disposed');
    }
  }
}
