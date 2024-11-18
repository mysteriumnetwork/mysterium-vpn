//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'create_google_subscription_response.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateGoogleSubscriptionResponse {
  /// Returns a new [CreateGoogleSubscriptionResponse] instance.
  CreateGoogleSubscriptionResponse({
    required this.gatewayId,
    required this.subscriptionBasePlanId,
    required this.subscriptionProductId,
  });

  @JsonKey(
    name: r'gateway_id',
    required: true,
    includeIfNull: false,
  )
  final String gatewayId;

  @JsonKey(
    name: r'subscription_base_plan_id',
    required: true,
    includeIfNull: false,
  )
  final String subscriptionBasePlanId;

  @JsonKey(
    name: r'subscription_product_id',
    required: true,
    includeIfNull: false,
  )
  final String subscriptionProductId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateGoogleSubscriptionResponse &&
          other.gatewayId == gatewayId &&
          other.subscriptionBasePlanId == subscriptionBasePlanId &&
          other.subscriptionProductId == subscriptionProductId;

  @override
  int get hashCode =>
      gatewayId.hashCode + subscriptionBasePlanId.hashCode + subscriptionProductId.hashCode;

  factory CreateGoogleSubscriptionResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateGoogleSubscriptionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateGoogleSubscriptionResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
