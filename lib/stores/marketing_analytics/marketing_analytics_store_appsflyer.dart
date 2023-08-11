import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/stores/marketing_analytics/marketing_analytics_store.dart';

part 'marketing_analytics_store_appsflyer.g.dart';

// ignore: library_private_types_in_public_api
class MarketingAnalyticsStoreAppsflyer = _MarketingAnalyticsStoreAppsflyer
    with _$MarketingAnalyticsStoreAppsflyer;

abstract class _MarketingAnalyticsStoreAppsflyer extends MarketingAnalyticsStore with Store {
  _MarketingAnalyticsStoreAppsflyer({
    required AppsflyerSdk appsflyer,
  }) : _appsflyer = appsflyer;
  final AppsflyerSdk _appsflyer;
  @override
  @action
  Future<void> logEvent(
    MarketingAnalyticsEvent event, [
    Map<String, dynamic>? parameters,
  ]) async {
    _appsflyer.logEvent(event.toSnakeCase, parameters);
  }

  @override
  @action
  void setUserId(String id) {
    _appsflyer.setCustomerUserId(id);
  }

  @override
  @action
  Future<void> setLogin() async {
    logEvent(MarketingAnalyticsEvent.afLogin);
  }

  @override
  @action
  Future<void> setSignUP() async {
    logEvent(MarketingAnalyticsEvent.afCompleteRegistration);
  }

  @override
  @action
  Future<void> setStartTrial({
    required String planType,
    required String price,
  }) async {
    logEvent(MarketingAnalyticsEvent.afStartTrial, {
      'trial_plan': planType,
      'af_achievement_id': price,
    });
  }

  @override
  @action
  Future<void> setSubscriptionCompleted({
    required String planType,
    required bool isNewSubscription,
    required String price,
    required String currency,
  }) async {
    logEvent(
      MarketingAnalyticsEvent.afSubscribe,
      {
        'new_subscription': isNewSubscription,
        'af_content_list': planType,
        'af_revenue': price,
        'af_currency': currency,
      },
    );
  }
}
