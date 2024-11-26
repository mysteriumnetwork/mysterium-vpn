// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_apple_subscription_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateAppleSubscriptionRequest _$CreateAppleSubscriptionRequestFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'CreateAppleSubscriptionRequest',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['gateway_id', 'plan_id'],
        );
        final val = CreateAppleSubscriptionRequest(
          gatewayId: $checkedConvert('gateway_id',
              (v) => $enumDecode(_$CreateAppleSubscriptionRequestGatewayIdEnumEnumMap, v)),
          planId: $checkedConvert('plan_id', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'gatewayId': 'gateway_id', 'planId': 'plan_id'},
    );

Map<String, dynamic> _$CreateAppleSubscriptionRequestToJson(
        CreateAppleSubscriptionRequest instance) =>
    <String, dynamic>{
      'gateway_id': _$CreateAppleSubscriptionRequestGatewayIdEnumEnumMap[instance.gatewayId]!,
      'plan_id': instance.planId,
    };

const _$CreateAppleSubscriptionRequestGatewayIdEnumEnumMap = {
  CreateAppleSubscriptionRequestGatewayIdEnum.apple: 'apple',
};
