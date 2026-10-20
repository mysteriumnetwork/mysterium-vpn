import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/repositories/repositories.dart';
import 'package:mysterium_vpn/services/data/storage.dart';
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
      LocalNotifierRegistrationRepository(prefs),
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
    NotifierSyncState state = NotifierSyncState.settled,
  }) => NotifierRegistration(
    externalUserId: externalUserId,
    token: token,
    platform: platform,
    contractVersion: contractVersion,
    state: state,
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
    when(
      service.deleteDevice(token: anyNamed('token'), externalUserId: anyNamed('externalUserId')),
    ).thenAnswer((_) async {});
  }

  /// Revokes permission the way the repository reports it: the cached status
  /// flips, then the stream emits the transition.
  Future<void> revokePermission() async {
    when(repository.getPermissionStatus()).thenReturn(false);
    // A real revoke is confirmed by a definitive platform read.
    when(repository.refreshPermissionStatus()).thenAnswer((_) async => false);
    permissionController.add(false);
    await pumpEventQueue();
  }

  void stubDeleteFailure(NotifierException failure) => when(
    service.deleteDevice(token: anyNamed('token'), externalUserId: anyNamed('externalUserId')),
  ).thenThrow(failure);

  void expectNoDeleteCall() => verifyNever(
    service.deleteDevice(token: anyNamed('token'), externalUserId: anyNamed('externalUserId')),
  );

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
    prefs = SharedPreferenceService();
    await prefs.init();

    tokenController = StreamController<String>.broadcast();
    permissionController = StreamController<bool>.broadcast();
    connectivityController = StreamController<List<ConnectivityResult>>.broadcast();

    when(repository.tokenStream).thenAnswer((_) => tokenController.stream);
    when(repository.getPermissionStatusStream()).thenAnswer((_) => permissionController.stream);
    when(repository.currentToken).thenReturn('fcm-token');
    when(repository.cancelDisplayedNotifications()).thenAnswer((_) async {});
    // Registration is gated on permission, so the happy path has it granted.
    when(repository.getPermissionStatus()).thenReturn(true);
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
      expect(prefs.getNotifierRegistration()?.state, NotifierSyncState.settled);
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

    test('a stored identical registration still re-registers once per launch', () async {
      await prefs.setNotifierRegistration(registration());

      await start();

      // The backend asks for this: it repairs a device row left wrong by
      // requests that arrived out of order.
      verify(
        service.registerDevice(
          externalUserId: 'user-1',
          token: 'fcm-token',
          platform: NotifierPlatform.android,
        ),
      ).called(1);
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
      await prefs.setNotifierRegistration(registration(state: NotifierSyncState.pendingRegister));

      await start();

      verify(
        service.registerDevice(
          externalUserId: anyNamed('externalUserId'),
          token: anyNamed('token'),
          platform: anyNamed('platform'),
        ),
      ).called(1);
      expect(prefs.getNotifierRegistration()?.state, NotifierSyncState.settled);
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
        LocalNotifierRegistrationRepository(prefs),
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
      // The real tokenStream replays the current token on subscribe; this
      // controller does not, so stand in for it before the actual refresh.
      tokenController.add('fcm-token');
      await pumpEventQueue();
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
      expect(prefs.getNotifierRegistration()?.state, NotifierSyncState.pendingRegister);

      stubServiceSuccess();
      permissionController.add(true);
      await pumpEventQueue();

      expect(prefs.getNotifierRegistration()?.state, NotifierSyncState.settled);
    });

    test('restored connectivity retries a pending registration', () async {
      stubRegisterFailure(const NotifierException(category: 'network'));

      await start();
      expect(prefs.getNotifierRegistration()?.state, NotifierSyncState.pendingRegister);

      stubServiceSuccess();
      connectivityController.add([ConnectivityResult.wifi]);
      await pumpEventQueue();

      expect(prefs.getNotifierRegistration()?.state, NotifierSyncState.settled);
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

      expect(prefs.getNotifierRegistration()?.state, NotifierSyncState.pendingRegister);
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
      verify(
        analyticsStore.logNonFatal(
          err: anyNamed('err'),
          stack: anyNamed('stack'),
          reason: anyNamed('reason'),
        ),
      ).called(1);
    });

    test('a NotifierException is evented but not reported as a bug', () async {
      await start();

      verify(
        analyticsStore.logPushDeviceRegistrationFailed(errorCategory: 'server', status: 503),
      ).called(1);
      // Expected transport outcomes are retried, so reporting each one would
      // bury the Crashlytics dashboard.
      verifyNever(
        analyticsStore.logNonFatal(
          err: anyNamed('err'),
          stack: anyNamed('stack'),
          reason: anyNamed('reason'),
        ),
      );
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

    test('a failing merge is evented so mistargeting is visible', () async {
      when(
        service.mergeAttributes(
          externalUserId: anyNamed('externalUserId'),
          attributes: anyNamed('attributes'),
        ),
      ).thenThrow(const NotifierException(category: 'not_found', statusCode: 404));

      await start();

      verify(
        analyticsStore.logPushAttributesMergeFailed(errorCategory: 'not_found', status: 404),
      ).called(1);
    });

    test('a failing merge does not mark the registration pending', () async {
      when(
        service.mergeAttributes(
          externalUserId: anyNamed('externalUserId'),
          attributes: anyNamed('attributes'),
        ),
      ).thenThrow(const NotifierException(category: 'not_found'));

      await start();

      expect(prefs.getNotifierRegistration()?.state, NotifierSyncState.settled);
    });
  });

  group('logout', () {
    test('unregisters the device and clears the stored registration', () async {
      final store = await start();

      await store.handleLogout();

      verify(service.deleteDevice(token: 'fcm-token', externalUserId: 'user-1')).called(1);
      expect(prefs.getNotifierRegistration(), isNull);
    });

    test('clears the tray', () async {
      final store = await start();

      await store.handleLogout();

      verify(repository.cancelDisplayedNotifications()).called(1);
    });

    test('a failed delete keeps the record so a later trigger retries it', () async {
      final store = await start();
      stubDeleteFailure(const NotifierException(category: 'network'));

      await expectLater(store.handleLogout(), completes);

      expect(prefs.getNotifierRegistration()?.state, NotifierSyncState.pendingDelete);
    });

    test('still clears the tray when the delete fails', () async {
      final store = await start();
      stubDeleteFailure(const NotifierException(category: 'network'));

      await store.handleLogout();

      verify(repository.cancelDisplayedNotifications()).called(1);
    });

    test('records the owed delete before calling Notifier', () async {
      final store = await start();
      final gate = Completer<void>();
      when(
        service.deleteDevice(token: anyNamed('token'), externalUserId: anyNamed('externalUserId')),
      ).thenAnswer((_) async => gate.future);

      final logout = store.handleLogout();
      await pumpEventQueue();

      expect(prefs.getNotifierRegistration()?.state, NotifierSyncState.pendingDelete);
      gate.complete();
      await logout;
    });

    test('a store disposed mid-logout leaves the delete recoverable', () async {
      final first = await start();
      final gate = Completer<void>();
      when(
        service.deleteDevice(token: anyNamed('token'), externalUserId: anyNamed('externalUserId')),
      ).thenAnswer((_) async => gate.future);

      // Logout invalidates subscriptionStorePOD, which this store watches, so
      // Riverpod disposes it while the delete is still in flight.
      final logout = first.handleLogout();
      await first.dispose();
      gate.complete();
      await logout;

      // The replacement instance must still find work to do.
      expect(prefs.getNotifierRegistration()?.state, NotifierSyncState.pendingDelete);
      clearInteractions(service);
      stubServiceSuccess();

      // The replacement comes up signed out, which is the real post-logout
      // state — otherwise it would legitimately register the same user again.
      when(authSessionStore.userFuture).thenAnswer((_) => ObservableFuture.value(null));
      // start() replaces the store the teardown disposes.
      await start();
      // The real tokenStream replays the cached token to a new subscriber; this
      // controller does not, so stand in for it. That replay is what triggers
      // the retry on a signed-out launch, where the auth reaction stays quiet.
      tokenController.add('fcm-token');
      await pumpEventQueue();

      verify(service.deleteDevice(token: 'fcm-token', externalUserId: 'user-1')).called(1);
      expect(prefs.getNotifierRegistration(), isNull);
    });

    test('does nothing on the initial fire when never authenticated', () async {
      when(authSessionStore.userFuture).thenAnswer((_) => ObservableFuture.value(null));

      await start();

      expectNoDeleteCall();
      verifyNever(repository.cancelDisplayedNotifications());
    });
  });

  group('account switch', () {
    void signInAs(String userId) => when(authSessionStore.userFuture).thenAnswer(
      (_) => ObservableFuture.value(AuthUser(userId: userId, username: '$userId@b.com')),
    );

    test('a different user on the same device unregisters the previous one', () async {
      final store = await start();
      clearInteractions(service);

      signInAs('user-2');
      await store.syncRegistration();
      await pumpEventQueue();

      // Notifier keys by (token, externalUserId), so without this user-1's row
      // keeps delivering to a token that is still valid.
      verify(service.deleteDevice(token: 'fcm-token', externalUserId: 'user-1')).called(1);
      verify(
        service.registerDevice(
          externalUserId: 'user-2',
          token: 'fcm-token',
          platform: anyNamed('platform'),
        ),
      ).called(1);
      expect(prefs.getNotifierRegistration()?.externalUserId, 'user-2');
    });

    test('a failed unregister blocks the new user until it succeeds', () async {
      final store = await start();
      clearInteractions(service);
      stubDeleteFailure(const NotifierException(category: 'network'));

      signInAs('user-2');
      await store.syncRegistration();
      await pumpEventQueue();

      expectNoRegisterCall();
      final stored = prefs.getNotifierRegistration();
      expect(stored?.state, NotifierSyncState.pendingDelete);
      expect(stored?.externalUserId, 'user-1');
    });

    test('the owed delete is finished on the next trigger, then B registers', () async {
      final store = await start();
      stubDeleteFailure(const NotifierException(category: 'network'));
      signInAs('user-2');
      await store.syncRegistration();
      await pumpEventQueue();

      clearInteractions(service);
      stubServiceSuccess();
      await store.syncRegistration();
      await pumpEventQueue();

      verify(service.deleteDevice(token: 'fcm-token', externalUserId: 'user-1')).called(1);
      verify(
        service.registerDevice(
          externalUserId: 'user-2',
          token: 'fcm-token',
          platform: anyNamed('platform'),
        ),
      ).called(1);
      expect(prefs.getNotifierRegistration()?.externalUserId, 'user-2');
    });

    test('the owed delete is persisted before the request, not after', () async {
      final store = await start();
      final gate = Completer<void>();
      when(
        service.deleteDevice(token: anyNamed('token'), externalUserId: anyNamed('externalUserId')),
      ).thenAnswer((_) async => gate.future);

      signInAs('user-2');
      final sync = store.syncRegistration();
      await pumpEventQueue();

      // A kill here must leave something for the next launch to retry.
      expect(prefs.getNotifierRegistration()?.state, NotifierSyncState.pendingDelete);

      gate.complete();
      await sync;
    });
  });

  group('permission gate', () {
    test('does not register while permission is denied', () async {
      when(repository.getPermissionStatus()).thenReturn(false);
      when(repository.refreshPermissionStatus()).thenAnswer((_) async => false);

      await start();

      expectNoRegisterCall();
      expect(prefs.getNotifierRegistration(), isNull);
    });

    test('an unreadable permission status does not unregister', () async {
      // A hot restart resets the repository cache to false before the platform
      // has answered; treating that as a revocation deleted a live device.
      await prefs.setNotifierRegistration(registration());
      when(repository.getPermissionStatus()).thenReturn(false);
      when(repository.refreshPermissionStatus()).thenAnswer((_) async => null);

      await start();

      expectNoDeleteCall();
      expect(prefs.getNotifierRegistration(), isNotNull);
    });

    test('a never-asked permission status does not unregister', () async {
      await prefs.setNotifierRegistration(registration());
      when(repository.getPermissionStatus()).thenReturn(false);
      when(repository.refreshPermissionStatus()).thenAnswer((_) async => null);

      await start();

      expectNoDeleteCall();
    });

    test('the pre-init false replayed on subscribe does not unregister', () async {
      // The permission stream replays its current value to each subscriber, so
      // a startup `false` is the uninitialized cache, not a revocation.
      await prefs.setNotifierRegistration(registration());
      when(repository.getPermissionStatus()).thenReturn(false);
      when(repository.refreshPermissionStatus()).thenAnswer((_) async => null);

      await start();
      permissionController.add(false);
      await pumpEventQueue();

      expectNoDeleteCall();
      expect(prefs.getNotifierRegistration(), isNotNull);
    });

    test('revoking permission unregisters the device', () async {
      await start();
      expect(prefs.getNotifierRegistration(), isNotNull);

      await revokePermission();

      verify(service.deleteDevice(token: 'fcm-token', externalUserId: 'user-1')).called(1);
      expect(prefs.getNotifierRegistration(), isNull);
    });

    test('granting permission again re-registers', () async {
      await start();
      await revokePermission();
      clearInteractions(service);

      when(repository.getPermissionStatus()).thenReturn(true);
      permissionController.add(true);
      await pumpEventQueue();

      verify(
        service.registerDevice(
          externalUserId: 'user-1',
          token: 'fcm-token',
          platform: anyNamed('platform'),
        ),
      ).called(1);
    });

    test('a revocation made while the app was closed is reconciled on launch', () async {
      await prefs.setNotifierRegistration(registration());
      // Nothing emits for a change made outside the app, so the store has to
      // read the platform itself at startup.
      when(repository.getPermissionStatus()).thenReturn(false);
      when(repository.refreshPermissionStatus()).thenAnswer((_) async => false);

      await start();

      verify(service.deleteDevice(token: 'fcm-token', externalUserId: 'user-1')).called(1);
      expect(prefs.getNotifierRegistration(), isNull);
    });

    test('reports the delete failure category and status', () async {
      await start();
      stubDeleteFailure(const NotifierException(category: 'server', statusCode: 503));

      await revokePermission();

      verify(
        analyticsStore.logPushDeviceDeleteFailed(errorCategory: 'server', status: 503),
      ).called(1);
    });

    test('a failed delete is retried when connectivity returns', () async {
      await start();
      stubDeleteFailure(const NotifierException(category: 'network'));
      await revokePermission();
      expect(prefs.getNotifierRegistration()?.state, NotifierSyncState.pendingDelete);

      stubServiceSuccess();
      connectivityController.add([ConnectivityResult.wifi]);
      await pumpEventQueue();

      expect(prefs.getNotifierRegistration(), isNull);
    });

    test('logs push_device_deleted on success', () async {
      await start();
      clearInteractions(analyticsStore);

      await revokePermission();

      verify(
        analyticsStore.logEvent(
          AnalyticsEvent.pushDeviceDeleted,
          parameters: anyNamed('parameters'),
        ),
      ).called(1);
    });

    test('a non-Notifier delete error is still reported, as unknown', () async {
      await start();
      when(
        service.deleteDevice(token: anyNamed('token'), externalUserId: anyNamed('externalUserId')),
      ).thenThrow(StateError('boom'));

      await revokePermission();

      verify(analyticsStore.logPushDeviceDeleteFailed(errorCategory: 'unknown')).called(1);
      // A bug on our side, unlike a NotifierException — so it also goes to
      // Crashlytics and Sentry rather than only the event stream.
      verify(
        analyticsStore.logNonFatal(
          err: anyNamed('err'),
          stack: anyNamed('stack'),
          reason: anyNamed('reason'),
        ),
      ).called(1);
    });

    test('an owed delete is finished before registering again', () async {
      await prefs.setNotifierRegistration(registration(state: NotifierSyncState.pendingDelete));

      await start();

      verify(service.deleteDevice(token: 'fcm-token', externalUserId: 'user-1')).called(1);
      // Permission is granted, so the self-heal continues into a fresh register.
      verify(
        service.registerDevice(
          externalUserId: 'user-1',
          token: 'fcm-token',
          platform: anyNamed('platform'),
        ),
      ).called(1);
      expect(prefs.getNotifierRegistration()?.state, NotifierSyncState.settled);
    });
  });

  group('persistence', () {
    test('an unreadable stored value is treated as unregistered', () async {
      await prefs.setString(StorageKeys.notifierRegistration.name, 'not json');

      expect(prefs.getNotifierRegistration(), isNull);
    });

    test('a round trip preserves every field', () async {
      final value = registration(token: 'abc', state: NotifierSyncState.pendingDelete);
      await prefs.setNotifierRegistration(value);

      expect(prefs.getNotifierRegistration(), value);
    });
  });

  group('matches', () {
    test('ignores the pending flag', () {
      expect(
        registration().matches(registration(state: NotifierSyncState.pendingRegister)),
        isTrue,
      );
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

  group('concurrent triggers', () {
    /// Makes registerDevice hang until the returned completer is opened.
    Completer<void> stallRegister() {
      final gate = Completer<void>();
      when(
        service.registerDevice(
          externalUserId: anyNamed('externalUserId'),
          token: anyNamed('token'),
          platform: anyNamed('platform'),
        ),
      ).thenAnswer((_) async => gate.future);
      return gate;
    }

    test('a logout during a first registration still unregisters the device', () async {
      final gate = stallRegister();
      final store = await start();
      // Nothing is persisted until registerDevice returns, so a naive logout
      // finds no record and the register then saves one for the departed user.
      expect(prefs.getNotifierRegistration(), isNull);

      final logout = store.handleLogout();
      gate.complete();
      await logout;
      await pumpEventQueue();

      verify(service.deleteDevice(token: 'fcm-token', externalUserId: 'user-1')).called(1);
      expect(prefs.getNotifierRegistration(), isNull);
    });

    test('a logout mid-register is not overwritten by the register', () async {
      final gate = stallRegister();
      final store = await start();

      final logout = store.handleLogout();
      await pumpEventQueue();
      gate.complete();
      await logout;
      await pumpEventQueue();

      // Either the delete finished, or the owed delete survives for a retry —
      // never a settled record for the departed user.
      final stored = prefs.getNotifierRegistration();
      expect(stored == null || stored.state == NotifierSyncState.pendingDelete, isTrue);
    });

    test('the replayed token is not reported as a refresh', () async {
      await start();

      verifyNever(
        analyticsStore.logEvent(
          AnalyticsEvent.pushTokenRefreshed,
          parameters: anyNamed('parameters'),
        ),
      );
    });

    test('a token refresh during a registration is not dropped', () async {
      final gate = stallRegister();
      await start();

      when(repository.currentToken).thenReturn('fcm-token-2');
      tokenController.add('fcm-token-2');
      await pumpEventQueue();

      gate.complete();
      await pumpEventQueue();

      verify(
        service.registerDevice(
          externalUserId: 'user-1',
          token: 'fcm-token-2',
          platform: anyNamed('platform'),
        ),
      ).called(1);
    });

    test('a dispose mid-flight stops queued work from running', () async {
      final gate = stallRegister();
      final store = await start();

      final disposed = store.dispose();
      gate.complete();
      await disposed;
      clearInteractions(service);

      await store.syncRegistration();
      await pumpEventQueue();

      expectNoRegisterCall();
    });

    test('resume retries a registration left pending', () async {
      stubRegisterFailure(const NotifierException(category: 'network'));
      final store = await start();
      expect(prefs.getNotifierRegistration()?.state, NotifierSyncState.pendingRegister);

      stubServiceSuccess();
      store.didChangeAppLifecycleState(AppLifecycleState.resumed);
      await pumpEventQueue();

      expect(prefs.getNotifierRegistration()?.state, NotifierSyncState.settled);
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

    test('attributes are not merged onto the previous user', () async {
      // A settled record from the last launch names user-1 while the session is
      // already user-2; the data below describes user-2.
      await prefs.setNotifierRegistration(registration());
      when(
        authSessionStore.userFuture,
      ).thenAnswer((_) => ObservableFuture.value(AuthUser(userId: 'user-2', username: 'c@d.com')));
      // Fail the register so the stale record is the only one on disk.
      stubRegisterFailure(const NotifierException(category: 'network'));
      stubDeleteFailure(const NotifierException(category: 'network'));

      await start();
      await pumpEventQueue();

      verifyNever(
        service.mergeAttributes(externalUserId: 'user-1', attributes: anyNamed('attributes')),
      );
    });

    test('a change arriving mid-merge is sent once that merge finishes', () async {
      // A real ObservableFuture, so the location reaction genuinely fires while
      // the first merge is still awaiting its response.
      final ip = Completer<IPInfo>();
      // The same instance every read, so the reaction tracks one observable.
      final location = ObservableFuture(ip.future);
      when(ipInfoStore.infoFuture).thenAnswer((_) => location);
      final mergeGate = Completer<void>();
      when(
        service.mergeAttributes(
          externalUserId: anyNamed('externalUserId'),
          attributes: anyNamed('attributes'),
        ),
      ).thenAnswer((_) async => mergeGate.future);

      await start();
      ip.complete(const IPInfo(city: 'Paris', country: 'FR', ip: '5.6.7.8'));
      await pumpEventQueue();

      mergeGate.complete();
      await pumpEventQueue();

      final sent = verify(
        service.mergeAttributes(
          externalUserId: anyNamed('externalUserId'),
          attributes: captureAnyNamed('attributes'),
        ),
      ).captured;
      expect(sent, hasLength(2));
      expect((sent.last as Map<String, Object?>)['country'], 'FR');
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
