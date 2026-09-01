import 'dart:async';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mysterium_vpn/common/extensions/string.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/repositories/notifications/notifications_repository.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:talker/talker.dart';

/// Android notification channel used for every push. Must match
/// `com.google.firebase.messaging.default_notification_channel_id` in the
/// manifest, or Android silently drops background notifications.
const String pushChannelId = 'mysterium_push';

/// [NotificationsRepository] backed by Firebase Cloud Messaging.
///
/// Foreground display is platform-split: Apple platforms (iOS and macOS) let
/// the system present the notification via
/// `setForegroundNotificationPresentationOptions`, Android has no such hook so
/// we display it ourselves through flutter_local_notifications. Doing both on
/// one platform would show the notification twice.
class FcmNotificationsRepository implements NotificationsRepository {
  FcmNotificationsRepository({
    required Talker logger,
    required NotifierService notifierService,
    required AnalyticsStore analyticsStore,
    FirebaseMessaging? messaging,
    FlutterLocalNotificationsPlugin? localNotifications,
    bool? isApple,
  }) : _logger = logger,
       _notifierService = notifierService,
       _analyticsStore = analyticsStore,
       _messaging = messaging ?? FirebaseMessaging.instance,
       _localNotifications = localNotifications ?? FlutterLocalNotificationsPlugin(),
       _isApple = isApple ?? (Platform.isIOS || Platform.isMacOS);

  final Talker _logger;
  final NotifierService _notifierService;
  final AnalyticsStore _analyticsStore;
  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;
  final bool _isApple;

  final StreamController<PushNotification> _openedController =
      StreamController<PushNotification>.broadcast();
  final StreamController<PushNotification> _receivedController =
      StreamController<PushNotification>.broadcast();
  final StreamController<bool> _permissionController = StreamController<bool>.broadcast();
  final StreamController<String> _tokenController = StreamController<String>.broadcast();

  final List<StreamSubscription<dynamic>> _subscriptions = [];

  String? _currentToken;
  bool _permissionGranted = false;
  bool _initialized = false;

  /// A tap that arrived before anything was listening — in practice the cold
  /// launch from a terminated state, where `getInitialMessage` resolves during
  /// [init] and the broadcast controller would otherwise drop the event.
  /// Replayed to the first subscriber so the target survives.
  PushNotification? _pendingOpened;

  @override
  String? get currentToken => _currentToken;

  /// Replays the current token to a new subscriber before streaming refreshes.
  ///
  /// [init] resolves the first token asynchronously, so a listener attached
  /// before that completes would otherwise never see it — `onTokenRefresh` does
  /// not fire for the initial token. Registration would then wait for an app
  /// resume, which is exactly the cold-start case it must cover.
  @override
  Stream<String> get tokenStream async* {
    final current = _currentToken;
    if (current.isNotNullOrEmpty) {
      yield current!;
    }
    yield* _tokenController.stream;
  }

  @override
  Future<void> init() async {
    if (_initialized) {
      return;
    }
    _initialized = true;

    await _guard('foreground presentation options', () async {
      if (_isApple) {
        await _messaging.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
      }
    });

    await _guard('local notifications init', _initLocalNotifications);
    await _guard('permission status', refreshPermissionStatus);
    await _guard('message listeners', _initMessageListeners);
    await _guard('token', _initToken);
  }

  Future<void> _initLocalNotifications() async {
    if (_isApple) {
      return;
    }
    await _localNotifications.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: _onLocalNotificationTapped,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            pushChannelId,
            'Notifications',
            importance: Importance.high,
          ),
        );
  }

  Future<void> _initMessageListeners() async {
    _subscriptions.addAll([
      FirebaseMessaging.onMessage.listen(_onForegroundMessage, onError: _onStreamError),
      FirebaseMessaging.onMessageOpenedApp.listen(handleOpened, onError: _onStreamError),
    ]);

    // Cold launch from a notification tap. Nothing is listening yet, so this
    // lands in _pendingOpened and is replayed by getNotificationsStream.
    final initial = await _messaging.getInitialMessage();
    if (initial != null) {
      handleOpened(initial);
    }
  }

  /// Resolves the first token and subscribes to refreshes. Visible for testing
  /// because [init]'s other steps touch static `FirebaseMessaging` streams that
  /// cannot be injected.
  @visibleForTesting
  Future<void> primeTokenForTest() => _initToken();

  Future<void> _initToken() async {
    _subscriptions.add(
      _messaging.onTokenRefresh.listen((token) {
        _currentToken = token;
        _emit(_tokenController, token);
      }, onError: _onStreamError),
    );

    await _guard('APNs registration', _forceApnsRegistration);
    await _ensureToken();
  }

  /// Re-asserts APNs registration now that Firebase is configured.
  ///
  /// The plugin registers for remote notifications at launch, but guards it on
  /// `FIRMessaging.isAutoInitEnabled` — and this app initialises Firebase
  /// *after* the first frame, so at launch there is no configured messaging
  /// instance and the guard reads false. Worse, when the APNs device token then
  /// arrives the plugin stashes it privately instead of handing it to FCM,
  /// precisely because auto-init still reads false.
  ///
  /// Setting auto-init explicitly is the only public call that both registers
  /// for remote notifications and flushes that stashed APNs token into FCM, so
  /// a token can finally be minted. iOS happens to win this race; macOS does
  /// not, which is why it never received a token.
  Future<void> _forceApnsRegistration() async {
    if (!_isApple) {
      return;
    }
    await _messaging.setAutoInitEnabled(true);
  }

  /// Fetches the device token unless one is already held.
  ///
  /// Must be retried rather than attempted once: on Apple platforms `getToken`
  /// fails while APNs has not issued a token, which is the normal state before
  /// the user grants notification permission. The plugin emits the *first*
  /// token from inside `getToken` itself — it flags a refresh only while FCM's
  /// token is still nil — so a single failed attempt at [init] would mean
  /// `onTokenRefresh` never fires and the device never gets a token at all.
  Future<void> _ensureToken() async {
    if (_currentToken.isNotNullOrEmpty) {
      return;
    }
    await _logApnsState();
    try {
      final token = await _messaging.getToken();
      // The plugin's own refresh emission may have landed first; don't re-emit.
      if (token.isNullOrEmpty || token == _currentToken) {
        return;
      }
      _currentToken = token;
      _emit(_tokenController, token!);
    } catch (e) {
      // Expected before permission is granted; a later trigger retries.
      _logger.warning('FCM token not available yet: $e');
    }
  }

  /// Logs whether APNs has issued a device token, which is the precondition FCM
  /// cannot mint a token without. Distinguishes "APNs has not answered" from
  /// "the call itself failed" — the two have very different causes and the
  /// plugin reports a registration failure only via NSLog.
  Future<void> _logApnsState() async {
    if (!_isApple) {
      return;
    }
    final result = await readApnsTokenFromPlatform();
    if (result.error != null) {
      _logger.warning('APNs token read failed: ${result.error}');
      return;
    }
    final token = result.token;
    _logger.info(
      token.isNullOrEmpty
          ? 'APNs has not delivered a device token yet — FCM cannot mint one'
          : 'APNs device token present (${token!.length} chars)',
    );
  }

  // ─── Permissions ─────────────────────────────────────────────────────────

  @override
  Future<bool> requestPermission() async {
    try {
      final granted = _applySettings(await _messaging.requestPermission());
      // requestPermission does not itself fetch a token, and on Apple platforms
      // this is the first moment one can be issued.
      if (granted) {
        await _ensureToken();
      }
      return granted;
    } catch (e, stack) {
      _report(e, stack, 'push permission request');
      return _permissionGranted;
    }
  }

  @override
  bool getPermissionStatus() => _permissionGranted;

  @override
  Future<bool> refreshPermissionStatus() async {
    bool granted;
    try {
      granted = _applySettings(await _messaging.getNotificationSettings());
    } catch (e, stack) {
      _report(e, stack, 'reading push permission status');
      return _permissionGranted;
    }
    // Permission may have been granted in system settings while backgrounded,
    // which is the point at which APNs can finally issue a token.
    if (granted) {
      await _ensureToken();
    }
    return granted;
  }

  /// Whether showing the system prompt would actually surface something.
  ///
  /// The only platform split left is what `denied` means. On Android 13+ the OS
  /// may still show another prompt after a first denial, and a permanent refusal
  /// is reported separately as [AuthorizationStatus.deniedPermanently]. Apple
  /// has no such distinction — a denial there is final and reported as `denied`,
  /// so the prompt must not be offered again.
  @override
  Future<bool> canRequestPermission() async {
    try {
      final settings = await _messaging.getNotificationSettings();
      return switch (settings.authorizationStatus) {
        AuthorizationStatus.notDetermined => true,
        AuthorizationStatus.denied => !_isApple,
        AuthorizationStatus.deniedPermanently => false,
        AuthorizationStatus.authorized => false,
        AuthorizationStatus.provisional => false,
      };
    } catch (e, stack) {
      _report(e, stack, 'checking push permission requestability');
      return false;
    }
  }

  @override
  Stream<bool> getPermissionStatusStream() => _permissionController.stream;

  @override
  Future<void> openAppNotificationsSettings() =>
      AppSettings.openAppSettings(type: AppSettingsType.notification, asAnotherTask: true);

  bool _applySettings(NotificationSettings settings) {
    final granted = switch (settings.authorizationStatus) {
      AuthorizationStatus.authorized => true,
      AuthorizationStatus.provisional => true,
      AuthorizationStatus.denied => false,
      AuthorizationStatus.deniedPermanently => false,
      AuthorizationStatus.notDetermined => false,
    };
    if (granted != _permissionGranted) {
      _permissionGranted = granted;
      _emit(_permissionController, granted);
    }
    return granted;
  }

  // ─── Token ───────────────────────────────────────────────────────────────

  @override
  Future<void> clearToken() async {
    _currentToken = null;
    await _guard('delete token', _messaging.deleteToken);
    await _guard('cancel notifications', _localNotifications.cancelAll);
  }

  // ─── Notifications ───────────────────────────────────────────────────────

  @override
  Stream<PushNotification> getNotificationsStream() async* {
    final pending = _pendingOpened;
    _pendingOpened = null;
    if (pending != null) {
      yield pending;
    }
    yield* _openedController.stream;
  }

  @override
  Stream<PushNotification> getReceivedStream() => _receivedController.stream;

  @override
  Future<void> reportEvent(PushNotification notification, NotifierEventType type) async {
    final token = _currentToken;
    final campaignId = notification.category;
    if (token.isNullOrEmpty || campaignId.isNullOrEmpty) {
      return;
    }
    try {
      await _notifierService.recordEvent(token: token!, type: type, campaignId: campaignId);
    } catch (e) {
      // Reporting is best-effort; it must never affect the notification itself.
      _logger.warning('Reporting the ${type.name} event to Notifier failed: $e');
    }
  }

  void _onForegroundMessage(RemoteMessage message) {
    final notification = mapRemoteMessage(
      message,
      logger: _logger,
      onError: _analyticsStore.logNonFatal,
    );
    if (notification == null) {
      return;
    }
    _emit(_receivedController, notification);
    if (!_isApple) {
      unawaited(_displayLocally(message, notification));
    }
  }

  /// Entry point for every notification tap — foreground, background, and the
  /// cold launch. Visible for testing because the FCM callbacks that normally
  /// invoke it are static streams.
  @visibleForTesting
  void handleOpened(RemoteMessage message) {
    final notification = mapRemoteMessage(
      message,
      logger: _logger,
      onError: _analyticsStore.logNonFatal,
    );
    if (notification == null) {
      return;
    }
    _emitOpened(notification);
  }

  /// Buffers instead of dropping when nothing has subscribed yet.
  void _emitOpened(PushNotification notification) {
    if (!_openedController.hasListener) {
      _pendingOpened = notification;
      return;
    }
    _emit(_openedController, notification);
  }

  Future<void> _displayLocally(RemoteMessage message, PushNotification notification) async {
    if (notification.title == null && notification.body == null) {
      return;
    }
    await _guard('display notification', () async {
      await _localNotifications.show(
        id: message.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            pushChannelId,
            'Notifications',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        payload: notification.launchUrl,
      );
    });
  }

  /// Tap on a notification we displayed ourselves while in the foreground.
  void _onLocalNotificationTapped(NotificationResponse response) {
    final launchUrl = response.payload;
    if (launchUrl.isNullOrEmpty) {
      return;
    }
    _emitOpened(
      PushNotification(
        id: response.id?.toString(),
        title: null,
        body: null,
        launchUrl: launchUrl,
        additionalData: null,
        rawPayload: null,
        category: null,
      ),
    );
  }

  // ─── Plumbing ────────────────────────────────────────────────────────────

  void _emit<T>(StreamController<T> controller, T value) {
    if (controller.isClosed) {
      return;
    }
    try {
      controller.add(value);
    } catch (e) {
      _logger.warning('Push stream closed before emission completed: $e');
    }
  }

  void _onStreamError(Object error, [StackTrace? stack]) => _report(error, stack, 'message stream');

  /// Logs and reports a handled failure. Non-fatal: the caller has already
  /// recovered, but the failure must be visible rather than silent.
  void _report(Object error, StackTrace? stack, String what) {
    _logger.warning('Push messaging $what failed: $error');
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

  /// Runs a setup step, swallowing any platform failure.
  ///
  /// Push must never break startup, and these calls cross a platform channel
  /// that can fail in ways we cannot enumerate — a missing plugin on a new
  /// platform, an OS refusing a capability. Reported non-fatally so the failure
  /// is visible in Crashlytics and Sentry without counting as a crash.
  Future<void> _guard(String what, Future<void> Function() action) async {
    try {
      await action();
    } catch (e, stack) {
      _report(e, stack, what);
    }
  }

  @override
  Future<void> dispose() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    _subscriptions.clear();
    await _openedController.close();
    await _receivedController.close();
    await _permissionController.close();
    await _tokenController.close();
    _logger.debug('FcmNotificationsRepository disposed');
  }
}

/// Maps an FCM message onto [PushNotification], tolerating a payload that is
/// missing fields or carries the wrong types. Returns null when the payload is
/// unusable — a malformed push must never crash the app.
@visibleForTesting
PushNotification? mapRemoteMessage(
  RemoteMessage message, {
  required Talker logger,
  Future<void> Function({required Object err, StackTrace? stack, String? reason})? onError,
}) {
  try {
    final data = message.data;
    final notification = message.notification;

    return PushNotification(
      id: message.messageId,
      title: notification?.title ?? _string(data['title']),
      body: notification?.body ?? _string(data['body']),
      // Notifier sends `deepLink`; `redirect_url` is the OneSignal-era key,
      // kept so campaigns authored before the migration still route.
      launchUrl: _string(data['deepLink']) ?? _string(data['redirect_url']),
      additionalData: data,
      rawPayload: {
        'messageId': message.messageId,
        'data': data,
        'notification': {'title': notification?.title, 'body': notification?.body},
      },
      category: _string(data['campaignId']),
    );
  } catch (e, stack) {
    logger.warning('Malformed push payload dropped: $e');
    // A payload we cannot read means a campaign nobody receives — worth
    // reporting rather than silently dropping.
    unawaited(
      onError?.call(err: e, stack: stack, reason: 'push payload mapping') ?? Future.value(),
    );
    return null;
  }
}

/// Non-empty strings only — a numeric or object value for a field we expect to
/// be a string is treated as absent rather than coerced.
String? _string(Object? value) {
  if (value is String && value.isNotEmpty) {
    return value;
  }
  return null;
}

/// Reads the APNs device token, returning either the value or the error text.
///
/// Apple only. FCM cannot mint a token until APNs has issued one, so this is
/// the first thing to check when no FCM token appears.
Future<({String? token, String? error})> readApnsTokenFromPlatform() async {
  try {
    return (token: await FirebaseMessaging.instance.getAPNSToken(), error: null);
  } catch (e) {
    return (token: null, error: e.toString());
  }
}
