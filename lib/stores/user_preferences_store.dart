import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';

part 'user_preferences_store.g.dart';

enum UserPromptType { none, noneSubsOnboarding, marketingConsent, pushNotifications }

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
    required SubscriptionStore subscriptionStore,
    required RemoteConfigStore remoteConfigStore,
  }) : _apiService = apiService,
       _analyticsStore = analyticsStore,
       _realIPInfo = realIPInfo,
       localDb = localDBService,
       _pushNotificationsStore = pushNotificationsStore,
       _authSessionStore = authSessionStore,
       _subscriptionStore = subscriptionStore,
       _remoteConfigStore = remoteConfigStore {
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
  final SubscriptionStore _subscriptionStore;
  final RemoteConfigStore _remoteConfigStore;
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
  bool noneSubsOnboardingPromptShown = false;

  // Set true once any prompt is shown in the current app run. We allow at most
  // one prompt per launch — subsequent evaluations are short-circuited until
  // the app is restarted.
  @visibleForTesting
  bool anyPromptShownThisSession = false;

  @visibleForTesting
  bool testIsMobile = false; // default false, will override in tests

  bool get supportsPushNotifications => testIsMobile || isMobile();

  @action
  bool isPromptShown(UserPromptType type) {
    switch (type) {
      case UserPromptType.noneSubsOnboarding:
        return noneSubsOnboardingPromptShown;
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
      case UserPromptType.noneSubsOnboarding:
        noneSubsOnboardingPromptShown = true;
      case UserPromptType.marketingConsent:
        marketingConsentPromptShown = true;
      case UserPromptType.pushNotifications:
        pushNotificationsPromptShown = true;
      case UserPromptType.none:
        return;
    }
    anyPromptShownThisSession = true;
  }

  @visibleForTesting
  @action
  Future<void> evaluatePromptToShow() async {
    // Cap to one prompt per app launch — chaining onboarding, marketing
    // consent, and push permission back-to-back would be a jarring first
    // impression. Restart the app to surface the next eligible prompt.
    if (anyPromptShownThisSession) {
      nextPromptToShow = UserPromptType.none;
      return;
    }
    // Priority order — onboarding takes precedence so first-time
    // non-subscribers see the value proposition before any consent /
    // permission ask. Each check runs only after the previous one has been
    // ruled out so a slow / failing downstream call (marketing consent API,
    // push permission probe) can't delay or block onboarding.
    if (await shouldShowNoneSubsOnboarding()) {
      nextPromptToShow = UserPromptType.noneSubsOnboarding;
      return;
    }
    if (await shouldShowMarketingConsent()) {
      nextPromptToShow = UserPromptType.marketingConsent;
      return;
    }
    if (await _pushNotificationsStore.shouldShowPushNotificationsPermissionPrompt()) {
      nextPromptToShow = UserPromptType.pushNotifications;
      return;
    }
    nextPromptToShow = UserPromptType.none;
  }

  @visibleForTesting
  @action
  Future<bool> shouldShowNoneSubsOnboarding() async {
    if (!_remoteConfigStore.canShowNoSubsOnboardingFlow) {
      return false;
    }
    final alreadyCompleted = await localDb.getNoneSubsOnboardingCompleted();
    if (alreadyCompleted) {
      return false;
    }
    try {
      final subscription = await _subscriptionStore.subscriptionFuture;
      return !subscription.active;
    } catch (_) {
      // Subscription fetch failed (offline, API error, etc.) — skip the
      // onboarding rather than risk flashing it at a paying user. It will
      // be re-evaluated on the next launch.
      return false;
    }
  }

  @action
  Future<void> setNoneSubsOnboardingCompleted() async {
    await localDb.setNoneSubsOnboardingCompleted();
    await evaluatePromptToShow();
  }

  /// Returns the step the user was last on inside the onboarding dialog
  /// (default 0 when onboarding has never been opened). Used to resume from
  /// the same step after an interrupted run.
  @action
  Future<int> getNoneSubsOnboardingStep() async => localDb.getNoneSubsOnboardingStep();

  @action
  Future<void> setNoneSubsOnboardingStep(int step) async => localDb.setNoneSubsOnboardingStep(step);

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
