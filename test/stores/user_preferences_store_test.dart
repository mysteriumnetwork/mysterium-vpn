import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/user_preferences_store.dart';

import 'locations_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ApiService>(),
  MockSpec<AnalyticsStore>(),
])
void main() {
  late UserPreferencesStore store;
  late MockApiService mockApiService;
  late MockAnalyticsStore mockAnalyticsStore;

  setUp(() {
    mockApiService = MockApiService();
    mockAnalyticsStore = MockAnalyticsStore();
    store = UserPreferencesStore(
      apiService: mockApiService,
      analyticsStore: mockAnalyticsStore,
    );
  });

  test('setUserPrefsMarketingConsent calls API and logs success analytics', () async {
    when(mockApiService.setMarketingConsentStatus(consent: true))
        .thenAnswer((_) async => Future.value());

    await store.setMarketingConsent(consent: true);

    verify(mockApiService.setMarketingConsentStatus(consent: true)).called(1);
    verify(mockAnalyticsStore.setUserProperty('marketing_consent', 'true')).called(1);
    verify(
      mockAnalyticsStore.logEvent(
        AnalyticsEvent.setMarketingConsentSuccess,
        parameters: {'consent': 'true'},
      ),
    ).called(1);
    verifyNever(
      mockAnalyticsStore.logEvent(
        AnalyticsEvent.setMarketingConsentError,
        parameters: anyNamed('parameters'),
      ),
    );
  });

  test('setUserPrefsMarketingConsent logs error analytics on API failure', () async {
    when(mockApiService.setMarketingConsentStatus(consent: false))
        .thenThrow(Exception('API error'));

    await store.setMarketingConsent(consent: false);

    verify(mockApiService.setMarketingConsentStatus(consent: false)).called(1);
    verifyNever(mockAnalyticsStore.setUserProperty(any, any));
    verify(
      mockAnalyticsStore.logEvent(
        AnalyticsEvent.setMarketingConsentError,
        parameters: argThat(
          containsPair('error', contains('API error')),
          named: 'parameters',
        ),
      ),
    ).called(1);
  });
}
