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

import 'user_preferences_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ApiService>(),
  MockSpec<AnalyticsStore>(),
  MockSpec<RealIPInfoStore>(),
  MockSpec<LocalDBService>(),
])
void main() {
  late UserPreferencesStore store;
  late MockApiService mockApiService;
  late MockAnalyticsStore mockAnalyticsStore;
  late MockRealIPInfoStore mockRealIPInfoStore;
  late MockLocalDBService mockLocalDBService;

  setUp(() {
    mockApiService = MockApiService();
    mockAnalyticsStore = MockAnalyticsStore();
    mockRealIPInfoStore = MockRealIPInfoStore();
    mockLocalDBService = MockLocalDBService();
    store = UserPreferencesStore(
      apiService: mockApiService,
      analyticsStore: mockAnalyticsStore,
      realIPInfo: mockRealIPInfoStore,
      localDBService: mockLocalDBService,
    );

    when(mockRealIPInfoStore.infoFuture).thenAnswer(
      (_) => ObservableFuture.value(
        const IPInfo(
          city: 'Test City',
          country: 'Test Country',
          ip: '',
        ),
      ),
    );
  });

  test('shouldShowMarketingConsent returns false if consent is true or already shown', () async {
    when(mockApiService.getMarketingContactStatus()).thenAnswer((_) async => true);
    when(mockLocalDBService.getMarketingConsentShown()).thenAnswer((_) async => false);

    store.getMarketingConsentFuture = ObservableFuture(Future.value(true));
    await store.shouldShowMarketingConsent();
    expect(store.canShowMarketingConsentDialog, isFalse);

    store.getMarketingConsentFuture = ObservableFuture(Future.value(false));
    when(mockLocalDBService.getMarketingConsentShown()).thenAnswer((_) async => true);
    await store.shouldShowMarketingConsent();
    expect(store.canShowMarketingConsentDialog, isFalse);
  });

  test('shouldShowMarketingConsent returns true if consent is false and not shown', () async {
    store.getMarketingConsentFuture = ObservableFuture(Future.value(false));
    when(mockLocalDBService.getMarketingConsentShown()).thenAnswer((_) async => false);

    await store.shouldShowMarketingConsent();
    expect(store.canShowMarketingConsentDialog, isTrue);
  });

  test('setMarketingConsentShown sets shouldShowMarketingConsentFeature to false', () async {
    when(mockLocalDBService.setMarketingConsentShown()).thenAnswer((_) async {});
    when(mockLocalDBService.getMarketingConsentShown()).thenAnswer((_) async => true);
    await store.setMarketingConsentShown();
    expect(store.canShowMarketingConsentDialog, isFalse);
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

  test('updateMarketingContact logs error on failure', () async {
    when(mockApiService.updateMarketingContact(consent: false)).thenThrow(Exception('fail'));
    try {
      await store.updateMarketingContact(consent: false);
    } catch (_) {}
    verify(
      mockAnalyticsStore.logEvent(
        AnalyticsEvent.updateMarketingContactError,
        parameters: argThat(containsPair('error', contains('fail')), named: 'parameters'),
      ),
    ).called(1);
  });

  test('getMarketingConsent returns consent and logs success', () async {
    when(mockApiService.getMarketingContactStatus()).thenAnswer((_) async => true);
    await store.getMarketingConsent();
    verify(
      mockAnalyticsStore.setUserProperty(
        propertyName: 'marketing_consent',
        propertyValue: 'true',
      ),
    ).called(1);
    verify(mockAnalyticsStore.logEvent(AnalyticsEvent.getMarketingContactSuccess)).called(1);
  });

  test('getMarketingConsent logs error on failure', () async {
    when(mockApiService.getMarketingContactStatus()).thenThrow(Exception('fail'));
    try {
      await store.getMarketingConsent();
    } catch (_) {}
    verify(
      mockAnalyticsStore.logEvent(
        AnalyticsEvent.getMarketingContactError,
        parameters: argThat(containsPair('error', contains('fail')), named: 'parameters'),
      ),
    ).called(1);
  });
}
