// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductOffer _$ProductOfferFromJson(Map<String, dynamic> json) => _ProductOffer(
      id: json['id'] as String,
      isIntroductory: json['isIntroductory'] as bool,
      price: (json['price'] as num).toDouble(),
      durationUnit: $enumDecode(_$OfferDurationEnumMap, json['durationUnit']),
      durationValue: (json['durationValue'] as num).toInt(),
    );

Map<String, dynamic> _$ProductOfferToJson(_ProductOffer instance) => <String, dynamic>{
      'id': instance.id,
      'isIntroductory': instance.isIntroductory,
      'price': instance.price,
      'durationUnit': _$OfferDurationEnumMap[instance.durationUnit]!,
      'durationValue': instance.durationValue,
    };

const _$OfferDurationEnumMap = {
  OfferDuration.day: 'day',
  OfferDuration.week: 'week',
  OfferDuration.month: 'month',
  OfferDuration.year: 'year',
};
