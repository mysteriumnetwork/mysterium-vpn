// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_config_response_plans_inner_interval.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionConfigResponsePlansInnerInterval _$SubscriptionConfigResponsePlansInnerIntervalFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'SubscriptionConfigResponsePlansInnerInterval',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['unit', 'amount'],
        );
        final val = SubscriptionConfigResponsePlansInnerInterval(
          unit: $checkedConvert('unit',
              (v) => $enumDecode(_$SubscriptionConfigResponsePlansInnerIntervalUnitEnumEnumMap, v)),
          amount: $checkedConvert('amount', (v) => v as num),
        );
        return val;
      },
    );

Map<String, dynamic> _$SubscriptionConfigResponsePlansInnerIntervalToJson(
        SubscriptionConfigResponsePlansInnerInterval instance) =>
    <String, dynamic>{
      'unit': _$SubscriptionConfigResponsePlansInnerIntervalUnitEnumEnumMap[instance.unit]!,
      'amount': instance.amount,
    };

const _$SubscriptionConfigResponsePlansInnerIntervalUnitEnumEnumMap = {
  SubscriptionConfigResponsePlansInnerIntervalUnitEnum.year: 'year',
  SubscriptionConfigResponsePlansInnerIntervalUnitEnum.month: 'month',
};
