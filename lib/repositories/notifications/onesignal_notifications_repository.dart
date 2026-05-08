import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
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
  bool _permissionObserverRegistered = false; // Track if observer is registered globally
  bool _observersInitialized = false;
  bool _isInitializing = false;

  @override
  Future<void> init() async {
    if (_isInitializing || _observersInitialized) {
      return;
    }

    _isInitializing = true;
    try {
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

      // Handle foreground notifications
      OneSignal.Notifications.addForegroundWillDisplayListener((event) {
        event.preventDefault();
        event.notification.display();
      });

      // Opt-in when permission is granted after login
      OneSignal.Notifications.addPermissionObserver((granted) {
        if (granted && !(OneSignal.User.pushSubscription.optedIn ?? false)) {
          OneSignal.User.pushSubscription.optIn();
        }
      });

      // One-shot reconciliation: addPermissionObserver fires only on change,
      // so if the user already had permission granted before init() ran (the
      // common case after a relaunch or system-settings grant), the observer
      // never fires and the user is never opted in. Reconcile the current
      // state explicitly.
      if (OneSignal.Notifications.permission &&
          !(OneSignal.User.pushSubscription.optedIn ?? false)) {
        OneSignal.User.pushSubscription.optIn();
      }

      _observersInitialized = true;
    } finally {
      _isInitializing = false;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await OneSignal.logout();
      _emitCurrentUser();
    } catch (e) {
      logger.error('Error during OneSignal logout: $e');
      rethrow;
    }
  }

  @override
  Future<bool> requestPermission() async {
    // If permission is already granted, there is no system prompt to show.
    // Just ensure the device is opted in (canRequest() returns false in this
    // case, so without this branch we'd throw and never opt in).
    if (OneSignal.Notifications.permission) {
      if (!(OneSignal.User.pushSubscription.optedIn ?? false)) {
        OneSignal.User.pushSubscription.optIn();
      }
      return true;
    }

    if (!(await OneSignal.Notifications.canRequest())) {
      throw RequestPushNotificationsPermissionsNotAllowed();
    }

    final granted = await OneSignal.Notifications.requestPermission(false);

    if (granted) {
      logger.info('Push notifications permission granted by the user.');
      // Opt-in if permission granted
      OneSignal.User.pushSubscription.optIn();
    } else {
      logger.info('Push notifications permission not granted by the user.');
    }

    return granted;
  }

  @override
  bool getPermissionStatus() => OneSignal.Notifications.permission;

  @override
  Future<void> openAppNotificationsSettings() async {
    await AppSettings.openAppSettings(type: AppSettingsType.notification, asAnotherTask: true);
  }

  @override
  Future<void> login({required String userId, required String userEmail}) async {
    await OneSignal.login(userId);
    await OneSignal.User.addEmail(userEmail);
    if (OneSignal.Notifications.permission && !(OneSignal.User.pushSubscription.optedIn ?? false)) {
      OneSignal.User.pushSubscription.optIn();
    }
    _emitCurrentUser();
  }

  @override
  Future<void> setTags(Map<String, String> tags) async {
    try {
      await OneSignal.User.addTags(tags);
      logger.debug('OneSignal tags set: $tags');
      // Emit updated user state after tags change
      await _emitCurrentUser();
    } catch (e) {
      logger.error('Error setting OneSignal tags: $e');
      rethrow;
    }
  }

  @override
  Stream<PushNotificationsUser> getUser() {
    _controller ??= StreamController<PushNotificationsUser>.broadcast();
    _emitCurrentUser();
    return _controller?.stream ?? const Stream<PushNotificationsUser>.empty();
  }

  Future<void> _emitCurrentUser() async {
    if (_controller == null || _controller!.isClosed) {
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
      if (_controller == null || _controller!.isClosed) {
        return;
      }

      try {
        _controller!.add(
          PushNotificationsUser(
            pushNotificationsId: oneSignalId,
            userId: userId,
            tags: {...tags, ...subscriptionData},
          ),
        );
      } catch (e) {
        // Handle race condition where stream was closed between check and add
        logger.debug('Stream closed before emission could complete: $e');
      }
    } catch (e) {
      logger.error('Error emitting OneSignal user/device state: $e');
      if (!(_controller?.isClosed ?? true)) {
        try {
          _controller!.addError(e);
        } catch (_) {
          // Stream may have been closed during error reporting
          logger.debug('Failed to add error to stream - stream already closed');
        }
      }
    }
  }

  @override
  Stream<bool> getPermissionStatusStream() {
    if (_permissionStatusController == null) {
      // Permission controller doesn't close on subscription cancel since permissions are device-level
      // It persists across logout/login cycles
      _permissionStatusController = StreamController<bool>.broadcast();

      // Register listener FIRST before emitting any values
      _initializePermissionListener();

      // Emit initial permission status
      if (_permissionStatusController != null && !_permissionStatusController!.isClosed) {
        _permissionStatusController!.add(getPermissionStatus());
      }
    }

    return _permissionStatusController?.stream ?? const Stream<bool>.empty();
  }

  void _initializePermissionListener() {
    if (_permissionObserverRegistered) {
      return;
    }

    try {
      OneSignal.Notifications.addPermissionObserver((status) {
        // Controller persists across logout/login since permissions are device-level
        if (_permissionStatusController != null && !_permissionStatusController!.isClosed) {
          try {
            _permissionStatusController!.add(status);
          } catch (_) {
            // Handle race condition where stream was closed between check and add
            logger.debug('Permission stream closed before emission could complete');
          }
        }
      });
      _permissionObserverRegistered = true; // Mark as registered globally
      logger.debug('OneSignal permission status observer registered');
    } catch (e) {
      logger.error('Failed to register permission observer: $e');
    }
  }

  @override
  Future<bool> canRequestPermission() async {
    try {
      return await OneSignal.Notifications.canRequest();
    } catch (e) {
      logger.error('Error checking if can request PN permissions: $e');
      // Return false as a safe default, but log the error
      return false;
    }
  }

  @override
  Stream<PushNotification> getNotificationsStream() {
    _notificationsController ??= StreamController<PushNotification>.broadcast();
    _initializeNotificationListener();
    return _notificationsController?.stream ?? const Stream<PushNotification>.empty();
  }

  void _initializeNotificationListener() {
    if (_notificationListenerInitialized) {
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
    if (_notificationsController?.isClosed ?? true) {
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
      try {
        _notificationsController!.add(pushNotification);
      } catch (_) {
        // Handle race condition where stream was closed between check and add
        logger.debug('Notifications stream closed before emission could complete');
      }
    } catch (e) {
      logger.error('Error processing notification click: $e');
      if (!(_notificationsController?.isClosed ?? true)) {
        try {
          _notificationsController!.addError(e);
        } catch (_) {
          // Stream may have been closed during error reporting
          logger.debug('Failed to add error to stream - stream already closed');
        }
      }
    }
  }

  /// Dispose of all resources and close all streams.
  /// Call this when the repository is no longer needed.
  @override
  Future<void> dispose() async {
    await _controller?.close();
    _controller = null;

    await _notificationsController?.close();
    _notificationsController = null;

    await _permissionStatusController?.close();
    _permissionStatusController = null;

    logger.debug('OnesignalNotificationsRepository disposed');
  }
}
