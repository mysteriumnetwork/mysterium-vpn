import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
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
])
void main() {
  late UserPreferencesStore store;
  late MockApiService mockApiService;
  late MockAnalyticsStore mockAnalyticsStore;
  late MockRealIPInfoStore mockRealIPInfoStore;
  late MockLocalDBService mockLocalDBService;
  late MockPushNotificationsStore mockPushNotificationsStore;

  setUp(() {
    mockApiService = MockApiService();
    mockAnalyticsStore = MockAnalyticsStore();
    mockRealIPInfoStore = MockRealIPInfoStore();
    mockLocalDBService = MockLocalDBService();
    mockPushNotificationsStore = MockPushNotificationsStore();

    when(mockRealIPInfoStore.infoFuture).thenAnswer(
      (_) => ObservableFuture.value(
        const IPInfo(city: 'Test City', country: 'Test Country', ip: ''),
      ),
    );

    // Default stubs to prevent null errors during initStore
    when(mockApiService.createMarketingContact(country: anyNamed('country')))
        .thenAnswer((_) async => {});
    when(mockApiService.getMarketingContactStatus()).thenAnswer((_) async => false);
    when(mockLocalDBService.getMarketingConsentShown()).thenAnswer((_) async => false);
    when(mockPushNotificationsStore.shouldShowPushNotificationsPermissionPrompt())
        .thenAnswer((_) async => false);

    store = UserPreferencesStore(
      apiService: mockApiService,
      analyticsStore: mockAnalyticsStore,
      realIPInfo: mockRealIPInfoStore,
      localDBService: mockLocalDBService,
      pushNotificationsStore: mockPushNotificationsStore,
    )..testIsMobile = true;
  });

  group('Initialization', () {
    test('initStore creates marketing contact and gets consent', () async {
      store.initStore();

      // Wait for futures to complete
      await store.setMarketingConsentFuture;
      await store.getMarketingConsentFuture;

      verify(mockApiService.createMarketingContact(country: 'Test Country')).called(1);
      verify(mockApiService.getMarketingContactStatus()).called(1);
    });

    test('initStore evaluates next prompt to show', () async {
      when(mockApiService.getMarketingContactStatus()).thenAnswer((_) async => false);
      when(mockLocalDBService.getMarketingConsentShown()).thenAnswer((_) async => false);
      when(mockPushNotificationsStore.shouldShowPushNotificationsPermissionPrompt())
          .thenAnswer((_) async => true);

      store.initStore();

      await store.setMarketingConsentFuture;
      await store.getMarketingConsentFuture;

      // Give evaluateNextPromptToShow time to complete
      await Future.delayed(Duration.zero);

      // Should show marketing consent first
      expect(store.nextPromptToShow, UserPromptType.marketingConsent);
    });
  });

  group('Marketing Consent', () {
    test('shouldShowMarketingConsent returns false if consent is true', () async {
      store.getMarketingConsentFuture = ObservableFuture.value(true);
      when(mockLocalDBService.getMarketingConsentShown()).thenAnswer((_) async => false);

      final result = await store.shouldShowMarketingConsent();
      expect(result, isFalse);
    });

    test('shouldShowMarketingConsent returns false if already shown', () async {
      store.getMarketingConsentFuture = ObservableFuture.value(false);
      when(mockLocalDBService.getMarketingConsentShown()).thenAnswer((_) async => true);

      final result = await store.shouldShowMarketingConsent();
      expect(result, isFalse);
    });

    test('shouldShowMarketingConsent returns true if consent is false and not shown', () async {
      store.getMarketingConsentFuture = ObservableFuture.value(false);
      when(mockLocalDBService.getMarketingConsentShown()).thenAnswer((_) async => false);

      final result = await store.shouldShowMarketingConsent();
      expect(result, isTrue);
    });

    test('setMarketingConsentShown calls localDb and re-evaluates prompt', () async {
      store.getMarketingConsentFuture = ObservableFuture.value(true);
      when(mockLocalDBService.setMarketingConsentShown()).thenAnswer((_) async {});
      when(mockLocalDBService.getMarketingConsentShown()).thenAnswer((_) async => true);
      when(mockPushNotificationsStore.shouldShowPushNotificationsPermissionPrompt())
          .thenAnswer((_) async => false);

      await store.setMarketingConsentShown();

      verify(mockLocalDBService.setMarketingConsentShown()).called(1);
      expect(store.nextPromptToShow, UserPromptType.none);
    });

    test('createMarketingContact logs success event', () async {
      when(mockApiService.createMarketingContact(country: anyNamed('country')))
          .thenAnswer((_) async => {});

      await store.createMarketingContact();

      verify(mockAnalyticsStore.logEvent(AnalyticsEvent.createMarketingContactSuccess)).called(1);
    });

    test('createMarketingContact logs error event on failure', () async {
      when(mockApiService.createMarketingContact(country: anyNamed('country')))
          .thenThrow(Exception('fail'));

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
      store.getMarketingConsentFuture = ObservableFuture.value(true);
      when(mockApiService.updateMarketingContact(consent: true)).thenAnswer((_) async => {});
      when(mockLocalDBService.setMarketingConsentShown()).thenAnswer((_) async {});
      when(mockLocalDBService.getMarketingConsentShown()).thenAnswer((_) async => true);
      when(mockPushNotificationsStore.shouldShowPushNotificationsPermissionPrompt())
          .thenAnswer((_) async => true);

      await store.updateMarketingContact(consent: true, fromPopup: true);

      verify(mockLocalDBService.setMarketingConsentShown()).called(1);
    });

    test('updateMarketingContact does not call setMarketingConsentShown when fromPopup is false',
        () async {
      when(mockApiService.updateMarketingContact(consent: true)).thenAnswer((_) async => {});

      await store.updateMarketingContact(consent: true);

      verifyNever(mockLocalDBService.setMarketingConsentShown());
    });

    test('updateMarketingContact logs error and rethrows on failure', () async {
      when(mockApiService.updateMarketingContact(consent: false)).thenThrow(Exception('fail'));

      await expectLater(
        store.updateMarketingContact(consent: false),
        throwsException,
      );

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
      store.setMarketingConsentFuture = ObservableFuture(
        Future.delayed(const Duration(milliseconds: 100), () => setCompleted = true),
      );
      when(mockApiService.getMarketingContactStatus()).thenAnswer((_) async => true);

      await store.getMarketingConsent();

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
    test('evaluateNextPromptToShow prioritizes marketing consent', () async {
      store
        ..pushNotificationsPromptShown = false
        ..getMarketingConsentFuture = ObservableFuture.value(false);
      when(mockLocalDBService.getMarketingConsentShown()).thenAnswer((_) async => false);
      when(mockPushNotificationsStore.shouldShowPushNotificationsPermissionPrompt())
          .thenAnswer((_) async => true);

      await store.evaluateNextPromptToShow();

      expect(store.nextPromptToShow, UserPromptType.marketingConsent);
    });

    test('evaluateNextPromptToShow shows push notifications when marketing consent done', () async {
      store
        ..pushNotificationsPromptShown = false
        ..getMarketingConsentFuture = ObservableFuture.value(true);
      when(mockLocalDBService.getMarketingConsentShown()).thenAnswer((_) async => true);
      when(mockPushNotificationsStore.shouldShowPushNotificationsPermissionPrompt())
          .thenAnswer((_) async => true);

      await store.evaluateNextPromptToShow();

      expect(store.nextPromptToShow, UserPromptType.pushNotifications);
    });

    test('evaluateNextPromptToShow shows none when all prompts done', () async {
      store
        ..pushNotificationsPromptShown = false
        ..getMarketingConsentFuture = ObservableFuture.value(true);
      when(mockLocalDBService.getMarketingConsentShown()).thenAnswer((_) async => true);
      when(mockPushNotificationsStore.shouldShowPushNotificationsPermissionPrompt())
          .thenAnswer((_) async => false);

      await store.evaluateNextPromptToShow();

      expect(store.nextPromptToShow, UserPromptType.none);
    });

    test('evaluateNextPromptToShow shows none when push prompt already shown', () async {
      store
        ..pushNotificationsPromptShown = true
        ..getMarketingConsentFuture = ObservableFuture.value(true);
      when(mockLocalDBService.getMarketingConsentShown()).thenAnswer((_) async => true);
      when(mockPushNotificationsStore.shouldShowPushNotificationsPermissionPrompt())
          .thenAnswer((_) async => false);

      await store.evaluateNextPromptToShow();

      expect(store.nextPromptToShow, UserPromptType.none);
    });

    test('evaluateNextPromptToShow shows none on non-mobile (no push notifications)', () async {
      store
        ..testIsMobile = false
        ..pushNotificationsPromptShown = false
        ..getMarketingConsentFuture = ObservableFuture.value(true);
      when(mockLocalDBService.getMarketingConsentShown()).thenAnswer((_) async => true);

      await store.evaluateNextPromptToShow();

      expect(store.nextPromptToShow, UserPromptType.none);
    });
  });

  group('Platform Detection', () {
    test('isMobilePlatform returns testIsMobile value', () {
      store.testIsMobile = true;
      expect(store.supportsPushNotifications, isTrue);

      store.testIsMobile = false;
      expect(store.supportsPushNotifications, isFalse);
    });
  });
}
