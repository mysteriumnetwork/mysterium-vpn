//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'create_generic_subscription_response.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateGenericSubscriptionResponse {
  /// Returns a new [CreateGenericSubscriptionResponse] instance.
  CreateGenericSubscriptionResponse({
    required this.gatewayId,
    this.checkoutUrl,
    this.clientSecret,
    this.invoicePaid,
    this.subscriptionId,
  });

  @JsonKey(
    name: r'gateway_id',
    required: true,
    includeIfNull: false,
  )
  final String gatewayId;

  @JsonKey(
    name: r'checkout_url',
    required: false,
    includeIfNull: false,
  )
  final String? checkoutUrl;

  @JsonKey(
    name: r'client_secret',
    required: false,
    includeIfNull: false,
  )
  final String? clientSecret;

  @JsonKey(
    name: r'invoice_paid',
    required: false,
    includeIfNull: false,
  )
  final bool? invoicePaid;

  @JsonKey(
    name: r'subscription_id',
    required: false,
    includeIfNull: false,
  )
  final String? subscriptionId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateGenericSubscriptionResponse &&
          other.gatewayId == gatewayId &&
          other.checkoutUrl == checkoutUrl &&
          other.clientSecret == clientSecret &&
          other.invoicePaid == invoicePaid &&
          other.subscriptionId == subscriptionId;

  @override
  int get hashCode =>
      gatewayId.hashCode +
      (checkoutUrl == null ? 0 : checkoutUrl.hashCode) +
      (clientSecret == null ? 0 : clientSecret.hashCode) +
      (invoicePaid == null ? 0 : invoicePaid.hashCode) +
      (subscriptionId == null ? 0 : subscriptionId.hashCode);

  factory CreateGenericSubscriptionResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateGenericSubscriptionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateGenericSubscriptionResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
