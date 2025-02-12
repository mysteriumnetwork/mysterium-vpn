// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_adyen_subscription_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateAdyenSubscriptionResponse _$CreateAdyenSubscriptionResponseFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'CreateAdyenSubscriptionResponse',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['gateway_id', 'subscription_id'],
        );
        final val = CreateAdyenSubscriptionResponse(
          gatewayId: $checkedConvert('gateway_id', (v) => v as String),
          subscriptionId: $checkedConvert('subscription_id', (v) => v as String),
          paymentData: $checkedConvert('payment_data', (v) => v),
        );
        return val;
      },
      fieldKeyMap: const {
        'gatewayId': 'gateway_id',
        'subscriptionId': 'subscription_id',
        'paymentData': 'payment_data'
      },
    );

Map<String, dynamic> _$CreateAdyenSubscriptionResponseToJson(
    CreateAdyenSubscriptionResponse instance) {
  final val = <String, dynamic>{
    'gateway_id': instance.gatewayId,
    'subscription_id': instance.subscriptionId,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('payment_data', instance.paymentData);
  return val;
}
