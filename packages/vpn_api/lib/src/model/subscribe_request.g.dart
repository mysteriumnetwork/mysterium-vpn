// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscribe_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscribeRequest _$SubscribeRequestFromJson(Map<String, dynamic> json) => $checkedCreate(
      'SubscribeRequest',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['gateway_id', 'plan_id', 'country', 'currency'],
        );
        final val = SubscribeRequest(
          gatewayId: $checkedConvert(
              'gateway_id', (v) => $enumDecode(_$SubscribeRequestGatewayIdEnumEnumMap, v)),
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

Map<String, dynamic> _$SubscribeRequestToJson(SubscribeRequest instance) {
  final val = <String, dynamic>{
    'gateway_id': _$SubscribeRequestGatewayIdEnumEnumMap[instance.gatewayId]!,
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

const _$SubscribeRequestGatewayIdEnumEnumMap = {
  SubscribeRequestGatewayIdEnum.apple: 'apple',
};
