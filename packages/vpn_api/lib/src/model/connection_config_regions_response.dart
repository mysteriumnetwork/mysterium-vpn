//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:vpn_api/src/model/connection_region.dart';
import 'package:json_annotation/json_annotation.dart';

part 'connection_config_regions_response.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ConnectionConfigRegionsResponse {
  /// Returns a new [ConnectionConfigRegionsResponse] instance.
  ConnectionConfigRegionsResponse({
    required this.regions,
  });

  @JsonKey(
    name: r'regions',
    required: true,
    includeIfNull: false,
  )
  final List<ConnectionRegion> regions;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConnectionConfigRegionsResponse && other.regions == regions;

  @override
  int get hashCode => regions.hashCode;

  factory ConnectionConfigRegionsResponse.fromJson(Map<String, dynamic> json) =>
      _$ConnectionConfigRegionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ConnectionConfigRegionsResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
