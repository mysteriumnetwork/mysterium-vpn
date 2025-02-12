// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_generic_subscription_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateGenericSubscriptionResponse _$CreateGenericSubscriptionResponseFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'CreateGenericSubscriptionResponse',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['gateway_id'],
        );
        final val = CreateGenericSubscriptionResponse(
          gatewayId: $checkedConvert('gateway_id', (v) => v as String),
          checkoutUrl: $checkedConvert('checkout_url', (v) => v as String?),
          clientSecret: $checkedConvert('client_secret', (v) => v as String?),
          invoicePaid: $checkedConvert('invoice_paid', (v) => v as bool?),
          subscriptionId: $checkedConvert('subscription_id', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'gatewayId': 'gateway_id',
        'checkoutUrl': 'checkout_url',
        'clientSecret': 'client_secret',
        'invoicePaid': 'invoice_paid',
        'subscriptionId': 'subscription_id'
      },
    );

Map<String, dynamic> _$CreateGenericSubscriptionResponseToJson(
    CreateGenericSubscriptionResponse instance) {
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
  return val;
}
