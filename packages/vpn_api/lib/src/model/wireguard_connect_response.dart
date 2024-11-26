//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'wireguard_connect_response.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class WireguardConnectResponse {
  /// Returns a new [WireguardConnectResponse] instance.
  WireguardConnectResponse({
    required this.wgConfig,
    required this.hash,
    this.limitExceeded,
  });

  /// Wireguard connection configuration with a placeholder for %private_key%
  @JsonKey(
    name: r'wg_config',
    required: true,
    includeIfNull: false,
  )
  final String wgConfig;

  /// Hash representing provider id
  @JsonKey(
    name: r'hash',
    required: true,
    includeIfNull: false,
  )
  final String hash;

  @JsonKey(
    name: r'limit_exceeded',
    required: false,
    includeIfNull: false,
  )
  final bool? limitExceeded;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WireguardConnectResponse &&
          other.wgConfig == wgConfig &&
          other.hash == hash &&
          other.limitExceeded == limitExceeded;

  @override
  int get hashCode =>
      wgConfig.hashCode + hash.hashCode + (limitExceeded == null ? 0 : limitExceeded.hashCode);

  factory WireguardConnectResponse.fromJson(Map<String, dynamic> json) =>
      _$WireguardConnectResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WireguardConnectResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
