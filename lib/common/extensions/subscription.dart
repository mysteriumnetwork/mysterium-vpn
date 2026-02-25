import 'package:mysterium_vpn/models/models.dart';

typedef SubscriptionData = ({
  String gateway,
  String plan,
  String expirationDate,
  String duration,
  String recurring,
  String startDate,
  String active,
  String expired,
});

extension SubscriptionExtensions on Subscription? {
  ({
    String gateway,
    String plan,
    String expirationDate,
    String duration,
    String recurring,
    String startDate,
    String active,
    String expired
  }) toSubscriptionData() {
    if (this?.planId != null && this?.gatewayName != null) {
      return (
        gateway: this!.gatewayName,
        plan: this!.planId!,
        expirationDate: this!.activeUntil?.toIso8601String() ?? 'null',
        duration: this!.durationInMonthsBasedOnPlanId ?? 'null',
        recurring: this!.recurring?.toString() ?? 'null',
        startDate: this!.periodStart?.toIso8601String() ?? 'null',
        active: this!.active.toString(),
        expired: this!.expired.toString(),
      );
    }
    return (
      gateway: 'null',
      plan: 'null',
      expirationDate: 'null',
      duration: 'null',
      recurring: 'null',
      startDate: 'null',
      active: 'null',
      expired: 'null',
    );
  }
}
