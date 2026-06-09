import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/analytics_event.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';

part 'subscription_onboarding_store.g.dart';

// ignore: library_private_types_in_public_api
class SubscriptionOnboardingStore = _SubscriptionOnboardingStore with _$SubscriptionOnboardingStore;

abstract class _SubscriptionOnboardingStore with Store {
  _SubscriptionOnboardingStore({
    required AnalyticsStore analyticsStore,
    required SubscriptionStore subscriptionStore,
    required LocalDBService localDBService,
  }) : _analyticsStore = analyticsStore,
       _subscriptionStore = subscriptionStore,
       _localDb = localDBService;

  final AnalyticsStore _analyticsStore;
  final SubscriptionStore _subscriptionStore;
  final LocalDBService _localDb;

  Future<bool> shouldShow() async {
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

  Future<void> markShown() => _localDb.setSubscriptionOnboardingShown();

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

  Map<String, dynamic>? _stepAnalyticsParams(int? index) =>
      index == null ? null : {'step': index + 1};
}
