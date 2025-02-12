// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscribe200_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subscribe200Response _$Subscribe200ResponseFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Subscribe200Response',
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
        final val = Subscribe200Response(
          gatewayId: $checkedConvert('gateway_id', (v) => v as String),
          checkoutUrl: $checkedConvert('checkout_url', (v) => v as String?),
          clientSecret: $checkedConvert('client_secret', (v) => v as String?),
          invoicePaid: $checkedConvert('invoice_paid', (v) => v as bool?),
          subscriptionId: $checkedConvert('subscription_id', (v) => v as String?),
          subscriptionBasePlanId: $checkedConvert('subscription_base_plan_id', (v) => v as String),
          subscriptionProductId: $checkedConvert('subscription_product_id', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'gatewayId': 'gateway_id',
        'checkoutUrl': 'checkout_url',
        'clientSecret': 'client_secret',
        'invoicePaid': 'invoice_paid',
        'subscriptionId': 'subscription_id',
        'subscriptionBasePlanId': 'subscription_base_plan_id',
        'subscriptionProductId': 'subscription_product_id'
      },
    );

Map<String, dynamic> _$Subscribe200ResponseToJson(Subscribe200Response instance) {
  final val = <String, dynamic>{
    'gateway_id': instance.gatewayId,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('checkout_url', instance.checkoutUrl);
  writeNotNull('client_secret', instance.clientSecret);
  writeNotNull('invoice_paid', instance.invoicePaid);
  writeNotNull('subscription_id', instance.subscriptionId);
  val['subscription_base_plan_id'] = instance.subscriptionBasePlanId;
  val['subscription_product_id'] = instance.subscriptionProductId;
  return val;
}
