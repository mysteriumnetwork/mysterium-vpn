// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_apple_subscription_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateAppleSubscriptionResponse _$CreateAppleSubscriptionResponseFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'CreateAppleSubscriptionResponse',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['gateway_id', 'subscription_product_id'],
        );
        final val = CreateAppleSubscriptionResponse(
          gatewayId: $checkedConvert('gateway_id', (v) => v as String),
          subscriptionProductId: $checkedConvert('subscription_product_id', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'gatewayId': 'gateway_id',
        'subscriptionProductId': 'subscription_product_id'
      },
    );

Map<String, dynamic> _$CreateAppleSubscriptionResponseToJson(
        CreateAppleSubscriptionResponse instance) =>
    <String, dynamic>{
      'gateway_id': instance.gatewayId,
      'subscription_product_id': instance.subscriptionProductId,
    };
