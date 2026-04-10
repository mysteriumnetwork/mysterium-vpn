import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';

import 'user_preferences_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ApiService>(),
  MockSpec<AnalyticsStore>(),
  MockSpec<RealIPInfoStore>(),
  MockSpec<LocalDBService>(),
  MockSpec<PushNotificationsStore>(),
  MockSpec<AuthSessionStore>(),
])
void main() {
  late UserPreferencesStore store;
  late MockApiService mockApiService;
  late MockAnalyticsStore mockAnalyticsStore;
  late MockRealIPInfoStore mockRealIPInfoStore;
  late MockLocalDBService mockLocalDBService;
  late MockPushNotificationsStore mockPushNotificationsStore;
  late MockAuthSessionStore mockAuthSessionStore;
  setUp(() {
    mockApiService = MockApiService();
    mockAnalyticsStore = MockAnalyticsStore();
    mockRealIPInfoStore = MockRealIPInfoStore();
    mockLocalDBService = MockLocalDBService();
    mockPushNotificationsStore = MockPushNotificationsStore();
    mockAuthSessionStore = MockAuthSessionStore();

    // Default auth state: not authenticated
    when(mockAuthSessionStore.isAuthenticated).thenReturn(false);
    when(mockAuthSessionStore.userFuture).thenAnswer((_) => ObservableFuture.value(null));

    when(mockRealIPInfoStore.infoFuture).thenAnswer(
      (_) =>
          ObservableFuture.value(const IPInfo(city: 'Test City', country: 'Test Country', ip: '')),
    );

    // Default stubs to prevent null errors during initStore
    when(
      mockApiService.createMarketingContact(country: anyNamed('country')),
    ).thenAnswer((_) async => {});
    when(mockApiService.getMarketingContactStatus()).thenAnswer((_) async => false);
    when(mockLocalDBService.getMarketingConsentShown()).thenAnswer((_) async => false);
    when(mockLocalDBService.getAppOpenCount()).thenAnswer((_) async => 0);
    when(
      mockPushNotificationsStore.shouldShowPushNotificationsPermissionPrompt(),
    ).thenAnswer((_) async => false);

    store = UserPreferencesStore(
      apiService: mockApiService,
      analyticsStore: mockAnalyticsStore,
      realIPInfo: mockRealIPInfoStore,
      localDBService: mockLocalDBService,
      pushNotificationsStore: mockPushNotificationsStore,
      authSessionStore: mockAuthSessionStore,
    )..testIsMobile = true;
  });

  group('Initialization', () {
    test('initStore creates marketing contact and gets consent', () async {
      // Mock auth state as authenticated to trigger initStore
      when(mockAuthSessionStore.isAuthenticated).thenReturn(true);
      when(
        mockAuthSessionStore.userFuture,
      ).thenAnswer((_) => ObservableFuture.value(AuthUser(userId: '1', username: 'test@test.com')));

      // Recreate store to trigger auth reaction with new mocks
      store = UserPreferencesStore(
        apiService: mockApiService,
        analyticsStore: mockAnalyticsStore,
        realIPInfo: mockRealIPInfoStore,
        localDBService: mockLocalDBService,
        pushNotificationsStore: mockPushNotificationsStore,
        authSessionStore: mockAuthSessionStore,
      )..testIsMobile = true;

      // Wait for futures to complete
      await store.setMarketingConsentFuture;
      await store.getMarketingConsentFuture;

      verify(mockApiService.createMarketingContact(country: 'Test Country')).called(1);
      verify(mockApiService.getMarketingContactStatus()).called(1);
    });

    test('initStore evaluates next prompt to show', () async {
      // Setup authenticated state
      when(mockAuthSessionStore.isAuthenticated).thenReturn(true);
      when(
        mockAuthSessionStore.userFuture,
      ).thenAnswer((_) => ObservableFuture.value(AuthUser(userId: '1', username: 'test@test.com')));

      when(mockApiService.getMarketingContactStatus()).thenAnswer((_) async => false);
      when(mockLocalDBService.getMarketingConsentShown()).thenAnswer((_) async => false);
      when(mockLocalDBService.getAppOpenCount()).thenAnswer((_) async => 3);
      when(
        mockPushNotificationsStore.shouldShowPushNotificationsPermissionPrompt(),
      ).thenAnswer((_) async => false);

      // Recreate store to trigger auth reaction
      store = UserPreferencesStore(
        apiService: mockApiService,
        analyticsStore: mockAnalyticsStore,
        realIPInfo: mockRealIPInfoStore,
        localDBService: mockLocalDBService,
        pushNotificationsStore: mockPushNotificationsStore,
        authSessionStore: mockAuthSessionStore,
      )..testIsMobile = true;

      // Wait for auth reaction and initStore to complete
      await pumpEventQueue();
      await store.setMarketingConsentFuture;
      await store.getMarketingConsentFuture;

      // Should show marketing consent on 3rd open
      expect(store.nextPromptToShow, UserPromptType.marketingConsent);
    });

    test('initStore handles errors gracefully', () async {
      // Setup authenticated state
      when(mockAuthSessionStore.isAuthenticated).thenReturn(true);
      when(
        mockAuthSessionStore.userFuture,
      ).thenAnswer((_) => ObservableFuture.value(AuthUser(userId: '1', username: 'test@test.com')));

      when(
        mockApiService.createMarketingContact(country: anyNamed('country')),
      ).thenThrow(Exception('Network error'));

      // Recreate store to trigger auth reaction
      store = UserPreferencesStore(
        apiService: mockApiService,
        analyticsStore: mockAnalyticsStore,
        realIPInfo: mockRealIPInfoStore,
        localDBService: mockLocalDBService,
        pushNotificationsStore: mockPushNotificationsStore,
        authSessionStore: mockAuthSessionStore,
      )..testIsMobile = true;

      // Should not throw
      await pumpEventQueue();

      verify(
        mockAnalyticsStore.logEvent(
          AnalyticsEvent.createMarketingContactError,
          parameters: anyNamed('parameters'),
        ),
      ).called(1);
    });
  });

  group('App Open Count', () {
    test('appOpenCount from localDb is used in prompt evaluation', () async {
      store.getMarketingConsentFuture = ObservableFuture.value(false);
      when(mockLocalDBService.getMarketingConsentShown()).thenAnswer((_) async => false);
      when(mockLocalDBService.getAppOpenCount()).thenAnswer((_) async => 3);

      final result = await store.shouldShowMarketingConsent();
      expect(result, isTrue);
    });
  });

  group('Prompt Tracking', () {
    test('isPromptShown returns false for none type', () {
      expect(store.isPromptShown(UserPromptType.none), isFalse);
    });

    test('isPromptShown returns false for unshown marketing consent', () {
      store.marketingConsentPromptShown = false;
      expect(store.isPromptShown(UserPromptType.marketingConsent), isFalse);
    });

    test('isPromptShown returns true for shown marketing consent', () {
      store.marketingConsentPromptShown = true;
      expect(store.isPromptShown(UserPromptType.marketingConsent), isTrue);
    });

    test('isPromptShown returns false for unshown push notifications', () {
      store.pushNotificationsPromptShown = false;
      expect(store.isPromptShown(UserPromptType.pushNotifications), isFalse);
    });

    test('isPromptShown returns true for shown push notifications', () {
      store.pushNotificationsPromptShown = true;
      expect(store.isPromptShown(UserPromptType.pushNotifications), isTrue);
    });

    test('markPromptAsShown marks marketing consent as shown', () {
      store
        ..marketingConsentPromptShown = false
        ..markPromptAsShown(UserPromptType.marketingConsent);
      expect(store.marketingConsentPromptShown, isTrue);
    });

    test('markPromptAsShown marks push notifications as shown', () {
      store
        ..pushNotificationsPromptShown = false
        ..markPromptAsShown(UserPromptType.pushNotifications);
      expect(store.pushNotificationsPromptShown, isTrue);
    });

    test('markPromptAsShown does nothing for none type', () {
      store
        ..marketingConsentPromptShown = false
        ..pushNotificationsPromptShown = false
        ..markPromptAsShown(UserPromptType.none);
      expect(store.marketingConsentPromptShown, isFalse);
      expect(store.pushNotificationsPromptShown, isFalse);
    });

    test('marked prompts prevent re-showing', () async {
      store
        ..getMarketingConsentFuture = ObservableFuture.value(false)
        ..marketingConsentPromptShown = true;

      // Even though conditions are met for showing, it should not show again
      expect(store.isPromptShown(UserPromptType.marketingConsent), isTrue);
    });
  });

  group('Marketing Consent', () {
    test('shouldShowMarketingConsent returns false if consent is true', () async {
      store.getMarketingConsentFuture = ObservableFuture.value(true);
      when(mockLocalDBService.getMarketingConsentShown()).thenAnswer((_) async => false);
      when(mockLocalDBService.getAppOpenCount()).thenAnswer((_) async => 3);

      final result = await store.shouldShowMarketingConsent();
      expect(result, isFalse);
    });

    test('shouldShowMarketingConsent returns false if already shown', () async {
      store.getMarketingConsentFuture = ObservableFuture.value(false);
      when(mockLocalDBService.getMarketingConsentShown()).thenAnswer((_) async => true);
      when(mockLocalDBService.getAppOpenCount()).thenAnswer((_) async => 3);

      final result = await store.shouldShowMarketingConsent();
      expect(result, isFalse);
    });

    test('shouldShowMarketingConsent returns false if app open count is less than 3', () async {
      store.getMarketingConsentFuture = ObservableFuture.value(false);
      when(mockLocalDBService.getMarketingConsentShown()).thenAnswer((_) async => false);
      when(mockLocalDBService.getAppOpenCount()).thenAnswer((_) async => 2);

      final result = await store.shouldShowMarketingConsent();
      expect(result, isFalse);
    });

    test('shouldShowMarketingConsent returns true on 3rd open and beyond', () async {
      store.getMarketingConsentFuture = ObservableFuture.value(false);
      when(mockLocalDBService.getMarketingConsentShown()).thenAnswer((_) async => false);
      when(mockLocalDBService.getAppOpenCount()).thenAnswer((_) async => 3);

      final result = await store.shouldShowMarketingConsent();
      expect(result, isTrue);
    });

    test('shouldShowMarketingConsent returns true on 4th open if not shown yet', () async {
      store.getMarketingConsentFuture = ObservableFuture.value(false);
      when(mockLocalDBService.getMarketingConsentShown()).thenAnswer((_) async => false);
      when(mockLocalDBService.getAppOpenCount()).thenAnswer((_) async => 4);

      final result = await store.shouldShowMarketingConsent();
      expect(result, isTrue);
    });

    test('setMarketingConsentShown calls localDb', () async {
      when(mockLocalDBService.setMarketingConsentShown()).thenAnswer((_) async {});

      await store.setMarketingConsentShown();

      verify(mockLocalDBService.setMarketingConsentShown()).called(1);
    });

    test('createMarketingContact logs success event', () async {
      when(
        mockApiService.createMarketingContact(country: anyNamed('country')),
      ).thenAnswer((_) async => {});

      await store.createMarketingContact();

      verify(mockAnalyticsStore.logEvent(AnalyticsEvent.createMarketingContactSuccess)).called(1);
    });

    test('createMarketingContact logs error event on failure', () async {
      when(
        mockApiService.createMarketingContact(country: anyNamed('country')),
      ).thenThrow(Exception('fail'));

      await store.createMarketingContact();

      verify(
        mockAnalyticsStore.logEvent(
          AnalyticsEvent.createMarketingContactError,
          parameters: argThat(containsPair('error', contains('fail')), named: 'parameters'),
        ),
      ).called(1);
    });

    test('updateMarketingContact updates consent and logs success', () async {
      when(mockApiService.updateMarketingContact(consent: true)).thenAnswer((_) async => {});

      await store.updateMarketingContact(consent: true);

      expect(store.getMarketingConsentFuture?.value, isTrue);
      verify(mockAnalyticsStore.logEvent(AnalyticsEvent.updateMarketingContactSuccess)).called(1);
    });

    test('updateMarketingContact calls setMarketingConsentShown when fromPopup is true', () async {
      when(mockApiService.updateMarketingContact(consent: true)).thenAnswer((_) async => {});
      when(mockLocalDBService.setMarketingConsentShown()).thenAnswer((_) async {});

      await store.updateMarketingContact(consent: true, fromPopup: true);

      verify(mockLocalDBService.setMarketingConsentShown()).called(1);
    });

    test(
      'updateMarketingContact does not call setMarketingConsentShown when fromPopup is false',
      () async {
        when(mockApiService.updateMarketingContact(consent: true)).thenAnswer((_) async => {});

        await store.updateMarketingContact(consent: true);

        verifyNever(mockLocalDBService.setMarketingConsentShown());
      },
    );

    test('updateMarketingContact does not re-evaluate prompts after setting shown', () async {
      store.nextPromptToShow = UserPromptType.marketingConsent;
      when(mockApiService.updateMarketingContact(consent: true)).thenAnswer((_) async => {});
      when(mockLocalDBService.setMarketingConsentShown()).thenAnswer((_) async {});

      await store.updateMarketingContact(consent: true, fromPopup: true);

      // nextPromptToShow should remain unchanged
      expect(store.nextPromptToShow, UserPromptType.marketingConsent);
    });

    test('updateMarketingContact logs error and rethrows on failure', () async {
      when(mockApiService.updateMarketingContact(consent: false)).thenThrow(Exception('fail'));

      await expectLater(store.updateMarketingContact(consent: false), throwsException);

      verify(
        mockAnalyticsStore.logEvent(
          AnalyticsEvent.updateMarketingContactError,
          parameters: argThat(containsPair('error', contains('fail')), named: 'parameters'),
        ),
      ).called(1);
    });

    test('getMarketingConsent returns consent and sets user property', () async {
      store.setMarketingConsentFuture = ObservableFuture.value(null);
      when(mockApiService.getMarketingContactStatus()).thenAnswer((_) async => true);

      final result = await store.getMarketingConsent();

      expect(result, isTrue);
      verify(
        mockAnalyticsStore.setUserProperty(
          AnalyticsUserProperty.fromEnum(
            name: AnalyticsUserPropName.marketingConsent,
            value: 'true',
          ),
        ),
      ).called(1);
      verify(mockAnalyticsStore.logEvent(AnalyticsEvent.getMarketingContactSuccess)).called(1);
    });

    test('getMarketingConsent waits for setMarketingConsentFuture', () async {
      var setCompleted = false;
      when(
        mockApiService.createMarketingContact(country: anyNamed('country')),
      ).thenAnswer((_) async => setCompleted = true);
      when(mockApiService.getMarketingContactStatus()).thenAnswer((_) async => true);

      // Setup authenticated state
      when(mockAuthSessionStore.isAuthenticated).thenReturn(true);
      when(
        mockAuthSessionStore.userFuture,
      ).thenAnswer((_) => ObservableFuture.value(AuthUser(userId: '1', username: 'test@test.com')));

      // Recreate store to trigger auth reaction
      store = UserPreferencesStore(
        apiService: mockApiService,
        analyticsStore: mockAnalyticsStore,
        realIPInfo: mockRealIPInfoStore,
        localDBService: mockLocalDBService,
        pushNotificationsStore: mockPushNotificationsStore,
        authSessionStore: mockAuthSessionStore,
      )..testIsMobile = true;

      await store.setMarketingConsentFuture;
      expect(setCompleted, isTrue);
    });

    test('getMarketingConsent logs error and rethrows on failure', () async {
      store.setMarketingConsentFuture = ObservableFuture.value(null);
      when(mockApiService.getMarketingContactStatus()).thenThrow(Exception('fail'));

      await expectLater(store.getMarketingConsent(), throwsException);

      verify(
        mockAnalyticsStore.logEvent(
          AnalyticsEvent.getMarketingContactError,
          parameters: argThat(containsPair('error', contains('fail')), named: 'parameters'),
        ),
      ).called(1);
    });

    test('marketingConsent computed property returns correct value', () {
      store.getMarketingConsentFuture = ObservableFuture.value(true);
      expect(store.marketingConsent, isTrue);

      store.getMarketingConsentFuture = ObservableFuture.value(false);
      expect(store.marketingConsent, isFalse);

      store.getMarketingConsentFuture = null;
      expect(store.marketingConsent, isNull);
    });
  });

  group('Next Prompt Logic', () {
    test('evaluatePromptToShow prioritizes marketing consent over push notifications', () async {
      store.getMarketingConsentFuture = ObservableFuture.value(false);
      when(mockLocalDBService.getMarketingConsentShown()).thenAnswer((_) async => false);
      when(mockLocalDBService.getAppOpenCount()).thenAnswer((_) async => 3);
      when(
        mockPushNotificationsStore.shouldShowPushNotificationsPermissionPrompt(),
      ).thenAnswer((_) async => true);

      await store.evaluatePromptToShow();

      // Marketing consent should take priority
      expect(store.nextPromptToShow, UserPromptType.marketingConsent);
    });

    test('evaluatePromptToShow shows push when marketing not needed', () async {
      store.getMarketingConsentFuture = ObservableFuture.value(false);
      when(mockLocalDBService.getMarketingConsentShown()).thenAnswer((_) async => true);
      when(mockLocalDBService.getAppOpenCount()).thenAnswer((_) async => 3);
      when(
        mockPushNotificationsStore.shouldShowPushNotificationsPermissionPrompt(),
      ).thenAnswer((_) async => true);

      await store.evaluatePromptToShow();

      expect(store.nextPromptToShow, UserPromptType.pushNotifications);
    });

    test('evaluatePromptToShow shows none when marketing consent already shown', () async {
      store.getMarketingConsentFuture = ObservableFuture.value(false);
      when(mockLocalDBService.getMarketingConsentShown()).thenAnswer((_) async => true);
      when(mockLocalDBService.getAppOpenCount()).thenAnswer((_) async => 3);
      when(
        mockPushNotificationsStore.shouldShowPushNotificationsPermissionPrompt(),
      ).thenAnswer((_) async => false);

      await store.evaluatePromptToShow();

      expect(store.nextPromptToShow, UserPromptType.none);
    });

    test('evaluatePromptToShow shows none when all prompts done', () async {
      store.getMarketingConsentFuture = ObservableFuture.value(true);
      when(mockLocalDBService.getMarketingConsentShown()).thenAnswer((_) async => true);
      when(mockLocalDBService.getAppOpenCount()).thenAnswer((_) async => 3);
      when(
        mockPushNotificationsStore.shouldShowPushNotificationsPermissionPrompt(),
      ).thenAnswer((_) async => false);

      await store.evaluatePromptToShow();

      expect(store.nextPromptToShow, UserPromptType.none);
    });

    test('evaluatePromptToShow shows marketing on non-mobile', () async {
      store
        ..testIsMobile = false
        ..getMarketingConsentFuture = ObservableFuture.value(false);
      when(mockLocalDBService.getMarketingConsentShown()).thenAnswer((_) async => false);
      when(mockLocalDBService.getAppOpenCount()).thenAnswer((_) async => 3);
      when(
        mockPushNotificationsStore.shouldShowPushNotificationsPermissionPrompt(),
      ).thenAnswer((_) async => false);

      await store.evaluatePromptToShow();

      // Marketing consent should show even on non-mobile
      expect(store.nextPromptToShow, UserPromptType.marketingConsent);
    });

    test('evaluatePromptToShow shows none when not 3rd app open', () async {
      store.getMarketingConsentFuture = ObservableFuture.value(false);
      when(mockLocalDBService.getMarketingConsentShown()).thenAnswer((_) async => false);
      when(mockLocalDBService.getAppOpenCount()).thenAnswer((_) async => 2);
      when(
        mockPushNotificationsStore.shouldShowPushNotificationsPermissionPrompt(),
      ).thenAnswer((_) async => false);

      await store.evaluatePromptToShow();

      expect(store.nextPromptToShow, UserPromptType.none);
    });

    test('evaluatePromptToShow shows push on 1st open if eligible', () async {
      store.getMarketingConsentFuture = ObservableFuture.value(false);
      when(mockLocalDBService.getMarketingConsentShown()).thenAnswer((_) async => false);
      when(mockLocalDBService.getAppOpenCount()).thenAnswer((_) async => 1);
      when(
        mockPushNotificationsStore.shouldShowPushNotificationsPermissionPrompt(),
      ).thenAnswer((_) async => true);

      await store.evaluatePromptToShow();

      // Push can show on any open, not just 3rd
      expect(store.nextPromptToShow, UserPromptType.pushNotifications);
    });
  });

  group('Integration - One Popup Per App Open', () {
    test('closing marketing consent does not trigger push notifications in same session', () async {
      store
        ..nextPromptToShow = UserPromptType.marketingConsent
        ..getMarketingConsentFuture = ObservableFuture.value(false);
      when(mockLocalDBService.getAppOpenCount()).thenAnswer((_) async => 3);

      when(mockApiService.updateMarketingContact(consent: true)).thenAnswer((_) async => {});
      when(mockLocalDBService.setMarketingConsentShown()).thenAnswer((_) async {});
      when(
        mockPushNotificationsStore.shouldShowPushNotificationsPermissionPrompt(),
      ).thenAnswer((_) async => true);

      await store.updateMarketingContact(consent: true, fromPopup: true);

      // nextPromptToShow should NOT change to push notifications
      expect(store.nextPromptToShow, UserPromptType.marketingConsent);
    });
  });

  group('ObservableFuture Status', () {
    test('setMarketingConsentFuture is created during initStore', () async {
      expect(store.setMarketingConsentFuture, isNull);

      // Trigger auth state change to authenticate
      when(mockAuthSessionStore.isAuthenticated).thenReturn(true);
      when(
        mockAuthSessionStore.userFuture,
      ).thenAnswer((_) => ObservableFuture.value(AuthUser(userId: '1', username: 'test@test.com')));

      // Recreate store to trigger auth reaction
      final newStore = UserPreferencesStore(
        apiService: mockApiService,
        analyticsStore: mockAnalyticsStore,
        realIPInfo: mockRealIPInfoStore,
        localDBService: mockLocalDBService,
        pushNotificationsStore: mockPushNotificationsStore,
        authSessionStore: mockAuthSessionStore,
      )..testIsMobile = true;

      // Wait for auth reaction and initStore to complete
      await pumpEventQueue();

      expect(newStore.setMarketingConsentFuture, isNotNull);
    });

    test('getMarketingConsentFuture is created during initStore', () async {
      expect(store.getMarketingConsentFuture, isNull);

      // Trigger auth state change to authenticate
      when(mockAuthSessionStore.isAuthenticated).thenReturn(true);
      when(
        mockAuthSessionStore.userFuture,
      ).thenAnswer((_) => ObservableFuture.value(AuthUser(userId: '1', username: 'test@test.com')));

      // Recreate store to trigger auth reaction
      final newStore = UserPreferencesStore(
        apiService: mockApiService,
        analyticsStore: mockAnalyticsStore,
        realIPInfo: mockRealIPInfoStore,
        localDBService: mockLocalDBService,
        pushNotificationsStore: mockPushNotificationsStore,
        authSessionStore: mockAuthSessionStore,
      )..testIsMobile = true;

      // Wait for auth reaction and initStore to complete
      await pumpEventQueue();

      expect(newStore.getMarketingConsentFuture, isNotNull);
    });

    test('updateMarketingConsentFuture starts with completed value', () {
      expect(store.updateMarketingConsentFuture.status, FutureStatus.fulfilled);
    });
  });
}
