import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/stores/marketing_analytics/marketing_analytics_store.dart';

part 'marketing_analytics_store_noop.g.dart';

// ignore: library_private_types_in_public_api
class MarketingAnalyticsStoreNoop = _MarketingAnalyticsStoreNoop with _$MarketingAnalyticsStoreNoop;

abstract class _MarketingAnalyticsStoreNoop extends MarketingAnalyticsStore with Store {
  @override
  @action
  Future<void> logEvent(
    MarketingAnalyticsEvent event, [
    Map<String, dynamic>? parameters,
  ]) async {}

  @override
  @action
  void setUserId(String id) {}

  @override
  @action
  Future<void> setSignUP() async {}

  @override
  @action
  Future<void> setStartTrial({
    required String planType,
    required String price,
  }) async {}

  @override
  @action
  Future<void> setSubscriptionCompleted({
    required String planType,
    required bool isNewSubscription,
    required String price,
    required String currency,
  }) async {}
}
