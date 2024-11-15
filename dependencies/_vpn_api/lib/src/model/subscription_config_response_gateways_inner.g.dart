// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_config_response_gateways_inner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionConfigResponseGatewaysInner _$SubscriptionConfigResponseGatewaysInnerFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'SubscriptionConfigResponseGatewaysInner',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['name', 'enabled'],
        );
        final val = SubscriptionConfigResponseGatewaysInner(
          name: $checkedConvert('name', (v) => v as String),
          enabled: $checkedConvert('enabled', (v) => v as bool),
        );
        return val;
      },
    );

Map<String, dynamic> _$SubscriptionConfigResponseGatewaysInnerToJson(
        SubscriptionConfigResponseGatewaysInner instance) =>
    <String, dynamic>{
      'name': instance.name,
      'enabled': instance.enabled,
    };
