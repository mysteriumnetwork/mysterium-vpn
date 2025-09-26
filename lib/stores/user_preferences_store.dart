import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/real_ip_info_store.dart';

part 'user_preferences_store.g.dart';

// ignore: library_private_types_in_public_api
class UserPreferencesStore = _UserPreferencesStore with _$UserPreferencesStore;

abstract class _UserPreferencesStore with Store {
  _UserPreferencesStore({
    required ApiService apiService,
    required AnalyticsStore analyticsStore,
    required RealIPInfoStore realIPInfo,
    required LocalDBService localDBService,
  })  : _apiService = apiService,
        _analyticsStore = analyticsStore,
        _realIPInfo = realIPInfo,
        localDb = localDBService;

  @action
  void initStore() {
    setMarketingConsentFuture = ObservableFuture(createMarketingContact());
    getMarketingConsentFuture = ObservableFuture(getMarketingConsent());
    shouldShowMarketingConsent();
  }

  final ApiService _apiService;
  final AnalyticsStore _analyticsStore;
  final RealIPInfoStore _realIPInfo;
  final LocalDBService localDb;
  ReactionDisposer? _authReactionDisposer;

  @observable
  ObservableFuture<void>? setMarketingConsentFuture;

  @observable
  ObservableFuture<void> updateMarketingConsentFuture = ObservableFuture.value(null);

  @observable
  ObservableFuture<bool>? getMarketingConsentFuture;

  @observable
  bool canShowMarketingConsentDialog = false;

  @computed
  bool? get marketingConsent => getMarketingConsentFuture?.value;

  @visibleForTesting
  @action
  Future<void> shouldShowMarketingConsent() async {
    final consentValue = await getMarketingConsentFuture;
    final consentShown = await localDb.getMarketingConsentShown();
    canShowMarketingConsentDialog = consentValue == false && !consentShown;
  }

  @visibleForTesting
  @action
  Future<void> setMarketingConsentShown() async {
    await localDb.setMarketingConsentShown();
    await shouldShowMarketingConsent();
  }

  // Create a marketing contact in Omnisend
  // Will be called after login/signup and API will decide if the user is already subscribed
  @action
  Future<void> createMarketingContact() async {
    try {
      final country = (await _realIPInfo.infoFuture)?.country;
      await _apiService.createMarketingContact(country: country);
      _analyticsStore.logEvent(
        AnalyticsEvent.createMarketingContactSuccess,
      );
    } catch (e) {
      _analyticsStore.logEvent(
        AnalyticsEvent.createMarketingContactError,
        parameters: {'error': e.toString()},
      );
    }
  }

  @action
  Future<void> updateMarketingContact({
    required bool consent,
    bool fromPopup = false,
  }) async {
    try {
      updateMarketingConsentFuture =
          ObservableFuture(_apiService.updateMarketingContact(consent: consent));
      await updateMarketingConsentFuture;
      _analyticsStore.logEvent(
        AnalyticsEvent.updateMarketingContactSuccess,
      );
      getMarketingConsentFuture = ObservableFuture.value(consent);
      if (fromPopup) {
        setMarketingConsentShown();
      }
    } catch (e) {
      _analyticsStore.logEvent(
        AnalyticsEvent.updateMarketingContactError,
        parameters: {'error': e.toString()},
      );
      rethrow;
    }
  }

  @action
  Future<bool> getMarketingConsent() async {
    try {
      await setMarketingConsentFuture;
      getMarketingConsentFuture = ObservableFuture(_apiService.getMarketingContactStatus());
      final consent = await getMarketingConsentFuture!;
      _analyticsStore
        ..setUserProperty(propertyName: 'marketing_consent', propertyValue: consent.toString())
        ..logEvent(
          AnalyticsEvent.getMarketingContactSuccess,
        );
      return consent;
    } catch (e) {
      _analyticsStore.logEvent(
        AnalyticsEvent.getMarketingContactError,
        parameters: {'error': e.toString()},
      );
      rethrow;
    }
  }

  FutureOr<void> dispose() async {
    _authReactionDisposer?.call();
  }
}
