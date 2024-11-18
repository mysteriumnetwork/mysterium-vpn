// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_google_subscription_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateGoogleSubscriptionRequest _$CreateGoogleSubscriptionRequestFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'CreateGoogleSubscriptionRequest',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['gateway_id', 'plan_id'],
        );
        final val = CreateGoogleSubscriptionRequest(
          gatewayId: $checkedConvert('gateway_id',
              (v) => $enumDecode(_$CreateGoogleSubscriptionRequestGatewayIdEnumEnumMap, v)),
          planId: $checkedConvert('plan_id', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'gatewayId': 'gateway_id', 'planId': 'plan_id'},
    );

Map<String, dynamic> _$CreateGoogleSubscriptionRequestToJson(
        CreateGoogleSubscriptionRequest instance) =>
    <String, dynamic>{
      'gateway_id': _$CreateGoogleSubscriptionRequestGatewayIdEnumEnumMap[instance.gatewayId]!,
      'plan_id': instance.planId,
    };

const _$CreateGoogleSubscriptionRequestGatewayIdEnumEnumMap = {
  CreateGoogleSubscriptionRequestGatewayIdEnum.google: 'google',
};
