import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/repositories/notifications/notifications_repository.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:talker/talker.dart';

import 'push_notifications_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AuthSessionStore>(),
  MockSpec<RealIPInfoStore>(),
  MockSpec<SubscriptionStore>(),
  MockSpec<NotificationsRepository>(),
  MockSpec<AnalyticsStore>(),
  MockSpec<Talker>(),
])
void main() {
  late PushNotificationsStore store;
  late MockAuthSessionStore mockAuthSessionStore;
  late MockRealIPInfoStore mockRealIPInfoStore;
  late MockSubscriptionStore mockSubscriptionStore;
  late MockNotificationsRepository mockNotificationsRepository;
  late MockAnalyticsStore mockAnalyticsStore;
  late MockTalker mockLogger;

  setUp(() {
    mockAuthSessionStore = MockAuthSessionStore();
    mockRealIPInfoStore = MockRealIPInfoStore();
    mockSubscriptionStore = MockSubscriptionStore();
    mockNotificationsRepository = MockNotificationsRepository();
    mockAnalyticsStore = MockAnalyticsStore();
    mockLogger = MockTalker();

    // Default stubs
    when(mockNotificationsRepository.init()).thenAnswer((_) async {});
    when(mockNotificationsRepository.getUser()).thenAnswer(
      (_) => Stream.value(
        PushNotificationsUser(
          pushNotificationsId: 'id',
          userId: 'userId',
          tags: {'key': 'value'},
        ),
      ),
    );
    when(mockNotificationsRepository.getPermissionStatusStream())
        .thenAnswer((_) => Stream.value(false));
    when(mockNotificationsRepository.getPermissionStatus()).thenReturn(false);
    when(mockNotificationsRepository.requestPermission()).thenAnswer((_) async => true);
    when(mockNotificationsRepository.openAppNotificationsSettings()).thenAnswer((_) async => true);
    when(mockNotificationsRepository.setTags(any)).thenAnswer((_) async => {});
    when(
      mockNotificationsRepository.login(
        userId: anyNamed('userId'),
        userEmail: anyNamed('userEmail'),
      ),
    ).thenAnswer((_) async => {});
    when(mockNotificationsRepository.logout()).thenAnswer((_) async => {});

    // User session
    when(mockAuthSessionStore.userFuture).thenAnswer(
      (_) => ObservableFuture.value(
        AuthUser(
          userId: 'u1',
          username: 'test@example.com',
        ),
      ),
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

    store = PushNotificationsStore(
      mockAuthSessionStore,
      mockRealIPInfoStore,
      mockSubscriptionStore,
      mockLogger,
      mockNotificationsRepository,
      mockAnalyticsStore,
    )..testIsMobile = true;
  });

  group('Initialization', () {
    test('initializes and sets up reactions', () async {
      await mockAuthSessionStore.userFuture;
      await mockRealIPInfoStore.infoFuture;
      await mockSubscriptionStore.subscriptionFuture;

      verify(mockNotificationsRepository.init()).called(1);
      verify(mockNotificationsRepository.login(userId: 'u1', userEmail: 'test@example.com'))
          .called(1);
      verify(
        mockNotificationsRepository.setTags(
          argThat(
            allOf(
              containsPair('country', 'Country'),
              containsPair('city', 'City'),
            ),
          ),
        ),
      ).called(1);
      verify(
        mockNotificationsRepository.setTags(
          argThat(
            allOf(
              containsPair('subscription_gateway', 'Credit Card'),
              containsPair('subscription_plan', 'plan_monthly'),
              containsPair('subscription_recurring', 'true'),
            ),
          ),
        ),
      ).called(1);
    });
  });

  group('Push Notifications Permission', () {
    test(
        'shouldShowPushNotificationsPermissionPrompt returns true when not granted and prompt not shown',
        () async {
      store.pushNotificationsPromptShown = false;
      when(mockNotificationsRepository.getPermissionStatus()).thenReturn(false);

      final result = await store.shouldShowPushNotificationsPermissionPrompt();

      expect(result, isTrue);
    });

    test('shouldShowPushNotificationsPermissionPrompt returns false when prompt already shown',
        () async {
      store.pushNotificationsPromptShown = true;

      final result = await store.shouldShowPushNotificationsPermissionPrompt();

      expect(result, isFalse);
    });

    test('setPushNotificationsShown requests permission when allowed', () async {
      store.pushNotificationsPromptShown = false;
      await store.setPushNotificationsShown(userAllowed: true);

      expect(store.pushNotificationsPromptShown, isTrue);
      verify(mockNotificationsRepository.requestPermission()).called(1);
    });

    test('setPushNotificationsShown does not request permission when not allowed', () async {
      store.pushNotificationsPromptShown = false;
      await store.setPushNotificationsShown(userAllowed: false);

      expect(store.pushNotificationsPromptShown, isTrue);
      verifyNever(mockNotificationsRepository.requestPermission());
    });

    test('updatePushNotificationsPermissions opens app settings when supported', () async {
      await store.updatePushNotificationsPermissions();

      verify(mockNotificationsRepository.openAppNotificationsSettings()).called(1);
    });

    test('updatePushNotificationsPermissions does nothing on non-mobile', () async {
      store.testIsMobile = false;
      await store.updatePushNotificationsPermissions();

      verifyNever(mockNotificationsRepository.openAppNotificationsSettings());
    });

    test('pushNotificationsPermissionGranted reflects stream value', () async {
      // Already default to false
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
