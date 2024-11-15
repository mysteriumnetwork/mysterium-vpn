//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:vpn_api/src/model/proxy_connect_response_proxy_config.dart';
import 'package:json_annotation/json_annotation.dart';

part 'proxy_connect_response.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ProxyConnectResponse {
  /// Returns a new [ProxyConnectResponse] instance.
  ProxyConnectResponse({
    required this.proxyConfig,
    this.limitExceeded,
  });

  @JsonKey(
    name: r'proxy_config',
    required: true,
    includeIfNull: false,
  )
  final ProxyConnectResponseProxyConfig proxyConfig;

  @JsonKey(
    name: r'limit_exceeded',
    required: false,
    includeIfNull: false,
  )
  final bool? limitExceeded;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProxyConnectResponse &&
          other.proxyConfig == proxyConfig &&
          other.limitExceeded == limitExceeded;

  @override
  int get hashCode => proxyConfig.hashCode + (limitExceeded == null ? 0 : limitExceeded.hashCode);

  factory ProxyConnectResponse.fromJson(Map<String, dynamic> json) =>
      _$ProxyConnectResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProxyConnectResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
