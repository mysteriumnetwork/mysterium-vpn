import 'package:mysterium_vpn/common/enums/enums.dart';

abstract class MarketingAnalyticsStore {
  Future<void> logEvent(MarketingAnalyticsEvent event, [Map<String, dynamic>? parameters]);
  void setUserId(String id);
  Future<void> setSignUP();
  Future<void> setStartTrial({
    required String planType,
    required String price,
  });
  Future<void> setSubscriptionCompleted({
    required String planType,
    required bool isNewSubscription,
    required String price,
    required String currency,
  });
  Future<void> setLogin();
}
