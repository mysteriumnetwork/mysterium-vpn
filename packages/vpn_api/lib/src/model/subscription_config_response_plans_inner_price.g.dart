// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_config_response_plans_inner_price.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionConfigResponsePlansInnerPrice _$SubscriptionConfigResponsePlansInnerPriceFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'SubscriptionConfigResponsePlansInnerPrice',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['USD'],
        );
        final val = SubscriptionConfigResponsePlansInnerPrice(
          USD: $checkedConvert('USD', (v) => v as num),
        );
        return val;
      },
    );

Map<String, dynamic> _$SubscriptionConfigResponsePlansInnerPriceToJson(
        SubscriptionConfigResponsePlansInnerPrice instance) =>
    <String, dynamic>{
      'USD': instance.USD,
    };
