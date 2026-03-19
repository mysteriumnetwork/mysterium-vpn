// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapConfig _$MapConfigFromJson(Map<String, dynamic> json) => MapConfig(
  zoomLevels: (json['zoomLevels'] as List<dynamic>?)?.map((e) => e as num).toList() ?? const [4, 5],
  tileZoomLevels:
      (json['tileZoomLevels'] as List<dynamic>?)?.map((e) => e as num).toList() ?? const [3, 4],
  initialZoom: json['initialZoom'] as num? ?? 4,
  tileUrlTemplates: json['tileUrlTemplates'] == null
      ? const <Brightness, String>{}
      : _tileUrlTemplatesFromJson(json['tileUrlTemplates'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MapConfigToJson(MapConfig instance) => <String, dynamic>{
  'zoomLevels': instance.zoomLevels,
  'tileZoomLevels': instance.tileZoomLevels,
  'initialZoom': instance.initialZoom,
  'tileUrlTemplates': _tileUrlTemplatesToJson(instance.tileUrlTemplates),
};
