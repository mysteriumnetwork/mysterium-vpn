// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_config_response_plans_inner_prices_inner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionConfigResponsePlansInnerPricesInner
    _$SubscriptionConfigResponsePlansInnerPricesInnerFromJson(Map<String, dynamic> json) =>
        $checkedCreate(
          'SubscriptionConfigResponsePlansInnerPricesInner',
          json,
          ($checkedConvert) {
            $checkKeys(
              json,
              requiredKeys: const [
                'currency',
                'discount_amount',
                'discount_units',
                'discounted_full_price',
                'discounted_monthly_price',
                'full_price',
                'monthly_price'
              ],
            );
            final val = SubscriptionConfigResponsePlansInnerPricesInner(
              currency: $checkedConvert('currency', (v) => v as String),
              discountAmount: $checkedConvert('discount_amount', (v) => v as String),
              discountUnits: $checkedConvert('discount_units', (v) => v as String),
              discountedFullPrice: $checkedConvert('discounted_full_price', (v) => v as String),
              discountedMonthlyPrice:
                  $checkedConvert('discounted_monthly_price', (v) => v as String),
              fullPrice: $checkedConvert('full_price', (v) => v as String),
              monthlyPrice: $checkedConvert('monthly_price', (v) => v as String),
            );
            return val;
          },
          fieldKeyMap: const {
            'discountAmount': 'discount_amount',
            'discountUnits': 'discount_units',
            'discountedFullPrice': 'discounted_full_price',
            'discountedMonthlyPrice': 'discounted_monthly_price',
            'fullPrice': 'full_price',
            'monthlyPrice': 'monthly_price'
          },
        );

Map<String, dynamic> _$SubscriptionConfigResponsePlansInnerPricesInnerToJson(
        SubscriptionConfigResponsePlansInnerPricesInner instance) =>
    <String, dynamic>{
      'currency': instance.currency,
      'discount_amount': instance.discountAmount,
      'discount_units': instance.discountUnits,
      'discounted_full_price': instance.discountedFullPrice,
      'discounted_monthly_price': instance.discountedMonthlyPrice,
      'full_price': instance.fullPrice,
      'monthly_price': instance.monthlyPrice,
    };
