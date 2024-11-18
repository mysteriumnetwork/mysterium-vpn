//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'subscription_config_response_gateways_inner.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SubscriptionConfigResponseGatewaysInner {
  /// Returns a new [SubscriptionConfigResponseGatewaysInner] instance.
  SubscriptionConfigResponseGatewaysInner({
    required this.name,
    required this.enabled,
  });

  @JsonKey(
    name: r'name',
    required: true,
    includeIfNull: false,
  )
  final String name;

  @JsonKey(
    name: r'enabled',
    required: true,
    includeIfNull: false,
  )
  final bool enabled;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionConfigResponseGatewaysInner &&
          other.name == name &&
          other.enabled == enabled;

  @override
  int get hashCode => name.hashCode + enabled.hashCode;

  factory SubscriptionConfigResponseGatewaysInner.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionConfigResponseGatewaysInnerFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionConfigResponseGatewaysInnerToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
