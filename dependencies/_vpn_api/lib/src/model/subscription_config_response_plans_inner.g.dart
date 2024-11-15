// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_config_response_plans_inner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionConfigResponsePlansInner _$SubscriptionConfigResponsePlansInnerFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'SubscriptionConfigResponsePlansInner',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            'id',
            'apple_product_id',
            'google_product_id',
            'interval',
            'price',
            'supported_gateways'
          ],
        );
        final val = SubscriptionConfigResponsePlansInner(
          id: $checkedConvert('id', (v) => v as String),
          appleProductId: $checkedConvert('apple_product_id', (v) => v as String),
          googleProductId: $checkedConvert('google_product_id', (v) => v as String),
          interval: $checkedConvert(
              'interval',
              (v) =>
                  SubscriptionConfigResponsePlansInnerInterval.fromJson(v as Map<String, dynamic>)),
          price: $checkedConvert('price',
              (v) => SubscriptionConfigResponsePlansInnerPrice.fromJson(v as Map<String, dynamic>)),
          supportedGateways: $checkedConvert(
              'supported_gateways', (v) => (v as List<dynamic>).map((e) => e as String).toList()),
        );
        return val;
      },
      fieldKeyMap: const {
        'appleProductId': 'apple_product_id',
        'googleProductId': 'google_product_id',
        'supportedGateways': 'supported_gateways'
      },
    );

Map<String, dynamic> _$SubscriptionConfigResponsePlansInnerToJson(
        SubscriptionConfigResponsePlansInner instance) =>
    <String, dynamic>{
      'id': instance.id,
      'apple_product_id': instance.appleProductId,
      'google_product_id': instance.googleProductId,
      'interval': instance.interval.toJson(),
      'price': instance.price.toJson(),
      'supported_gateways': instance.supportedGateways,
    };
