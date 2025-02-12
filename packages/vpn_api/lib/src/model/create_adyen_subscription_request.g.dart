// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_adyen_subscription_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateAdyenSubscriptionRequest _$CreateAdyenSubscriptionRequestFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'CreateAdyenSubscriptionRequest',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['plan_id', 'country', 'currency', 'amount', 'origin', 'gateway_id'],
        );
        final val = CreateAdyenSubscriptionRequest(
          planId: $checkedConvert('plan_id', (v) => v as String),
          country: $checkedConvert('country', (v) => v as String),
          state: $checkedConvert('state', (v) => v as String?),
          currency: $checkedConvert('currency', (v) => v as String),
          zipCode: $checkedConvert('zip_code', (v) => v as String?),
          couponCode: $checkedConvert('coupon_code', (v) => v as String?),
          embedded: $checkedConvert('embedded', (v) => v as bool?),
          cardHolder: $checkedConvert('card_holder', (v) => v as String?),
          amount: $checkedConvert('amount', (v) => v as num),
          origin: $checkedConvert('origin', (v) => v as String),
          gatewayId: $checkedConvert('gateway_id',
              (v) => $enumDecode(_$CreateAdyenSubscriptionRequestGatewayIdEnumEnumMap, v)),
          paymentData: $checkedConvert('payment_data', (v) => v),
        );
        return val;
      },
      fieldKeyMap: const {
        'planId': 'plan_id',
        'zipCode': 'zip_code',
        'couponCode': 'coupon_code',
        'cardHolder': 'card_holder',
        'gatewayId': 'gateway_id',
        'paymentData': 'payment_data'
      },
    );

Map<String, dynamic> _$CreateAdyenSubscriptionRequestToJson(
    CreateAdyenSubscriptionRequest instance) {
  final val = <String, dynamic>{
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
  val['amount'] = instance.amount;
  val['origin'] = instance.origin;
  val['gateway_id'] = _$CreateAdyenSubscriptionRequestGatewayIdEnumEnumMap[instance.gatewayId]!;
  writeNotNull('payment_data', instance.paymentData);
  return val;
}

const _$CreateAdyenSubscriptionRequestGatewayIdEnumEnumMap = {
  CreateAdyenSubscriptionRequestGatewayIdEnum.adyen: 'adyen',
};
