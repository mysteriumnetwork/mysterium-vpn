import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/repositories/notifications/notifications_repository.dart';
import 'package:mysterium_vpn/repositories/repositories.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:talker/talker.dart';

part 'push_notifications_store.g.dart';

// ignore: library_private_types_in_public_api
class PushNotificationsStore = _PushNotificationsStore with _$PushNotificationsStore;

/// Device-level push concerns: notification permission, the prompt cooldown,
/// and surfacing received/opened notifications.
///
/// Deliberately knows nothing about Notifier — event reporting goes through the
/// repository, which owns the device token, and registration lives in
/// [NotifierRegistrationStore].
abstract class _PushNotificationsStore with Store, Disposeable {
  _PushNotificationsStore(
    this._logger,
    this._notificationsRepository,
    this._analyticsStore,
    this._localDb,
    this._remoteConfigStore, {
    bool Function()? supportsPush,
  }) : _supportsPush = supportsPush ?? isPushSupported {
    _init();
  }

  final List<StreamSubscription<dynamic>> _subscriptions = [];
  final Talker _logger;
  final NotificationsRepository _notificationsRepository;
  final AnalyticsStore _analyticsStore;
  final LocalDBService _localDb;
  final RemoteConfigStore _remoteConfigStore;

  /// Injected so tests can force either answer — the host VM this suite runs on
  /// is macOS, which is itself push-capable.
  final bool Function() _supportsPush;

  bool get supportsPushNotifications => _supportsPush();

  String? lastShownPushNotificationId;

  Future<void> _init() async {
    try {
      await _notificationsRepository.init();
      _setupStreamListeners();
    } catch (e, stack) {
      // Push must never break startup.
      _reportFailure(e, stack, 'store init');
    }
  }

  void _setupStreamListeners() {
    _subscriptions.addAll([
      _createPermissionListener(),
      _createReceivedListener(),
      _createNotificationClickListener(),
    ]);
  }

  StreamSubscription<bool> _createPermissionListener() => _pushNotificationsPermissionStream.listen(
    (granted) {
      try {
        _analyticsStore
          ..setUserProperty(
            AnalyticsUserProperty.fromEnum(
              name: AnalyticsUserPropName.pnPermissionStatus,
              value: granted.toString(),
            ),
          )
          ..logPushNotificationsPermissionsChanged(permissionsGranted: granted);
      } catch (e) {
        _logger.warning('Error tracking push notifications permission change: $e');
      }
    },
    onError: (Object error, StackTrace stack) => _reportFailure(error, stack, 'permission stream'),
  );

  StreamSubscription<PushNotification> _createReceivedListener() =>
      _notificationsRepository.getReceivedStream().listen(
        (notification) {
          // No token or payload body in analytics parameters.
          _analyticsStore.logEvent(
            AnalyticsEvent.pushReceived,
            parameters: {'notification_id': notification.id, 'campaign_id': notification.category},
          );
          unawaited(_report(notification, NotifierEventType.delivered));
        },
        onError: (Object error, StackTrace stack) =>
            _reportFailure(error, stack, 'received stream'),
      );

  StreamSubscription<PushNotification> _createNotificationClickListener() =>
      _notificationsStream.listen(
        (notification) {
          _analyticsStore.logEvent(
            AnalyticsEvent.pushOpened,
            parameters: {'notification_id': notification.id, 'campaign_id': notification.category},
          );
          unawaited(_report(notification, NotifierEventType.open));
        },
        onError: (Object error, StackTrace stack) => _reportFailure(error, stack, 'opened stream'),
      );

  /// Logs and reports a handled failure without marking it a crash, so a
  /// platform surprise is visible in Crashlytics and Sentry rather than silent.
  void _reportFailure(Object error, StackTrace? stack, String what) {
    _logger.warning('Push notifications $what failed: $error');
    try {
      // Synchronous throws from the reporter would escape the caller's catch,
      // so `unawaited` alone is not enough protection here.
      unawaited(
        _analyticsStore
            .logNonFatal(err: error, stack: stack, reason: 'push: $what')
            .catchError((Object _) {}),
      );
    } catch (_) {}
  }

  /// The repository is contractually best-effort, but this runs inside a stream
  /// listener — a throw here would escape into the zone as an unhandled error,
  /// so contain it regardless.
  Future<void> _report(PushNotification notification, NotifierEventType type) async {
    try {
      await _notificationsRepository.reportEvent(notification, type);
    } catch (e) {
      _logger.warning('Reporting the ${type.name} event failed: $e');
    }
  }

  @readonly
  late ObservableStream<bool> _pushNotificationsPermissionStream = ObservableStream(
    _notificationsRepository.getPermissionStatusStream(),
  );

  @readonly
  late ObservableStream<PushNotification> _notificationsStream = ObservableStream(
    _notificationsRepository.getNotificationsStream(),
  );

  @computed
  bool get pushNotificationsPermissionGranted {
    try {
      return _pushNotificationsPermissionStream.value ??
          _notificationsRepository.getPermissionStatus();
    } catch (e) {
      // Stream may be closed if the repository was disposed.
      return _notificationsRepository.getPermissionStatus();
    }
  }

  @computed
  PushNotification? get lastNotification => _notificationsStream.value;

  @action
  Future<void> updatePushNotificationsPermissions() async {
    if (!supportsPushNotifications) {
      return;
    }

    try {
      if (await _notificationsRepository.canRequestPermission()) {
        await _requestPermission();
      } else {
        await _notificationsRepository.openAppNotificationsSettings();
      }
    } catch (e, stack) {
      // Surfaced to the user as a snackbar by the settings view, so it is worth
      // reporting rather than only logging.
      _reportFailure(e, stack, 'opening system notification settings');
      rethrow;
    }
  }

  @action
  Future<void> setPushNotificationsShown({required bool userAllowed}) async {
    if (!supportsPushNotifications) {
      return;
    }

    if (userAllowed) {
      try {
        final granted = await _requestPermission();
        _logger.info('Push notifications permission request result: $granted');
      } catch (e, stack) {
        _reportFailure(e, stack, 'permission request');
      }
    }

    try {
      await _localDb.setPushNotificationsPromptLastShownAt(DateTime.now());
    } catch (e) {
      _logger.warning('Error saving push notifications prompt timestamp: $e');
    }
  }

  Future<bool> _requestPermission() async {
    _analyticsStore.logEvent(AnalyticsEvent.pushPermissionRequested);
    return _notificationsRepository.requestPermission();
  }

  @action
  Future<bool> shouldShowPushNotificationsPermissionPrompt() async {
    if (!supportsPushNotifications) {
      return false;
    }

    try {
      if (await _isInCooldownPeriod()) {
        return false;
      }

      if (_notificationsRepository.getPermissionStatus()) {
        return false;
      }

      return await _notificationsRepository.canRequestPermission();
    } catch (e) {
      _logger.warning('Error checking if should show PN prompt: $e');
      return false;
    }
  }

  Future<bool> _isInCooldownPeriod() async {
    final cooldownHours = _remoteConfigStore.pushNotifPermissionPromptCooldown;
    final lastShownAt = await _localDb.getPushNotificationsPromptLastShownAt();

    if (lastShownAt == null) {
      return false;
    }

    final nextAllowedTime = lastShownAt.add(Duration(hours: cooldownHours));
    return nextAllowedTime.isAfter(DateTime.now());
  }

  @override
  Future<void> dispose() async {
    for (final subscription in _subscriptions) {
      try {
        await subscription.cancel();
      } catch (e) {
        _logger.warning('Error canceling subscription: $e');
      }
    }
    _subscriptions.clear();

    _logger.debug('PushNotificationsStore disposed');
  }
}
