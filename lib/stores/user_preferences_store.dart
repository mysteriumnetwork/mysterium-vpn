import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';

part 'user_preferences_store.g.dart';

// ignore: library_private_types_in_public_api
class UserPreferencesStore = _UserPreferencesStore with _$UserPreferencesStore;

abstract class _UserPreferencesStore with Store {
  _UserPreferencesStore({
    required ApiService apiService,
  }) : _apiService = apiService;

  final ApiService _apiService;
  final LocalDBService _localDb = LocalDBService.instance;

  @observable
  ObservableFuture<void> setMarketingConsentFeature = ObservableFuture.value(null);

  @observable
  ObservableFuture<void> getMarketingConsentFeature = ObservableFuture.value(null);

  @observable
  ObservableFuture<void> setEmailMarketingConsentFeature = ObservableFuture.value(null);

  @computed
  FutureStatus get setMarketingConsentFeatureStatus => setMarketingConsentFeature.status;

  Future<bool> getVpnPrivacyPolicyConsent() async => _localDb.getVpnPrivacyPolicyConsent();

  Future<void> setVpnPrivacyPolicyConsent({required bool approval}) async {
    await _localDb.setVpnPrivacyPolicyConsent(approval: approval);
  }

  @action
  Future<void> setUserPrefsMarketingConsent({required bool consent}) async {
    setMarketingConsentFeature =
        ObservableFuture(_apiService.setUserPrefsMarketingConsent(consent: consent));
    await setMarketingConsentFeature;
  }

  @action
  Future<void> getUserPrefsMarketingConsent() async {
    getMarketingConsentFeature = ObservableFuture(_apiService.getUserPrefsMarketingConsent());
    await getMarketingConsentFeature;
  }

  @action
  Future<void> setEmailMarketingConsent({
    required bool consent,
  }) async {
    setEmailMarketingConsentFeature = ObservableFuture(
      _apiService.setEmailMarketingConsent(
        consent: consent,
      ),
    );
    await setEmailMarketingConsentFeature;
  }
}
