import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_config.freezed.dart';
part 'map_config.g.dart';

@freezed
@JsonSerializable()
class MapConfig with _$MapConfig {
  const MapConfig({
    this.zoomLevels = const [4, 5],
    this.tileZoomLevels = const [3, 4],
    this.initialZoom = 4,
    this.tileUrlTemplates = const <String, String>{},
  });

  factory MapConfig.fromJson(Map<String, dynamic> json) => _$MapConfigFromJson(json);

  @override
  final List<num> zoomLevels;
  @override
  final List<num> tileZoomLevels;
  @override
  final num initialZoom;
  @override
  final Map<String, String> tileUrlTemplates;

  Map<String, dynamic> toJson() => _$MapConfigToJson(this);
}
