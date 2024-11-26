// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_google_subscription_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateGoogleSubscriptionResponse _$CreateGoogleSubscriptionResponseFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'CreateGoogleSubscriptionResponse',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            'gateway_id',
            'subscription_base_plan_id',
            'subscription_product_id'
          ],
        );
        final val = CreateGoogleSubscriptionResponse(
          gatewayId: $checkedConvert('gateway_id', (v) => v as String),
          subscriptionBasePlanId: $checkedConvert('subscription_base_plan_id', (v) => v as String),
          subscriptionProductId: $checkedConvert('subscription_product_id', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'gatewayId': 'gateway_id',
        'subscriptionBasePlanId': 'subscription_base_plan_id',
        'subscriptionProductId': 'subscription_product_id'
      },
    );

Map<String, dynamic> _$CreateGoogleSubscriptionResponseToJson(
        CreateGoogleSubscriptionResponse instance) =>
    <String, dynamic>{
      'gateway_id': instance.gatewayId,
      'subscription_base_plan_id': instance.subscriptionBasePlanId,
      'subscription_product_id': instance.subscriptionProductId,
    };
