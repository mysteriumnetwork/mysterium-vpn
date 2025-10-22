import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/ip_info.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/real_ip_info_store.dart';
import 'package:mysterium_vpn/stores/user_preferences_store.dart';
import 'package:wireguard_dart/wireguard_dart.dart';

import 'user_preferences_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ApiService>(),
  MockSpec<AnalyticsStore>(),
  MockSpec<RealIPInfoStore>(),
  MockSpec<LocalDBService>(),
  MockSpec<WireguardDart>(),
])
void main() {
  late UserPreferencesStore store;
  late MockApiService mockApiService;
  late MockAnalyticsStore mockAnalyticsStore;
  late MockRealIPInfoStore mockRealIPInfoStore;
  late MockLocalDBService mockLocalDBService;
  late MockWireguardDart mockWireguardService;

  setUp(() {
    mockApiService = MockApiService();
    mockAnalyticsStore = MockAnalyticsStore();
    mockRealIPInfoStore = MockRealIPInfoStore();
    mockLocalDBService = MockLocalDBService();
    mockWireguardService = MockWireguardDart();

    store = UserPreferencesStore(
      apiService: mockApiService,
      analyticsStore: mockAnalyticsStore,
      realIPInfo: mockRealIPInfoStore,
      localDBService: mockLocalDBService,
      wireguardService: mockWireguardService,
    )..testIsAndroid = true;

    when(mockRealIPInfoStore.infoFuture).thenAnswer(
      (_) => ObservableFuture.value(
        const IPInfo(city: 'Test City', country: 'Test Country', ip: ''),
      ),
    );
  });

  group('Marketing Consent', () {
    test('shouldShowMarketingConsent returns false if consent is true or already shown', () async {
      store.getMarketingConsentFuture = ObservableFuture.value(true);
      when(mockLocalDBService.getMarketingConsentShown()).thenAnswer((_) async => false);
      final result1 = await store.shouldShowMarketingConsent();
      expect(result1, isFalse);

      store.getMarketingConsentFuture = ObservableFuture.value(false);
      when(mockLocalDBService.getMarketingConsentShown()).thenAnswer((_) async => true);
      final result2 = await store.shouldShowMarketingConsent();
      expect(result2, isFalse);
    });

    test('shouldShowMarketingConsent returns true if consent is false and not shown', () async {
      store.getMarketingConsentFuture = ObservableFuture.value(false);
      when(mockLocalDBService.getMarketingConsentShown()).thenAnswer((_) async => false);
      final result = await store.shouldShowMarketingConsent();
      expect(result, isTrue);
    });

    test('setMarketingConsentShown calls localDb and re-evaluates prompt', () async {
      when(mockLocalDBService.setMarketingConsentShown()).thenAnswer((_) async {});
      when(mockLocalDBService.getMarketingConsentShown()).thenAnswer((_) async => true);
      when(mockWireguardService.checkNotificationPermission())
          .thenAnswer((_) async => NotificationPermission.granted);

      await store.setMarketingConsentShown();
      verify(mockLocalDBService.setMarketingConsentShown()).called(1);
      expect(store.nextPromptToShow, UserPromptType.none);
    });

    test('createMarketingContact logs success and failure events', () async {
      when(mockApiService.createMarketingContact(country: anyNamed('country')))
          .thenAnswer((_) async => {});
      await store.createMarketingContact();
      verify(mockAnalyticsStore.logEvent(AnalyticsEvent.createMarketingContactSuccess)).called(1);

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

    test('updateMarketingContact updates consent and logs events', () async {
      when(mockApiService.updateMarketingContact(consent: true)).thenAnswer((_) async => {});
      await store.updateMarketingContact(consent: true);
      expect(store.getMarketingConsentFuture?.value, isTrue);
      verify(mockAnalyticsStore.logEvent(AnalyticsEvent.updateMarketingContactSuccess)).called(1);

      when(mockApiService.updateMarketingContact(consent: false)).thenThrow(Exception('fail'));
      await expectLater(store.updateMarketingContact(consent: false), throwsException);
      verify(
        mockAnalyticsStore.logEvent(
          AnalyticsEvent.updateMarketingContactError,
          parameters: argThat(containsPair('error', contains('fail')), named: 'parameters'),
        ),
      ).called(1);
    });

    test('getMarketingConsent returns consent and logs success and failure', () async {
      when(mockApiService.getMarketingContactStatus()).thenAnswer((_) async => true);
      await store.getMarketingConsent();
      verify(
        mockAnalyticsStore.setUserProperty(
          propertyName: 'marketing_consent',
          propertyValue: 'true',
        ),
      ).called(1);
      verify(mockAnalyticsStore.logEvent(AnalyticsEvent.getMarketingContactSuccess)).called(1);

      when(mockApiService.getMarketingContactStatus()).thenThrow(Exception('fail'));
      await expectLater(store.getMarketingConsent(), throwsException);
      verify(
        mockAnalyticsStore.logEvent(
          AnalyticsEvent.getMarketingContactError,
          parameters: argThat(containsPair('error', contains('fail')), named: 'parameters'),
        ),
      ).called(1);
    });
  });

  group('Next Prompt Logic', () {
    test('evaluateNextPromptToShow sets nextPromptToShow correctly', () async {
      // Case 1: Marketing consent
      store.getMarketingConsentFuture = ObservableFuture.value(false);
      when(mockLocalDBService.getMarketingConsentShown()).thenAnswer((_) async => false);
      when(mockWireguardService.checkNotificationPermission())
          .thenAnswer((_) async => NotificationPermission.denied);

      await store.evaluateNextPromptToShow();
      expect(store.nextPromptToShow, UserPromptType.marketingConsent);

      // Reset push notification flag for next evaluation
      store
        ..pushNotificationsPromptShown = false
        ..getMarketingConsentFuture = ObservableFuture.value(true);
      when(mockLocalDBService.getMarketingConsentShown()).thenAnswer((_) async => true);
      when(mockWireguardService.checkNotificationPermission())
          .thenAnswer((_) async => NotificationPermission.denied);

      await store.evaluateNextPromptToShow();
      expect(store.nextPromptToShow, UserPromptType.pushNotifications);

      // Case 3: None to show
      when(mockWireguardService.checkNotificationPermission())
          .thenAnswer((_) async => NotificationPermission.granted);

      await store.evaluateNextPromptToShow();
      expect(store.nextPromptToShow, UserPromptType.none);
    });

    test('shouldShowPushNotificationsPermissionPrompt works with Android flag', () async {
      store.pushNotificationsPromptShown = false;

      when(mockWireguardService.checkNotificationPermission())
          .thenAnswer((_) async => NotificationPermission.denied);

      final result = await store.shouldShowPushNotificationsPermissionPrompt();
      expect(result, isTrue);

      // Already shown
      store.pushNotificationsPromptShown = true;
      final result2 = await store.shouldShowPushNotificationsPermissionPrompt();
      expect(result2, isFalse);

      // Non-Android device
      store
        ..testIsAndroid = false
        ..pushNotificationsPromptShown = false;
      final result3 = await store.shouldShowPushNotificationsPermissionPrompt();
      expect(result3, isFalse);
    });

    test('setPushNotificationsShown sets flag and calls requestPermission', () async {
      store.pushNotificationsPromptShown = false;
      when(mockWireguardService.requestNotificationPermission())
          .thenAnswer((_) async => NotificationPermission.granted);
      await store.setPushNotificationsShown(userAllowed: true);
      expect(store.pushNotificationsPromptShown, isTrue);
      verify(mockWireguardService.requestNotificationPermission()).called(1);
    });

    test('updatePushNotificationsPermissions calls openAppNotificationSettings only on Android',
        () async {
      store.testIsAndroid = true;
      when(mockWireguardService.openAppNotificationSettings())
          .thenAnswer((_) async => NotificationPermission.granted);
      await store.updatePushNotificationsPermissions();
      verify(mockWireguardService.openAppNotificationSettings()).called(1);

      store.testIsAndroid = false;
      await store.updatePushNotificationsPermissions();
      verifyNever(mockWireguardService.openAppNotificationSettings());
    });
  });
}
