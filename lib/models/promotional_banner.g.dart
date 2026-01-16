// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotional_banner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PromotionalBanner _$PromotionalBannerFromJson(Map<String, dynamic> json) => _PromotionalBanner(
      id: json['id'] as String,
      title: json['title'] as String,
      iconUrl: json['iconUrl'] as String?,
      localizedTitles: (json['localizedTitles'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      redirectUrl: json['redirectUrl'] as String?,
      startDate: json['startDate'] == null ? null : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null ? null : DateTime.parse(json['endDate'] as String),
    );

Map<String, dynamic> _$PromotionalBannerToJson(_PromotionalBanner instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'iconUrl': instance.iconUrl,
      'localizedTitles': instance.localizedTitles,
      'redirectUrl': instance.redirectUrl,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
    };
