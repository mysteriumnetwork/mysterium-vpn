// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_config_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionConfigResponse _$SubscriptionConfigResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'SubscriptionConfigResponse',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            'gateways',
            'plans',
            'countries',
            'stripe_return_url',
            'stripe_publishable_key'
          ],
        );
        final val = SubscriptionConfigResponse(
          gateways: $checkedConvert(
              'gateways',
              (v) => (v as List<dynamic>)
                  .map((e) =>
                      SubscriptionConfigResponseGatewaysInner.fromJson(e as Map<String, dynamic>))
                  .toList()),
          plans: $checkedConvert(
              'plans',
              (v) => (v as List<dynamic>)
                  .map((e) =>
                      SubscriptionConfigResponsePlansInner.fromJson(e as Map<String, dynamic>))
                  .toList()),
          countries: $checkedConvert(
              'countries',
              (v) => (v as List<dynamic>)
                  .map((e) => Country.fromJson(e as Map<String, dynamic>))
                  .toList()),
          stripeReturnUrl: $checkedConvert('stripe_return_url', (v) => v as String),
          stripePublishableKey: $checkedConvert('stripe_publishable_key', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'stripeReturnUrl': 'stripe_return_url',
        'stripePublishableKey': 'stripe_publishable_key'
      },
    );

Map<String, dynamic> _$SubscriptionConfigResponseToJson(SubscriptionConfigResponse instance) =>
    <String, dynamic>{
      'gateways': instance.gateways.map((e) => e.toJson()).toList(),
      'plans': instance.plans.map((e) => e.toJson()).toList(),
      'countries': instance.countries.map((e) => e.toJson()).toList(),
      'stripe_return_url': instance.stripeReturnUrl,
      'stripe_publishable_key': instance.stripePublishableKey,
    };
