import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/repositories/notifications/notifications_repository.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';

import 'notifier_registration_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AuthSessionStore>(),
  MockSpec<RealIPInfoStore>(),
  MockSpec<SubscriptionStore>(),
  MockSpec<NotificationsRepository>(),
  MockSpec<NotifierService>(),
  MockSpec<AnalyticsStore>(),
  MockSpec<Connectivity>(),
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthSessionStore authSessionStore;
  late MockRealIPInfoStore ipInfoStore;
  late MockSubscriptionStore subscriptionStore;
  late MockNotificationsRepository repository;
  late MockNotifierService service;
  late MockAnalyticsStore analyticsStore;
  late MockConnectivity connectivity;
  late SharedPreferenceService prefs;

  late StreamController<String> tokenController;
  late StreamController<bool> permissionController;
  late StreamController<List<ConnectivityResult>> connectivityController;

  NotifierRegistrationStore? store;

  /// Builds the store and lets its `fireImmediately` auth reaction settle.
  /// Arrange the mocks *before* calling this — construction is itself a
  /// registration trigger, which is exactly the app-startup path under test.
  Future<NotifierRegistrationStore> start() async {
    store = NotifierRegistrationStore(
      authSessionStore,
      ipInfoStore,
      subscriptionStore,
      repository,
      service,
      prefs,
      analyticsStore,
      Talker(),
      connectivity: connectivity,
      // NotifierPlatform.current() is null on the host VM.
      platform: () => NotifierPlatform.android,
    );
    await pumpEventQueue();
    return store!;
  }

  NotifierRegistration registration({
    String externalUserId = 'user-1',
    String token = 'fcm-token',
    NotifierPlatform platform = NotifierPlatform.android,
    int contractVersion = kNotifierContractVersion,
    bool pending = false,
  }) => NotifierRegistration(
    externalUserId: externalUserId,
    token: token,
    platform: platform,
    contractVersion: contractVersion,
    pending: pending,
  );

  void expectNoRegisterCall() => verifyNever(
    service.registerDevice(
      externalUserId: anyNamed('externalUserId'),
      token: anyNamed('token'),
      platform: anyNamed('platform'),
    ),
  );

  /// Re-stubs the service to succeed after a test has made it fail.
  void stubServiceSuccess() {
    when(
      service.registerDevice(
        externalUserId: anyNamed('externalUserId'),
        token: anyNamed('token'),
        platform: anyNamed('platform'),
      ),
    ).thenAnswer((_) async {});
    when(
      service.mergeAttributes(
        externalUserId: anyNamed('externalUserId'),
        attributes: anyNamed('attributes'),
      ),
    ).thenAnswer((_) async {});
  }

  void stubRegisterFailure(NotifierException failure) => when(
    service.registerDevice(
      externalUserId: anyNamed('externalUserId'),
      token: anyNamed('token'),
      platform: anyNamed('platform'),
    ),
  ).thenThrow(failure);

  setUp(() async {
    authSessionStore = MockAuthSessionStore();
    ipInfoStore = MockRealIPInfoStore();
    subscriptionStore = MockSubscriptionStore();
    repository = MockNotificationsRepository();
    service = MockNotifierService();
    analyticsStore = MockAnalyticsStore();
    connectivity = MockConnectivity();

    SharedPreferences.setMockInitialValues({});
    prefs = SharedPreferenceService.instance;
    await prefs.init();

    tokenController = StreamController<String>.broadcast();
    permissionController = StreamController<bool>.broadcast();
    connectivityController = StreamController<List<ConnectivityResult>>.broadcast();

    when(repository.tokenStream).thenAnswer((_) => tokenController.stream);
    when(repository.getPermissionStatusStream()).thenAnswer((_) => permissionController.stream);
    when(repository.currentToken).thenReturn('fcm-token');
    when(repository.clearToken()).thenAnswer((_) async {});
    when(repository.refreshPermissionStatus()).thenAnswer((_) async => true);
    when(connectivity.onConnectivityChanged).thenAnswer((_) => connectivityController.stream);

    stubServiceSuccess();

    when(
      authSessionStore.userFuture,
    ).thenAnswer((_) => ObservableFuture.value(AuthUser(userId: 'user-1', username: 'a@b.com')));
    when(ipInfoStore.infoFuture).thenAnswer(
      (_) => ObservableFuture.value(const IPInfo(city: 'Berlin', country: 'DE', ip: '1.2.3.4')),
    );
    when(subscriptionStore.subscriptionFuture).thenAnswer(
      (_) => ObservableFuture.value(
        Subscription(
          active: true,
          planId: 'plan_monthly',
          gateway: 'stripe',
          recurring: true,
          expired: false,
        ),
      ),
    );
  });

  tearDown(() async {
    await store?.dispose();
    store = null;
    await tokenController.close();
    await permissionController.close();
    await connectivityController.close();
  });

  // Env.notifierConfigured is compile-time; the project's test commands always
  // pass the dotenv defines. Asserted rather than used to skip tests, so a run
  // without them fails loudly instead of passing empty.
  test('the run has the notifier defines the store requires', () {
    expect(
      const String.fromEnvironment('NOTIFIER_BASE_URL').isNotEmpty &&
          const String.fromEnvironment('NOTIFIER_PUBLIC_API_KEY').isNotEmpty,
      isTrue,
      reason: 'run with --dart-define-from-file=.env.dev (see the Makefile)',
    );
  });

  group('startup registration', () {
    test('an authenticated session with a token registers without being asked', () async {
      await start();

      verify(
        service.registerDevice(
          externalUserId: 'user-1',
          token: 'fcm-token',
          platform: NotifierPlatform.android,
        ),
      ).called(1);
    });

    test('persists the registration', () async {
      await start();

      expect(prefs.getNotifierRegistration()?.externalUserId, 'user-1');
      expect(prefs.getNotifierRegistration()?.token, 'fcm-token');
      expect(prefs.getNotifierRegistration()?.pending, isFalse);
    });

    test('logs started and succeeded', () async {
      await start();

      verify(
        analyticsStore.logEvent(
          AnalyticsEvent.pushDeviceRegistrationStarted,
          parameters: anyNamed('parameters'),
        ),
      ).called(1);
      verify(
        analyticsStore.logEvent(
          AnalyticsEvent.pushDeviceRegistrationSucceeded,
          parameters: anyNamed('parameters'),
        ),
      ).called(1);
    });

    test('a stored identical registration makes no request at all', () async {
      await prefs.setNotifierRegistration(registration());

      await start();

      expectNoRegisterCall();
    });
  });

  group('duplicate prevention', () {
    test('a repeat sync with an unchanged identity makes no request', () async {
      final store = await start();
      clearInteractions(service);

      await store.syncRegistration();

      expectNoRegisterCall();
    });

    test('a new token re-registers', () async {
      final store = await start();
      clearInteractions(service);

      when(repository.currentToken).thenReturn('fcm-token-2');
      await store.syncRegistration();

      verify(
        service.registerDevice(
          externalUserId: 'user-1',
          token: 'fcm-token-2',
          platform: anyNamed('platform'),
        ),
      ).called(1);
    });

    test('a different user on the same device re-registers the same token', () async {
      final store = await start();
      clearInteractions(service);

      when(
        authSessionStore.userFuture,
      ).thenAnswer((_) => ObservableFuture.value(AuthUser(userId: 'user-2', username: 'c@d.com')));
      await store.syncRegistration();

      verify(
        service.registerDevice(
          externalUserId: 'user-2',
          token: 'fcm-token',
          platform: anyNamed('platform'),
        ),
      ).called(1);
    });

    test('a stored registration from an older contract version re-registers', () async {
      await prefs.setNotifierRegistration(
        registration(contractVersion: kNotifierContractVersion - 1),
      );

      await start();

      verify(
        service.registerDevice(
          externalUserId: anyNamed('externalUserId'),
          token: anyNamed('token'),
          platform: anyNamed('platform'),
        ),
      ).called(1);
      expect(prefs.getNotifierRegistration()?.contractVersion, kNotifierContractVersion);
    });

    test('a stored pending registration is re-attempted even when unchanged', () async {
      await prefs.setNotifierRegistration(registration(pending: true));

      await start();

      verify(
        service.registerDevice(
          externalUserId: anyNamed('externalUserId'),
          token: anyNamed('token'),
          platform: anyNamed('platform'),
        ),
      ).called(1);
      expect(prefs.getNotifierRegistration()?.pending, isFalse);
    });
  });

  group('preconditions', () {
    test('does nothing without an authenticated user', () async {
      when(authSessionStore.userFuture).thenAnswer((_) => ObservableFuture.value(null));

      await start();

      expectNoRegisterCall();
      expect(prefs.getNotifierRegistration(), isNull);
    });

    test('does nothing without an FCM token', () async {
      when(repository.currentToken).thenReturn(null);

      await start();

      expectNoRegisterCall();
    });

    test('does nothing with an empty FCM token', () async {
      when(repository.currentToken).thenReturn('');

      await start();

      expectNoRegisterCall();
    });

    test('does nothing on a platform with no push transport', () async {
      store = NotifierRegistrationStore(
        authSessionStore,
        ipInfoStore,
        subscriptionStore,
        repository,
        service,
        prefs,
        analyticsStore,
        Talker(),
        connectivity: connectivity,
        platform: () => null,
      );
      await pumpEventQueue();

      expectNoRegisterCall();
    });
  });

  group('triggers', () {
    test('a refreshed FCM token re-registers and is reported', () async {
      await start();
      clearInteractions(service);
      clearInteractions(analyticsStore);

      when(repository.currentToken).thenReturn('fcm-token-refreshed');
      tokenController.add('fcm-token-refreshed');
      await pumpEventQueue();

      verify(
        analyticsStore.logEvent(
          AnalyticsEvent.pushTokenRefreshed,
          parameters: anyNamed('parameters'),
        ),
      ).called(1);
      verify(
        service.registerDevice(
          externalUserId: 'user-1',
          token: 'fcm-token-refreshed',
          platform: anyNamed('platform'),
        ),
      ).called(1);
    });

    test('permission flipping to granted retries a pending registration', () async {
      stubRegisterFailure(const NotifierException(category: 'network'));

      await start();
      expect(prefs.getNotifierRegistration()?.pending, isTrue);

      stubServiceSuccess();
      permissionController.add(true);
      await pumpEventQueue();

      expect(prefs.getNotifierRegistration()?.pending, isFalse);
    });

    test('restored connectivity retries a pending registration', () async {
      stubRegisterFailure(const NotifierException(category: 'network'));

      await start();
      expect(prefs.getNotifierRegistration()?.pending, isTrue);

      stubServiceSuccess();
      connectivityController.add([ConnectivityResult.wifi]);
      await pumpEventQueue();

      expect(prefs.getNotifierRegistration()?.pending, isFalse);
    });

    test('connectivity changes do not retry when nothing is pending', () async {
      await start();
      clearInteractions(service);

      connectivityController.add([ConnectivityResult.wifi]);
      await pumpEventQueue();

      expectNoRegisterCall();
    });

    test('losing connectivity does not trigger a request', () async {
      stubRegisterFailure(const NotifierException(category: 'network'));

      await start();
      clearInteractions(service);

      connectivityController.add([ConnectivityResult.none]);
      await pumpEventQueue();

      expectNoRegisterCall();
    });
  });

  group('failure handling', () {
    setUp(() {
      stubRegisterFailure(const NotifierException(category: 'server', statusCode: 503));
    });

    test('marks the registration pending without throwing', () async {
      await expectLater(start(), completes);

      expect(prefs.getNotifierRegistration()?.pending, isTrue);
    });

    test('reports a coarse error category and the status', () async {
      await start();

      verify(
        analyticsStore.logPushDeviceRegistrationFailed(errorCategory: 'server', status: 503),
      ).called(1);
    });

    test('does not merge attributes after a failed registration', () async {
      await start();

      verifyNever(
        service.mergeAttributes(
          externalUserId: anyNamed('externalUserId'),
          attributes: anyNamed('attributes'),
        ),
      );
    });

    test('a non-Notifier error is still reported, as unknown', () async {
      when(
        service.registerDevice(
          externalUserId: anyNamed('externalUserId'),
          token: anyNamed('token'),
          platform: anyNamed('platform'),
        ),
      ).thenThrow(StateError('boom'));

      await start();

      verify(analyticsStore.logPushDeviceRegistrationFailed(errorCategory: 'unknown')).called(1);
    });
  });

  group('attributes', () {
    test('merges location and subscription attributes after registering', () async {
      await start();

      final captured =
          verify(
                service.mergeAttributes(
                  externalUserId: 'user-1',
                  attributes: captureAnyNamed('attributes'),
                ),
              ).captured.first
              as Map<String, Object?>;

      expect(captured['country'], 'DE');
      expect(captured['city'], 'Berlin');
      expect(captured['subscription_plan'], 'plan_monthly');
      expect(captured['subscription_active'], 'true');
      expect(captured.containsKey('subscription_exp_date'), isTrue);
    });

    test('a failing merge does not mark the registration pending', () async {
      when(
        service.mergeAttributes(
          externalUserId: anyNamed('externalUserId'),
          attributes: anyNamed('attributes'),
        ),
      ).thenThrow(const NotifierException(category: 'not_found'));

      await start();

      expect(prefs.getNotifierRegistration()?.pending, isFalse);
    });
  });

  group('logout', () {
    test('clears the stored registration and deletes the token', () async {
      final store = await start();

      await store.handleLogout();

      expect(prefs.getNotifierRegistration(), isNull);
      verify(repository.clearToken()).called(1);
    });

    test('still clears local state when deleting the token fails', () async {
      final store = await start();
      when(repository.clearToken()).thenThrow(StateError('boom'));

      await expectLater(store.handleLogout(), completes);

      expect(prefs.getNotifierRegistration(), isNull);
    });

    test('does not clear anything on the initial fire when never authenticated', () async {
      when(authSessionStore.userFuture).thenAnswer((_) => ObservableFuture.value(null));

      await start();

      verifyNever(repository.clearToken());
    });
  });

  group('persistence', () {
    test('an unreadable stored value is treated as unregistered', () async {
      await prefs.setString(StorageKeys.notifierRegistration.name, 'not json');

      expect(prefs.getNotifierRegistration(), isNull);
    });

    test('a round trip preserves every field', () async {
      final value = registration(token: 'abc', pending: true);
      await prefs.setNotifierRegistration(value);

      expect(prefs.getNotifierRegistration(), value);
    });
  });

  group('matches', () {
    test('ignores the pending flag', () {
      expect(registration().matches(registration(pending: true)), isTrue);
    });

    test('is false when the token differs', () {
      expect(registration().matches(registration(token: 'other')), isFalse);
    });

    test('is false when the user differs', () {
      expect(registration().matches(registration(externalUserId: 'other')), isFalse);
    });

    test('is false when the contract version differs', () {
      expect(registration().matches(registration(contractVersion: 99)), isFalse);
    });
  });

  group('attribute deduplication', () {
    test('sends attributes once on startup, not once per reaction', () async {
      await start();

      // The location and subscription reactions both reach _syncAttributes with
      // an identical payload; only the first should hit the network.
      verify(
        service.mergeAttributes(
          externalUserId: anyNamed('externalUserId'),
          attributes: anyNamed('attributes'),
        ),
      ).called(1);
    });

    test('a repeat sync with unchanged attributes makes no request', () async {
      final store = await start();
      clearInteractions(service);

      await store.syncRegistration();
      await pumpEventQueue();

      verifyNever(
        service.mergeAttributes(
          externalUserId: anyNamed('externalUserId'),
          attributes: anyNamed('attributes'),
        ),
      );
    });

    test('changed attributes are sent again', () async {
      final store = await start();
      clearInteractions(service);

      // A new token gets past the registration dedupe so the attribute sync is
      // reached; the changed location is what must not be suppressed by cache.
      when(repository.currentToken).thenReturn('fcm-token-2');
      when(ipInfoStore.infoFuture).thenAnswer(
        (_) => ObservableFuture.value(const IPInfo(city: 'Paris', country: 'FR', ip: '5.6.7.8')),
      );
      await store.syncRegistration();
      await pumpEventQueue();

      final sent =
          verify(
                service.mergeAttributes(
                  externalUserId: anyNamed('externalUserId'),
                  attributes: captureAnyNamed('attributes'),
                ),
              ).captured.single
              as Map<String, Object?>;
      expect(sent['country'], 'FR');
    });

    test('logout drops the cache so the next login re-sends', () async {
      final store = await start();
      await store.handleLogout();
      clearInteractions(service);

      await store.syncRegistration();
      await pumpEventQueue();

      verify(
        service.mergeAttributes(
          externalUserId: anyNamed('externalUserId'),
          attributes: anyNamed('attributes'),
        ),
      ).called(1);
    });
  });
}
