//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'create_apple_subscription_response.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateAppleSubscriptionResponse {
  /// Returns a new [CreateAppleSubscriptionResponse] instance.
  CreateAppleSubscriptionResponse({
    required this.gatewayId,
    required this.subscriptionProductId,
  });

  @JsonKey(
    name: r'gateway_id',
    required: true,
    includeIfNull: false,
  )
  final String gatewayId;

  @JsonKey(
    name: r'subscription_product_id',
    required: true,
    includeIfNull: false,
  )
  final String subscriptionProductId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateAppleSubscriptionResponse &&
          other.gatewayId == gatewayId &&
          other.subscriptionProductId == subscriptionProductId;

  @override
  int get hashCode => gatewayId.hashCode + subscriptionProductId.hashCode;

  factory CreateAppleSubscriptionResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateAppleSubscriptionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateAppleSubscriptionResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
