// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_generic_subscription_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateGenericSubscriptionRequest _$CreateGenericSubscriptionRequestFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'CreateGenericSubscriptionRequest',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['gateway_id', 'plan_id', 'country', 'currency'],
        );
        final val = CreateGenericSubscriptionRequest(
          gatewayId: $checkedConvert('gateway_id', (v) => v as String),
          planId: $checkedConvert('plan_id', (v) => v as String),
          country: $checkedConvert('country', (v) => v as String),
          state: $checkedConvert('state', (v) => v as String?),
          currency: $checkedConvert('currency', (v) => v as String),
          zipCode: $checkedConvert('zip_code', (v) => v as String?),
          couponCode: $checkedConvert('coupon_code', (v) => v as String?),
          embedded: $checkedConvert('embedded', (v) => v as bool?),
          cardHolder: $checkedConvert('card_holder', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'gatewayId': 'gateway_id',
        'planId': 'plan_id',
        'zipCode': 'zip_code',
        'couponCode': 'coupon_code',
        'cardHolder': 'card_holder'
      },
    );

Map<String, dynamic> _$CreateGenericSubscriptionRequestToJson(
    CreateGenericSubscriptionRequest instance) {
  final val = <String, dynamic>{
    'gateway_id': instance.gatewayId,
    'plan_id': instance.planId,
    'country': instance.country,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('state', instance.state);
  val['currency'] = instance.currency;
  writeNotNull('zip_code', instance.zipCode);
  writeNotNull('coupon_code', instance.couponCode);
  writeNotNull('embedded', instance.embedded);
  writeNotNull('card_holder', instance.cardHolder);
  return val;
}
