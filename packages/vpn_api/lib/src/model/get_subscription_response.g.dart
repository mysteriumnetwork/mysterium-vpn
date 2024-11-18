// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_subscription_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetSubscriptionResponse _$GetSubscriptionResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'GetSubscriptionResponse',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['active', 'expired', 'recurring', 'subscription_id'],
        );
        final val = GetSubscriptionResponse(
          active: $checkedConvert('active', (v) => v as bool),
          periodStart: $checkedConvert(
              'period_start', (v) => v == null ? null : DateTime.parse(v as String)),
          activeUntil: $checkedConvert(
              'active_until', (v) => v == null ? null : DateTime.parse(v as String)),
          gateway: $checkedConvert('gateway', (v) => v as String?),
          planId: $checkedConvert('plan_id', (v) => v as String?),
          portalUrl: $checkedConvert('portal_url', (v) => v as String?),
          expired: $checkedConvert('expired', (v) => v as bool),
          recurring: $checkedConvert('recurring', (v) => v as bool),
          subscriptionId: $checkedConvert('subscription_id', (v) => v as String),
          orderCurrency: $checkedConvert('order_currency', (v) => v as String?),
          orderNetAmount: $checkedConvert('order_net_amount', (v) => v as String?),
          orderCouponUsed: $checkedConvert('order_coupon_used', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'periodStart': 'period_start',
        'activeUntil': 'active_until',
        'planId': 'plan_id',
        'portalUrl': 'portal_url',
        'subscriptionId': 'subscription_id',
        'orderCurrency': 'order_currency',
        'orderNetAmount': 'order_net_amount',
        'orderCouponUsed': 'order_coupon_used'
      },
    );

Map<String, dynamic> _$GetSubscriptionResponseToJson(GetSubscriptionResponse instance) {
  final val = <String, dynamic>{
    'active': instance.active,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('period_start', instance.periodStart?.toIso8601String());
  writeNotNull('active_until', instance.activeUntil?.toIso8601String());
  writeNotNull('gateway', instance.gateway);
  writeNotNull('plan_id', instance.planId);
  writeNotNull('portal_url', instance.portalUrl);
  val['expired'] = instance.expired;
  val['recurring'] = instance.recurring;
  val['subscription_id'] = instance.subscriptionId;
  writeNotNull('order_currency', instance.orderCurrency);
  writeNotNull('order_net_amount', instance.orderNetAmount);
  writeNotNull('order_coupon_used', instance.orderCouponUsed);
  return val;
}
