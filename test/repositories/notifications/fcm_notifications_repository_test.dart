import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/repositories/notifications/fcm_notifications_repository.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';

import 'fcm_notifications_repository_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FirebaseMessaging>(),
  MockSpec<FlutterLocalNotificationsPlugin>(),
  MockSpec<NotifierService>(),
  MockSpec<AnalyticsStore>(),
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Talker logger;
  late SharedPreferenceService prefs;
  late MockNotifierService notifierService;
  late MockAnalyticsStore analyticsStore;
  late MockFirebaseMessaging messaging;
  late MockFlutterLocalNotificationsPlugin localNotifications;

  setUp(() async {
    logger = Talker();
    notifierService = MockNotifierService();
    analyticsStore = MockAnalyticsStore();
    messaging = MockFirebaseMessaging();
    localNotifications = MockFlutterLocalNotificationsPlugin();
    SharedPreferences.setMockInitialValues({});
    prefs = SharedPreferenceService.instance;
    await prefs.init();
  });

  NotificationSettings settings(AuthorizationStatus status) => NotificationSettings(
    alert: AppleNotificationSetting.enabled,
    announcement: AppleNotificationSetting.disabled,
    authorizationStatus: status,
    badge: AppleNotificationSetting.enabled,
    carPlay: AppleNotificationSetting.disabled,
    lockScreen: AppleNotificationSetting.enabled,
    notificationCenter: AppleNotificationSetting.enabled,
    showPreviews: AppleShowPreviewSetting.always,
    timeSensitive: AppleNotificationSetting.disabled,
    criticalAlert: AppleNotificationSetting.disabled,
    sound: AppleNotificationSetting.enabled,
    providesAppNotificationSettings: AppleNotificationSetting.disabled,
  );

  FcmNotificationsRepository build({bool isApple = true}) => FcmNotificationsRepository(
    logger: logger,
    messaging: messaging,
    localNotifications: localNotifications,
    notifierService: notifierService,
    analyticsStore: analyticsStore,
    isApple: isApple,
  );

  void stubPermissionRequest({NotificationSettings? result, Object? error}) {
    final stub = when(
      messaging.requestPermission(
        alert: anyNamed('alert'),
        announcement: anyNamed('announcement'),
        badge: anyNamed('badge'),
        carPlay: anyNamed('carPlay'),
        criticalAlert: anyNamed('criticalAlert'),
        provisional: anyNamed('provisional'),
        sound: anyNamed('sound'),
        providesAppNotificationSettings: anyNamed('providesAppNotificationSettings'),
      ),
    );
    if (error != null) {
      stub.thenThrow(error);
    } else {
      stub.thenAnswer((_) async => result!);
    }
  }

  group('mapRemoteMessage', () {
    test('maps a complete Notifier payload', () {
      final result = mapRemoteMessage(
        const RemoteMessage(
          messageId: 'msg-1',
          notification: RemoteNotification(title: 'Title', body: 'Body'),
          data: {
            'deepLink': '/main/news-center?id=7',
            'campaignId': 'campaign-1',
            'journeyStepId': 'step-1',
          },
        ),
        logger: logger,
      );

      expect(result, isNotNull);
      expect(result!.id, 'msg-1');
      expect(result.title, 'Title');
      expect(result.body, 'Body');
      expect(result.launchUrl, '/main/news-center?id=7');
      expect(result.category, 'campaign-1');
      expect(result.additionalData?['journeyStepId'], 'step-1');
    });

    test('prefers the notification block over data for title and body', () {
      final result = mapRemoteMessage(
        const RemoteMessage(
          messageId: 'msg-1',
          notification: RemoteNotification(title: 'From block', body: 'Also block'),
          data: {'title': 'From data', 'body': 'Also data'},
        ),
        logger: logger,
      );

      expect(result?.title, 'From block');
      expect(result?.body, 'Also block');
    });

    test('falls back to data for title and body on a data-only message', () {
      final result = mapRemoteMessage(
        const RemoteMessage(messageId: 'msg-1', data: {'title': 'T', 'body': 'B'}),
        logger: logger,
      );

      expect(result?.title, 'T');
      expect(result?.body, 'B');
    });

    test('accepts the legacy redirect_url key when deepLink is absent', () {
      final result = mapRemoteMessage(
        const RemoteMessage(messageId: 'msg-1', data: {'redirect_url': '/main/settings'}),
        logger: logger,
      );

      expect(result?.launchUrl, '/main/settings');
    });

    test('prefers deepLink when both keys are present', () {
      final result = mapRemoteMessage(
        const RemoteMessage(messageId: 'msg-1', data: {'deepLink': '/a', 'redirect_url': '/b'}),
        logger: logger,
      );

      expect(result?.launchUrl, '/a');
    });

    test('an empty payload maps to nulls rather than throwing', () {
      final result = mapRemoteMessage(const RemoteMessage(), logger: logger);

      expect(result, isNotNull);
      expect(result!.id, isNull);
      expect(result.title, isNull);
      expect(result.body, isNull);
      expect(result.launchUrl, isNull);
      expect(result.category, isNull);
    });

    test('a wrong-typed deepLink is treated as absent, not coerced', () {
      final result = mapRemoteMessage(
        const RemoteMessage(messageId: 'msg-1', data: {'deepLink': 42}),
        logger: logger,
      );

      expect(result?.launchUrl, isNull);
    });

    test('an empty-string deepLink is treated as absent', () {
      final result = mapRemoteMessage(
        const RemoteMessage(messageId: 'msg-1', data: {'deepLink': ''}),
        logger: logger,
      );

      expect(result?.launchUrl, isNull);
    });

    test('a wrong-typed campaignId is treated as absent', () {
      final result = mapRemoteMessage(
        const RemoteMessage(messageId: 'msg-1', data: {'campaignId': <String, String>{}}),
        logger: logger,
      );

      expect(result?.category, isNull);
    });

    test('keeps the raw payload for diagnostics', () {
      final result = mapRemoteMessage(
        const RemoteMessage(messageId: 'msg-1', data: {'deepLink': '/a'}),
        logger: logger,
      );

      expect(result?.rawPayload?['messageId'], 'msg-1');
      expect(result?.rawPayload?['data'], {'deepLink': '/a'});
    });
  });

  group('permissions', () {
    late FcmNotificationsRepository repository;

    setUp(() {
      repository = build();
    });

    tearDown(() => repository.dispose());

    test('authorized maps to granted', () async {
      when(
        messaging.getNotificationSettings(),
      ).thenAnswer((_) async => settings(AuthorizationStatus.authorized));

      expect(await repository.refreshPermissionStatus(), isTrue);
      expect(repository.getPermissionStatus(), isTrue);
    });

    test('provisional maps to granted', () async {
      when(
        messaging.getNotificationSettings(),
      ).thenAnswer((_) async => settings(AuthorizationStatus.provisional));

      expect(await repository.refreshPermissionStatus(), isTrue);
    });

    test('denied maps to not granted', () async {
      when(
        messaging.getNotificationSettings(),
      ).thenAnswer((_) async => settings(AuthorizationStatus.denied));

      expect(await repository.refreshPermissionStatus(), isFalse);
    });

    test('notDetermined maps to not granted', () async {
      when(
        messaging.getNotificationSettings(),
      ).thenAnswer((_) async => settings(AuthorizationStatus.notDetermined));

      expect(await repository.refreshPermissionStatus(), isFalse);
    });

    test('a status change is emitted on the permission stream', () async {
      when(
        messaging.getNotificationSettings(),
      ).thenAnswer((_) async => settings(AuthorizationStatus.authorized));

      final emitted = repository.getPermissionStatusStream().first;
      await repository.refreshPermissionStatus();

      expect(await emitted, isTrue);
    });

    test('canRequestPermission is true only while undetermined', () async {
      when(
        messaging.getNotificationSettings(),
      ).thenAnswer((_) async => settings(AuthorizationStatus.notDetermined));
      expect(await repository.canRequestPermission(), isTrue);

      when(
        messaging.getNotificationSettings(),
      ).thenAnswer((_) async => settings(AuthorizationStatus.denied));
      expect(await repository.canRequestPermission(), isFalse);

      when(
        messaging.getNotificationSettings(),
      ).thenAnswer((_) async => settings(AuthorizationStatus.authorized));
      expect(await repository.canRequestPermission(), isFalse);
    });

    test('canRequestPermission is false when the platform call throws', () async {
      when(messaging.getNotificationSettings()).thenThrow(StateError('boom'));

      expect(await repository.canRequestPermission(), isFalse);
    });

    test('requestPermission returns the resulting authorization', () async {
      stubPermissionRequest(result: settings(AuthorizationStatus.authorized));

      expect(await repository.requestPermission(), isTrue);
    });

    test('a throwing permission request keeps the last known status', () async {
      stubPermissionRequest(error: StateError('boom'));

      expect(await repository.requestPermission(), isFalse);
    });
  });

  group('token', () {
    late FcmNotificationsRepository repository;

    setUp(() {
      repository = build();
    });

    tearDown(() => repository.dispose());

    test('there is no token before one is minted', () {
      expect(repository.currentToken, isNull);
    });

    test('clearToken deletes the FCM token and cancels shown notifications', () async {
      when(messaging.deleteToken()).thenAnswer((_) async {});
      when(localNotifications.cancelAll()).thenAnswer((_) async {});

      await repository.clearToken();

      verify(messaging.deleteToken()).called(1);
      verify(localNotifications.cancelAll()).called(1);
      expect(repository.currentToken, isNull);
    });

    test('clearToken still cancels notifications when deleting the token fails', () async {
      when(messaging.deleteToken()).thenThrow(StateError('boom'));
      when(localNotifications.cancelAll()).thenAnswer((_) async {});

      await expectLater(repository.clearToken(), completes);

      verify(localNotifications.cancelAll()).called(1);
    });
  });

  group('opened notifications', () {
    late FcmNotificationsRepository repository;

    setUp(() {
      repository = build();
    });

    tearDown(() => repository.dispose());

    test('a tap is delivered to a live subscriber', () async {
      final opened = repository.getNotificationsStream().first;
      await pumpEventQueue();

      repository.handleOpened(
        const RemoteMessage(messageId: 'msg-1', data: {'deepLink': '/main/settings'}),
      );

      expect((await opened).launchUrl, '/main/settings');
    });

    test('a tap that arrives before anyone subscribes is replayed, not dropped', () async {
      // The cold-launch case: getInitialMessage resolves during init(), long
      // before PushNotificationsStore builds its ObservableStream.
      repository.handleOpened(
        const RemoteMessage(messageId: 'msg-1', data: {'deepLink': '/main/news-center?id=9'}),
      );

      final first = await repository.getNotificationsStream().first;

      expect(first.launchUrl, '/main/news-center?id=9');
    });

    test('a replayed tap is delivered only once', () async {
      repository.handleOpened(const RemoteMessage(messageId: 'msg-1', data: {'deepLink': '/a'}));
      await repository.getNotificationsStream().first;

      final second = repository.getNotificationsStream().first.timeout(
        const Duration(milliseconds: 50),
        onTimeout: () => throw TimeoutException('nothing replayed'),
      );

      await expectLater(second, throwsA(isA<TimeoutException>()));
    });

    test('a wrong-typed deep link emits with no link instead of throwing', () async {
      final emitted = <PushNotification>[];
      repository.getNotificationsStream().listen(emitted.add);
      await pumpEventQueue();

      repository.handleOpened(const RemoteMessage(data: {'deepLink': 42}));
      await pumpEventQueue();

      // Emitted, but with no target — the router's inbox fallback takes over.
      expect(emitted, hasLength(1));
      expect(emitted.single.launchUrl, isNull);
    });
  });

  group('Android permission requestability', () {
    late FcmNotificationsRepository repository;

    setUp(() => repository = build(isApple: false));
    tearDown(() => repository.dispose());

    Future<bool> canRequestWith(AuthorizationStatus status) async {
      when(messaging.getNotificationSettings()).thenAnswer((_) async => settings(status));
      return repository.canRequestPermission();
    }

    test('can request while undetermined', () async {
      expect(await canRequestWith(AuthorizationStatus.notDetermined), isTrue);
    });

    // Android 13+ may still surface another prompt after a first denial.
    test('can still request after a non-permanent denial', () async {
      expect(await canRequestWith(AuthorizationStatus.denied), isTrue);
    });

    test('cannot request once permanently denied', () async {
      expect(await canRequestWith(AuthorizationStatus.deniedPermanently), isFalse);
    });

    test('cannot request when already authorized', () async {
      expect(await canRequestWith(AuthorizationStatus.authorized), isFalse);
    });
  });

  group('Apple permission requestability', () {
    late FcmNotificationsRepository repository;

    setUp(() => repository = build());
    tearDown(() => repository.dispose());

    Future<bool> canRequestWith(AuthorizationStatus status) async {
      when(messaging.getNotificationSettings()).thenAnswer((_) async => settings(status));
      return repository.canRequestPermission();
    }

    test('can request while undetermined', () async {
      expect(await canRequestWith(AuthorizationStatus.notDetermined), isTrue);
    });

    // Apple has no re-prompt: a denial is final and reported as `denied`.
    test('cannot request after a denial', () async {
      expect(await canRequestWith(AuthorizationStatus.denied), isFalse);
    });

    test('cannot request when provisionally authorized', () async {
      expect(await canRequestWith(AuthorizationStatus.provisional), isFalse);
    });
  });

  group('reportEvent', () {
    late FcmNotificationsRepository repository;

    setUp(() {
      repository = build();
      when(
        notifierService.recordEvent(
          token: anyNamed('token'),
          type: anyNamed('type'),
          campaignId: anyNamed('campaignId'),
        ),
      ).thenAnswer((_) async {});
    });

    tearDown(() => repository.dispose());

    PushNotification withCampaign(String? campaignId) => PushNotification(
      id: 'msg-1',
      title: 'T',
      body: 'B',
      launchUrl: null,
      additionalData: const {},
      rawPayload: null,
      category: campaignId,
    );

    test('skips reporting when the payload carries no campaign', () async {
      await repository.reportEvent(withCampaign(null), NotifierEventType.open);

      verifyNever(
        notifierService.recordEvent(
          token: anyNamed('token'),
          type: anyNamed('type'),
          campaignId: anyNamed('campaignId'),
        ),
      );
    });

    test('skips reporting when there is no device token', () async {
      // init() never ran, so the repository holds no token to attribute to.
      await repository.reportEvent(withCampaign('campaign-1'), NotifierEventType.delivered);

      verifyNever(
        notifierService.recordEvent(
          token: anyNamed('token'),
          type: anyNamed('type'),
          campaignId: anyNamed('campaignId'),
        ),
      );
    });

    test('a failing report is swallowed — it must not affect the notification', () async {
      when(
        notifierService.recordEvent(
          token: anyNamed('token'),
          type: anyNamed('type'),
          campaignId: anyNamed('campaignId'),
        ),
      ).thenThrow(const NotifierException(category: 'network'));

      await expectLater(
        repository.reportEvent(withCampaign('campaign-1'), NotifierEventType.open),
        completes,
      );
    });
  });

  group('token stream', () {
    late FcmNotificationsRepository repository;

    setUp(() => repository = build());
    tearDown(() => repository.dispose());

    test('replays the current token to a listener that attaches late', () async {
      when(messaging.getToken()).thenAnswer((_) async => 'fcm-token');
      when(messaging.onTokenRefresh).thenAnswer((_) => const Stream<String>.empty());

      // The registration store subscribes before init() resolves the first
      // token; onTokenRefresh never fires for it, so without a replay the
      // device would not register until an app resume.
      await repository.primeTokenForTest();

      expect(await repository.tokenStream.first, 'fcm-token');
    });

    test('a null token leaves nothing to replay', () async {
      when(messaging.getToken()).thenAnswer((_) async => null);
      when(messaging.onTokenRefresh).thenAnswer((_) => const Stream<String>.empty());

      await repository.primeTokenForTest();

      expect(repository.currentToken, isNull);
    });
  });

  group('token retry on Apple platforms', () {
    late FcmNotificationsRepository repository;

    setUp(() {
      repository = build();
      when(messaging.onTokenRefresh).thenAnswer((_) => const Stream<String>.empty());
      when(messaging.setAutoInitEnabled(any)).thenAnswer((_) async {});
    });

    tearDown(() => repository.dispose());

    test('forces APNs registration, so a stashed device token reaches FCM', () async {
      when(messaging.getToken()).thenAnswer((_) async => 'fcm-token');

      await repository.primeTokenForTest();

      // The plugin only registers at launch when Firebase is already
      // configured, which it is not here — Firebase init is deferred past the
      // first frame. This call is what recovers it.
      verify(messaging.setAutoInitEnabled(true)).called(1);
    });

    test('skips the APNs nudge on Android, which has no APNs', () async {
      final android = build(isApple: false);
      addTearDown(android.dispose);
      when(messaging.getToken()).thenAnswer((_) async => 'fcm-token');

      await android.primeTokenForTest();

      verifyNever(messaging.setAutoInitEnabled(any));
    });

    test('a failing APNs nudge still lets the token fetch proceed', () async {
      when(messaging.setAutoInitEnabled(any)).thenThrow(StateError('boom'));
      when(messaging.getToken()).thenAnswer((_) async => 'fcm-token');

      await repository.primeTokenForTest();

      expect(repository.currentToken, 'fcm-token');
    });

    test('a throwing getToken at init does not leave the token unobtainable', () async {
      // APNs has not issued a token yet — the normal pre-permission state.
      when(messaging.getToken()).thenThrow(StateError('apns-token-not-set'));
      await repository.primeTokenForTest();
      expect(repository.currentToken, isNull);

      // Granting permission is the first moment a token can be issued.
      when(messaging.getToken()).thenAnswer((_) async => 'fcm-token');
      stubPermissionRequest(result: settings(AuthorizationStatus.authorized));

      expect(await repository.requestPermission(), isTrue);
      expect(repository.currentToken, 'fcm-token');
    });

    test('granting in system settings while backgrounded also recovers it', () async {
      when(messaging.getToken()).thenThrow(StateError('apns-token-not-set'));
      await repository.primeTokenForTest();

      when(messaging.getToken()).thenAnswer((_) async => 'fcm-token');
      when(
        messaging.getNotificationSettings(),
      ).thenAnswer((_) async => settings(AuthorizationStatus.authorized));

      await repository.refreshPermissionStatus();

      expect(repository.currentToken, 'fcm-token');
    });

    test('a recovered token reaches the registration trigger', () async {
      when(messaging.getToken()).thenThrow(StateError('apns-token-not-set'));
      await repository.primeTokenForTest();

      final emitted = repository.tokenStream.first;
      when(messaging.getToken()).thenAnswer((_) async => 'fcm-token');
      stubPermissionRequest(result: settings(AuthorizationStatus.authorized));
      await repository.requestPermission();

      expect(await emitted, 'fcm-token');
    });

    test('does not re-fetch once a token is held', () async {
      when(messaging.getToken()).thenAnswer((_) async => 'fcm-token');
      await repository.primeTokenForTest();
      clearInteractions(messaging);

      when(
        messaging.getNotificationSettings(),
      ).thenAnswer((_) async => settings(AuthorizationStatus.authorized));
      await repository.refreshPermissionStatus();

      verifyNever(messaging.getToken());
    });

    test('a denied permission does not attempt a token fetch', () async {
      when(messaging.getToken()).thenThrow(StateError('apns-token-not-set'));
      await repository.primeTokenForTest();
      clearInteractions(messaging);

      stubPermissionRequest(result: settings(AuthorizationStatus.denied));
      await repository.requestPermission();

      verifyNever(messaging.getToken());
    });
  });

  group('APNs diagnostics', () {
    late FcmNotificationsRepository repository;

    setUp(() {
      repository = build();
      when(messaging.onTokenRefresh).thenAnswer((_) => const Stream<String>.empty());
      when(messaging.setAutoInitEnabled(any)).thenAnswer((_) async {});
    });

    tearDown(() => repository.dispose());

    // The APNs read is logging only and fully guarded, so an unavailable token
    // must not stop the FCM fetch that follows it.
    test('an unavailable APNs token does not stop the token fetch', () async {
      when(messaging.getToken()).thenAnswer((_) async => 'fcm-token');

      await repository.primeTokenForTest();

      expect(repository.currentToken, 'fcm-token');
    });
  });

  group('failure reporting', () {
    late FcmNotificationsRepository repository;

    setUp(() {
      repository = build();
      when(messaging.setAutoInitEnabled(any)).thenAnswer((_) async {});
    });

    tearDown(() => repository.dispose());

    test('a failing permission request is reported non-fatally', () async {
      stubPermissionRequest(error: StateError('boom'));

      await repository.requestPermission();

      verify(
        analyticsStore.logNonFatal(
          err: anyNamed('err'),
          stack: anyNamed('stack'),
          reason: anyNamed('reason'),
        ),
      ).called(1);
    });

    test('a failing permission-status read is reported non-fatally', () async {
      when(messaging.getNotificationSettings()).thenThrow(StateError('boom'));

      await repository.refreshPermissionStatus();

      verify(
        analyticsStore.logNonFatal(
          err: anyNamed('err'),
          stack: anyNamed('stack'),
          reason: anyNamed('reason'),
        ),
      ).called(1);
    });

    test('a failing requestability check is reported and returns false', () async {
      when(messaging.getNotificationSettings()).thenThrow(StateError('boom'));

      expect(await repository.canRequestPermission(), isFalse);
      verify(
        analyticsStore.logNonFatal(
          err: anyNamed('err'),
          stack: anyNamed('stack'),
          reason: anyNamed('reason'),
        ),
      ).called(1);
    });

    test('reporting never throws into the caller', () async {
      when(
        analyticsStore.logNonFatal(
          err: anyNamed('err'),
          stack: anyNamed('stack'),
          reason: anyNamed('reason'),
        ),
      ).thenThrow(StateError('reporting broke'));
      when(messaging.getNotificationSettings()).thenThrow(StateError('boom'));

      await expectLater(repository.refreshPermissionStatus(), completes);
    });
  });
}
