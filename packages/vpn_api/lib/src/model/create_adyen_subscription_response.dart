//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'create_adyen_subscription_response.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateAdyenSubscriptionResponse {
  /// Returns a new [CreateAdyenSubscriptionResponse] instance.
  CreateAdyenSubscriptionResponse({
    required this.gatewayId,
    required this.subscriptionId,
    this.paymentData,
  });

  @JsonKey(
    name: r'gateway_id',
    required: true,
    includeIfNull: false,
  )
  final String gatewayId;

  @JsonKey(
    name: r'subscription_id',
    required: true,
    includeIfNull: false,
  )
  final String subscriptionId;

  @JsonKey(
    name: r'payment_data',
    required: false,
    includeIfNull: false,
  )
  final Object? paymentData;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateAdyenSubscriptionResponse &&
          other.gatewayId == gatewayId &&
          other.subscriptionId == subscriptionId &&
          other.paymentData == paymentData;

  @override
  int get hashCode =>
      gatewayId.hashCode +
      subscriptionId.hashCode +
      (paymentData == null ? 0 : paymentData.hashCode);

  factory CreateAdyenSubscriptionResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateAdyenSubscriptionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateAdyenSubscriptionResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
