import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/analytics_event.dart';
import 'package:mysterium_vpn/common/enums/subscription_onboarding_step.dart';
import 'package:mysterium_vpn/common/extensions/string.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/remote_config/remote_config_store.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';

part 'subscription_onboarding_store.g.dart';

// ignore: library_private_types_in_public_api
class SubscriptionOnboardingStore = _SubscriptionOnboardingStore with _$SubscriptionOnboardingStore;

abstract class _SubscriptionOnboardingStore with Store {
  _SubscriptionOnboardingStore({
    required AnalyticsStore analyticsStore,
    required SubscriptionStore subscriptionStore,
    required LocalDBService localDBService,
    required RemoteConfigStore remoteConfigStore,
  }) : _analyticsStore = analyticsStore,
       _subscriptionStore = subscriptionStore,
       _remoteConfigStore = remoteConfigStore,
       _localDb = localDBService;

  final AnalyticsStore _analyticsStore;
  final SubscriptionStore _subscriptionStore;
  final LocalDBService _localDb;
  final RemoteConfigStore _remoteConfigStore;

  @observable
  bool _startTour = false;

  @computed
  bool get startTour => _startTour;

  @action
  void showSubscriptionOnboarding() => _startTour = true;

  Future<bool> shouldShow() async {
    if (!_remoteConfigStore.canShowSubscriptionOnboardingFlow) {
      return false;
    }

    if (await _localDb.getSubscriptionOnboardingShown()) {
      return false;
    }

    try {
      final subscription = await _subscriptionStore.subscriptionFuture;
      return subscription.active;
    } catch (_) {
      return false;
    }
  }

  @action
  Future<void> markShown() async {
    await _localDb.setSubscriptionOnboardingShown();
    _startTour = false;
  }

  Future<void> clearShown() => _localDb.resetSubscriptionOnboardingShown();

  void trackSkipped() =>
      _analyticsStore.logEvent(AnalyticsEvent.onboardingSubscribedSkipped).ignore();

  void trackStarted() =>
      _analyticsStore.logEvent(AnalyticsEvent.onboardingSubscribedStarted).ignore();

  void trackStepViewed(int? index) => _analyticsStore
      .logEvent(
        AnalyticsEvent.onboardingSubscribedStepViewed,
        parameters: _stepAnalyticsParams(index),
      )
      .ignore();

  void trackStepCompleted(int? index) => _analyticsStore
      .logEvent(
        AnalyticsEvent.onboardingSubscribedStepCompleted,
        parameters: _stepAnalyticsParams(index),
      )
      .ignore();

  void trackFinished() =>
      _analyticsStore.logEvent(AnalyticsEvent.onboardingSubscribedFinished).ignore();

  Map<String, dynamic>? _stepAnalyticsParams(int? index) {
    if (index == null) {
      return null;
    }

    final step = SubscriptionOnboardingStep.fromPlatformIndex(index);
    return {
      'step': index + 1,
      if (step != null) 'step_name': step.name.toSnakeCase,
    };
  }
}
