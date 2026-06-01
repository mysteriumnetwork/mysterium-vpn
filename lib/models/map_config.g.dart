// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapConfig _$MapConfigFromJson(Map<String, dynamic> json) => MapConfig(
  zoomLevels:
      (json['zoomLevels'] as List<dynamic>?)?.map((e) => e as num).toList() ??
      const [4, 5],
  tileZoomLevels:
      (json['tileZoomLevels'] as List<dynamic>?)
          ?.map((e) => e as num)
          .toList() ??
      const [3, 4],
  initialZoom: json['initialZoom'] as num? ?? 4,
  tileUrlTemplates:
      (json['tileUrlTemplates'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const <String, String>{},
);

Map<String, dynamic> _$MapConfigToJson(MapConfig instance) => <String, dynamic>{
  'zoomLevels': instance.zoomLevels,
  'tileZoomLevels': instance.tileZoomLevels,
  'initialZoom': instance.initialZoom,
  'tileUrlTemplates': instance.tileUrlTemplates,
};
