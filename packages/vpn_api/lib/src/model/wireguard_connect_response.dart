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
    required this.id,
    required this.wgConfig,
    required this.hash,
    this.exitIp,
    this.limitExceeded,
  });

  /// Unique identifier of prepared connection
  @JsonKey(
    name: r'id',
    required: true,
    includeIfNull: false,
  )
  final String id;

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

  /// Exit IP of provider
  @JsonKey(
    name: r'exit_ip',
    required: false,
    includeIfNull: false,
  )
  final String? exitIp;

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
          other.id == id &&
          other.wgConfig == wgConfig &&
          other.hash == hash &&
          other.exitIp == exitIp &&
          other.limitExceeded == limitExceeded;

  @override
  int get hashCode =>
      id.hashCode +
      wgConfig.hashCode +
      hash.hashCode +
      (exitIp == null ? 0 : exitIp.hashCode) +
      (limitExceeded == null ? 0 : limitExceeded.hashCode);

  factory WireguardConnectResponse.fromJson(Map<String, dynamic> json) =>
      _$WireguardConnectResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WireguardConnectResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
