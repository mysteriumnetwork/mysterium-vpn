import 'package:mysterium_vpn/models/models.dart';

typedef SubscriptionData = ({
  String gateway,
  String plan,
  String expirationDate,
  String duration,
  String recurring
});

extension SubscriptionExtensions on Subscription? {
  ({String gateway, String plan, String expirationDate, String duration, String recurring})
      toSubscriptionData() {
    final plan = this?.planId;
    final gateway = this?.gatewayName;
    final expirationDate = this?.activeUntil?.toIso8601String() ?? 'null';
    final duration = this?.durationInMonthsBasedOnPlanId ?? 'null';
    final recurring = this?.recurring?.toString() ?? 'null';
    if (plan != null && gateway != null) {
      return (
        gateway: gateway,
        plan: plan,
        expirationDate: expirationDate,
        duration: duration,
        recurring: recurring
      );
    }
    return (
      gateway: 'null',
      plan: 'null',
      expirationDate: 'null',
      duration: 'null',
      recurring: 'null'
    );
  }
}
