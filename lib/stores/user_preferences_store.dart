import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';

part 'user_preferences_store.g.dart';

// ignore: library_private_types_in_public_api
class UserPreferencesStore = _UserPreferencesStore with _$UserPreferencesStore;

abstract class _UserPreferencesStore with Store {
  _UserPreferencesStore({
    required ApiService apiService,
    required AnalyticsStore analyticsStore,
  })  : _apiService = apiService,
        _analyticsStore = analyticsStore;

  final ApiService _apiService;
  final AnalyticsStore _analyticsStore;

  @observable
  ObservableFuture<void> setMarketingConsentFeature = ObservableFuture.value(null);

  @computed
  FutureStatus get setMarketingConsentFeatureStatus => setMarketingConsentFeature.status;

  @action
  Future<void> setMarketingConsent({required bool consent}) async {
    try {
      setMarketingConsentFeature =
          ObservableFuture(_apiService.setMarketingConsentStatus(consent: consent));

      await setMarketingConsentFeature;

      _analyticsStore
        ..setUserProperty('marketing_consent', consent.toString())
        ..logEvent(
          AnalyticsEvent.setMarketingConsentSuccess,
          parameters: {'consent': consent.toString()},
        );
    } catch (e) {
      _analyticsStore.logEvent(
        AnalyticsEvent.setMarketingConsentError,
        parameters: {'error': e.toString()},
      );
    }
  }
}
