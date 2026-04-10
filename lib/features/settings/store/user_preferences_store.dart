import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';

part 'user_preferences_store.g.dart';

enum UserPromptType { none, marketingConsent, pushNotifications }

// ignore: library_private_types_in_public_api
class UserPreferencesStore = _UserPreferencesStore with _$UserPreferencesStore;

abstract class _UserPreferencesStore with Store, Disposeable {
  _UserPreferencesStore({
    required ApiService apiService,
    required AnalyticsStore analyticsStore,
    required RealIPInfoStore realIPInfo,
    required LocalDBService localDBService,
    required PushNotificationsStore pushNotificationsStore,
    required AuthSessionStore authSessionStore,
  }) : _apiService = apiService,
       _analyticsStore = analyticsStore,
       _realIPInfo = realIPInfo,
       localDb = localDBService,
       _pushNotificationsStore = pushNotificationsStore,
       _authSessionStore = authSessionStore {
    _authReactionDisposer = reaction<bool>(
      (_) => _authSessionStore.isAuthenticated,
      (status) async {
        if (status) {
          await initStore();
        }
      },
      fireImmediately: true,
      equals: (a, b) => a == b,
    );
  }

  @action
  Future<void> initStore() async {
    getMarketingConsentFuture = ObservableFuture(getMarketingConsent());
    await evaluatePromptToShow();
  }

  final ApiService _apiService;
  final AnalyticsStore _analyticsStore;
  final RealIPInfoStore _realIPInfo;
  final LocalDBService localDb;
  final PushNotificationsStore _pushNotificationsStore;
  final AuthSessionStore _authSessionStore;
  ReactionDisposer? _authReactionDisposer;

  @observable
  ObservableFuture<void>? setMarketingConsentFuture;

  @observable
  ObservableFuture<void> updateMarketingConsentFuture = ObservableFuture.value(null);

  @observable
  ObservableFuture<bool>? getMarketingConsentFuture;

  @computed
  bool? get marketingConsent => getMarketingConsentFuture?.value;

  @observable
  UserPromptType nextPromptToShow = UserPromptType.none;

  @visibleForTesting
  bool pushNotificationsPromptShown = false;

  @visibleForTesting
  bool marketingConsentPromptShown = false;

  @visibleForTesting
  bool testIsMobile = false; // default false, will override in tests

  bool get supportsPushNotifications => testIsMobile || isMobile();

  @action
  bool isPromptShown(UserPromptType type) {
    switch (type) {
      case UserPromptType.marketingConsent:
        return marketingConsentPromptShown;
      case UserPromptType.pushNotifications:
        return pushNotificationsPromptShown;
      case UserPromptType.none:
        return false;
    }
  }

  @action
  void markPromptAsShown(UserPromptType type) {
    switch (type) {
      case UserPromptType.marketingConsent:
        marketingConsentPromptShown = true;
      case UserPromptType.pushNotifications:
        pushNotificationsPromptShown = true;
      case UserPromptType.none:
        break;
    }
  }

  @visibleForTesting
  @action
  Future<void> evaluatePromptToShow() async {
    final pushPromptShown = await _pushNotificationsStore
        .shouldShowPushNotificationsPermissionPrompt();
    final marketingConsentShown = await shouldShowMarketingConsent();

    if (marketingConsentShown) {
      nextPromptToShow = UserPromptType.marketingConsent;
    } else if (pushPromptShown) {
      nextPromptToShow = UserPromptType.pushNotifications;
    } else {
      nextPromptToShow = UserPromptType.none;
    }
  }

  @visibleForTesting
  @action
  Future<bool> shouldShowMarketingConsent() async {
    final consentValue = await getMarketingConsentFuture;
    final consentShown = await localDb.getMarketingConsentShown();
    final appOpenCount = await localDb.getAppOpenCount();

    return consentValue == false && !consentShown && appOpenCount >= 3;
  }

  @visibleForTesting
  @action
  Future<void> setMarketingConsentShown() async {
    await localDb.setMarketingConsentShown();
  }

  // Create a marketing contact in Omnisend
  // Will be called after login/signup and API will decide if the user is already subscribed
  @action
  Future<void> createMarketingContact() async {
    try {
      final country = (await _realIPInfo.infoFuture)?.country;
      await _apiService.createMarketingContact(country: country);
      _analyticsStore.logEvent(AnalyticsEvent.createMarketingContactSuccess);
    } catch (e) {
      _analyticsStore.logEvent(
        AnalyticsEvent.createMarketingContactError,
        parameters: {'error': e.toString()},
      );
    }
  }

  @action
  Future<void> updateMarketingContact({required bool consent, bool fromPopup = false}) async {
    try {
      updateMarketingConsentFuture = ObservableFuture(
        _apiService.updateMarketingContact(consent: consent),
      );
      await updateMarketingConsentFuture;
      _analyticsStore.logEvent(AnalyticsEvent.updateMarketingContactSuccess);
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
      if (setMarketingConsentFuture == null ||
          setMarketingConsentFuture?.status != FutureStatus.fulfilled) {
        setMarketingConsentFuture = ObservableFuture(createMarketingContact());
        await setMarketingConsentFuture;
      }
      final consent = await _apiService.getMarketingContactStatus();
      _analyticsStore
        ..setUserProperty(
          AnalyticsUserProperty.fromEnum(
            name: AnalyticsUserPropName.marketingConsent,
            value: consent.toString(),
          ),
        )
        ..logEvent(AnalyticsEvent.getMarketingContactSuccess);
      return consent;
    } catch (e) {
      _analyticsStore.logEvent(
        AnalyticsEvent.getMarketingContactError,
        parameters: {'error': e.toString()},
      );
      rethrow;
    }
  }

  @action
  Future<void> setPushNotificationsShown({required bool userAllowed}) async {
    await _pushNotificationsStore.setPushNotificationsShown(userAllowed: userAllowed);
    await evaluatePromptToShow();
  }

  @override
  FutureOr<void> dispose() async {
    _authReactionDisposer?.call();
  }
}
