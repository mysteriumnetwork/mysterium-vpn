import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mysterium_vpn/models/models.dart';

part 'map_config.freezed.dart';
part 'map_config.g.dart';

@freezed
@JsonSerializable()
class MapConfig with _$MapConfig {
  const MapConfig({
    this.zoomLevels = const [4, 5],
    this.tileZoomLevels = const [3, 4],
    this.initialZoom = 4,
    this.tileUrlTemplates = const <Brightness, String>{},
  });

  factory MapConfig.fromJson(Map<String, dynamic> json) => _$MapConfigFromJson(json);

  @override
  final List<num> zoomLevels;
  @override
  final List<num> tileZoomLevels;
  @override
  final num initialZoom;
  @override
  @JsonKey(fromJson: _tileUrlTemplatesFromJson, toJson: _tileUrlTemplatesToJson)
  final Map<Brightness, String> tileUrlTemplates;

  Map<String, dynamic> toJson() => _$MapConfigToJson(this);
}

Map<Brightness, String> _tileUrlTemplatesFromJson(Map<String, dynamic> json) => json.map(
      (key, value) => MapEntry(const BrightnessConverter().fromJson(key), value.toString()),
    );

Map<String, dynamic> _tileUrlTemplatesToJson(Map<Brightness, String> object) => object.map(
      (key, value) => MapEntry(const BrightnessConverter().toJson(key), value),
    );
