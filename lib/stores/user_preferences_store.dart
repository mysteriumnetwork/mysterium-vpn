import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';

part 'user_preferences_store.g.dart';

// ignore: library_private_types_in_public_api
class UserPreferencesStore = _UserPreferencesStore with _$UserPreferencesStore;

abstract class _UserPreferencesStore with Store {
  _UserPreferencesStore({
    required ApiService apiService,
  }) : _apiService = apiService;

  final ApiService _apiService;

  @observable
  ObservableFuture<void> setMarketingConsentFeature = ObservableFuture.value(null);

  @observable
  ObservableFuture<void> getMarketingConsentFeature = ObservableFuture.value(null);

  @computed
  FutureStatus get setMarketingConsentFeatureStatus => setMarketingConsentFeature.status;

  @action
  Future<void> setMarketingConsent({required bool consent}) async {
    setMarketingConsentFeature =
        ObservableFuture(_apiService.setMarketingConsent(consent: consent));
    await setMarketingConsentFeature;
  }

  @action
  Future<void> getMarketingConsent() async {
    getMarketingConsentFeature = ObservableFuture(_apiService.getMarketingConsent());
    await getMarketingConsentFeature;
  }
}
