// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_summary_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderSummaryRequest _$OrderSummaryRequestFromJson(Map<String, dynamic> json) => $checkedCreate(
      'OrderSummaryRequest',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['country', 'plan_id'],
        );
        final val = OrderSummaryRequest(
          country: $checkedConvert('country', (v) => v as String),
          state: $checkedConvert('state', (v) => v as String?),
          planId: $checkedConvert('plan_id', (v) => v as String),
          couponCode: $checkedConvert('coupon_code', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {'planId': 'plan_id', 'couponCode': 'coupon_code'},
    );

Map<String, dynamic> _$OrderSummaryRequestToJson(OrderSummaryRequest instance) {
  final val = <String, dynamic>{
    'country': instance.country,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('state', instance.state);
  val['plan_id'] = instance.planId;
  writeNotNull('coupon_code', instance.couponCode);
  return val;
}
