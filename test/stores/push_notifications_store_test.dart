import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/repositories/notifications/notifications_repository.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/auth/store/auth_session_store.dart';
import 'package:mysterium_vpn/features/notifications/store/push_notifications_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_store.dart';
import 'package:mysterium_vpn/features/vpn/store/real_ip_info_store.dart';
import 'package:talker/talker.dart';

import 'push_notifications_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AuthSessionStore>(),
  MockSpec<RealIPInfoStore>(),
  MockSpec<SubscriptionStore>(),
  MockSpec<NotificationsRepository>(),
  MockSpec<AnalyticsStore>(),
  MockSpec<Talker>(),
  MockSpec<LocalDBService>(),
  MockSpec<RemoteConfigStore>(),
])
void main() {
  late PushNotificationsStore store;
  late MockAuthSessionStore mockAuthSessionStore;
  late MockRealIPInfoStore mockRealIPInfoStore;
  late MockSubscriptionStore mockSubscriptionStore;
  late MockNotificationsRepository mockNotificationsRepository;
  late MockAnalyticsStore mockAnalyticsStore;
  late MockTalker mockLogger;
  late MockLocalDBService mockLocalDb;
  late MockRemoteConfigStore mockRemoteConfigStore;

  setUp(() {
    mockAuthSessionStore = MockAuthSessionStore();
    mockRealIPInfoStore = MockRealIPInfoStore();
    mockSubscriptionStore = MockSubscriptionStore();
    mockNotificationsRepository = MockNotificationsRepository();
    mockAnalyticsStore = MockAnalyticsStore();
    mockLogger = MockTalker();
    mockLocalDb = MockLocalDBService();
    mockRemoteConfigStore = MockRemoteConfigStore();

    // Notifications repository
    when(mockNotificationsRepository.init()).thenAnswer((_) async {});
    when(mockNotificationsRepository.getUser()).thenAnswer(
      (_) => Stream.value(
        PushNotificationsUser(pushNotificationsId: 'id', userId: 'userId', tags: {'key': 'value'}),
      ),
    );
    when(
      mockNotificationsRepository.getPermissionStatusStream(),
    ).thenAnswer((_) => Stream.value(false));
    when(mockNotificationsRepository.getPermissionStatus()).thenReturn(false);
    when(mockNotificationsRepository.requestPermission()).thenAnswer((_) async => true);
    when(mockNotificationsRepository.openAppNotificationsSettings()).thenAnswer((_) async => true);
    when(mockNotificationsRepository.setTags(any)).thenAnswer((_) async {});
    when(mockNotificationsRepository.canRequestPermission()).thenAnswer((_) async => true);
    when(mockNotificationsRepository.logout()).thenAnswer((_) async {});
    when(
      mockNotificationsRepository.login(
        userId: anyNamed('userId'),
        userEmail: anyNamed('userEmail'),
      ),
    ).thenAnswer((_) async {});
    when(mockNotificationsRepository.getNotificationsStream()).thenAnswer(
      (_) => Stream.value(
        PushNotification(
          id: 'notif_1',
          title: 'Test',
          body: 'Body',
          launchUrl: '',
          rawPayload: {},
          category: '',
          additionalData: {},
        ),
      ),
    );

    // Auth session
    when(mockAuthSessionStore.userFuture).thenAnswer(
      (_) => ObservableFuture.value(AuthUser(userId: 'u1', username: 'test@example.com')),
    );
    when(mockAuthSessionStore.isAuthenticated).thenReturn(true);

    // IP info
    when(mockRealIPInfoStore.infoFuture).thenAnswer(
      (_) => ObservableFuture.value(const IPInfo(city: 'City', country: 'Country', ip: '')),
    );

    // Subscription
    when(mockSubscriptionStore.subscriptionFuture).thenAnswer(
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

    // Local DB
    when(mockLocalDb.getPushNotificationsPromptLastShownAt()).thenAnswer((_) async => null);
    when(mockLocalDb.setPushNotificationsPromptLastShownAt(any)).thenAnswer((_) async {});

    // Remote config
    when(mockRemoteConfigStore.pushNotifPermissionPromptCooldown).thenReturn(24);

    store = PushNotificationsStore(
      mockAuthSessionStore,
      mockRealIPInfoStore,
      mockSubscriptionStore,
      mockLogger,
      mockNotificationsRepository,
      mockAnalyticsStore,
      mockLocalDb,
      mockRemoteConfigStore,
    )..testIsMobile = true;
  });

  group('Initialization', () {
    test('initializes and sets up reactions', () async {
      // Give time for reactions to fire
      await Future.delayed(const Duration(milliseconds: 100));

      await mockAuthSessionStore.userFuture;
      await mockRealIPInfoStore.infoFuture;
      await mockSubscriptionStore.subscriptionFuture;

      verify(mockNotificationsRepository.init()).called(1);
      verify(
        mockNotificationsRepository.login(userId: 'u1', userEmail: 'test@example.com'),
      ).called(1);

      // Capture all setTags calls
      final captured = verify(mockNotificationsRepository.setTags(captureAny)).captured;
      expect(captured.length, greaterThanOrEqualTo(2));

      // First call should have location tags
      final locationTagsCall = captured[0] as Map<String, dynamic>;
      expect(locationTagsCall['country'], 'Country');
      expect(locationTagsCall['city'], 'City');

      // Second call should have subscription tags
      final subscriptionTagsCall = captured[1] as Map<String, dynamic>;
      expect(subscriptionTagsCall['subscription_gateway'], 'Credit Card');
      expect(subscriptionTagsCall['subscription_plan'], 'plan_monthly');
      expect(subscriptionTagsCall['subscription_recurring'], isNotNull);
      expect(subscriptionTagsCall['subscription_duration'].toString(), '1');
      expect(subscriptionTagsCall.containsKey('subscription_exp_date'), true);
    });
  });

  group('Push Notifications Permission', () {
    test(
      'shouldShowPushNotificationsPermissionPrompt returns true when not granted and cooldown passed',
      () async {
        when(mockNotificationsRepository.getPermissionStatus()).thenReturn(false);
        when(mockNotificationsRepository.canRequestPermission()).thenAnswer((_) async => true);

        final result = await store.shouldShowPushNotificationsPermissionPrompt();

        expect(result, isTrue);
      },
    );

    test('shouldShowPushNotificationsPermissionPrompt returns false during cooldown', () async {
      when(
        mockLocalDb.getPushNotificationsPromptLastShownAt(),
      ).thenAnswer((_) async => DateTime.now());

      final result = await store.shouldShowPushNotificationsPermissionPrompt();

      expect(result, isFalse);
    });

    test(
      'shouldShowPushNotificationsPermissionPrompt returns false when already granted',
      () async {
        when(mockNotificationsRepository.getPermissionStatus()).thenReturn(true);

        final result = await store.shouldShowPushNotificationsPermissionPrompt();

        expect(result, isFalse);
      },
    );

    test('shouldShowPushNotificationsPermissionPrompt returns false when cannot request', () async {
      when(mockNotificationsRepository.getPermissionStatus()).thenReturn(false);
      when(mockNotificationsRepository.canRequestPermission()).thenAnswer((_) async => false);

      final result = await store.shouldShowPushNotificationsPermissionPrompt();

      expect(result, isFalse);
    });

    test('setPushNotificationsShown requests permission when allowed', () async {
      await store.setPushNotificationsShown(userAllowed: true);

      verify(mockNotificationsRepository.requestPermission()).called(1);
      verify(mockLocalDb.setPushNotificationsPromptLastShownAt(any)).called(1);
    });

    test('setPushNotificationsShown does not request permission when not allowed', () async {
      await store.setPushNotificationsShown(userAllowed: false);

      verifyNever(mockNotificationsRepository.requestPermission());
      verify(mockLocalDb.setPushNotificationsPromptLastShownAt(any)).called(1);
    });

    test('updatePushNotificationsPermissions opens app settings when supported', () async {
      // Reset mocks to clear any calls from initialization
      reset(mockNotificationsRepository);
      when(
        mockNotificationsRepository.openAppNotificationsSettings(),
      ).thenAnswer((_) async => true);

      await store.updatePushNotificationsPermissions();

      verify(mockNotificationsRepository.openAppNotificationsSettings()).called(1);
    });

    test('updatePushNotificationsPermissions does nothing on non-mobile', () async {
      store.testIsMobile = false;

      await store.updatePushNotificationsPermissions();

      verifyNever(mockNotificationsRepository.openAppNotificationsSettings());
    });

    test('pushNotificationsPermissionGranted reflects stream value', () {
      expect(store.pushNotificationsPermissionGranted, isFalse);
    });
  });

  group('Computed Properties', () {
    test('user returns string representation of PushNotificationsUser', () async {
      await store.pushNotificationsUser.first;

      expect(store.user, isNotNull);
      expect(store.user, contains('id'));
    });

    test('supportsPushNotifications returns testIsMobile', () {
      store.testIsMobile = true;
      expect(store.supportsPushNotifications, isTrue);

      store.testIsMobile = false;
      expect(store.supportsPushNotifications, isFalse);
    });
  });
}
