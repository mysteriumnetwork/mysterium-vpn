//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:vpn_api/src/model/create_google_subscription_response.dart';
import 'package:vpn_api/src/model/create_generic_subscription_response.dart';
import 'package:vpn_api/src/model/create_apple_subscription_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subscribe200_response.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Subscribe200Response {
  /// Returns a new [Subscribe200Response] instance.
  Subscribe200Response({
    required this.gatewayId,
    this.checkoutUrl,
    this.clientSecret,
    this.invoicePaid,
    this.subscriptionId,
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
      other is Subscribe200Response &&
          other.gatewayId == gatewayId &&
          other.checkoutUrl == checkoutUrl &&
          other.clientSecret == clientSecret &&
          other.invoicePaid == invoicePaid &&
          other.subscriptionId == subscriptionId &&
          other.subscriptionBasePlanId == subscriptionBasePlanId &&
          other.subscriptionProductId == subscriptionProductId;

  @override
  int get hashCode =>
      gatewayId.hashCode +
      (checkoutUrl == null ? 0 : checkoutUrl.hashCode) +
      (clientSecret == null ? 0 : clientSecret.hashCode) +
      (invoicePaid == null ? 0 : invoicePaid.hashCode) +
      (subscriptionId == null ? 0 : subscriptionId.hashCode) +
      subscriptionBasePlanId.hashCode +
      subscriptionProductId.hashCode;

  factory Subscribe200Response.fromJson(Map<String, dynamic> json) =>
      _$Subscribe200ResponseFromJson(json);

  Map<String, dynamic> toJson() => _$Subscribe200ResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
