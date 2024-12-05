//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'create_generic_subscription_request.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateGenericSubscriptionRequest {
  /// Returns a new [CreateGenericSubscriptionRequest] instance.
  CreateGenericSubscriptionRequest({
    required this.gatewayId,
    required this.planId,
    required this.country,
    this.state,
    required this.currency,
    this.zipCode,
    this.couponCode,
    this.embedded,
    this.cardHolder,
  });

  @JsonKey(
    name: r'gateway_id',
    required: true,
    includeIfNull: false,
  )
  final String gatewayId;

  @JsonKey(
    name: r'plan_id',
    required: true,
    includeIfNull: false,
  )
  final String planId;

  @JsonKey(
    name: r'country',
    required: true,
    includeIfNull: false,
  )
  final String country;

  @JsonKey(
    name: r'state',
    required: false,
    includeIfNull: false,
  )
  final String? state;

  @JsonKey(
    name: r'currency',
    required: true,
    includeIfNull: false,
  )
  final String currency;

  @JsonKey(
    name: r'zip_code',
    required: false,
    includeIfNull: false,
  )
  final String? zipCode;

  @JsonKey(
    name: r'coupon_code',
    required: false,
    includeIfNull: false,
  )
  final String? couponCode;

  @JsonKey(
    name: r'embedded',
    required: false,
    includeIfNull: false,
  )
  final bool? embedded;

  @JsonKey(
    name: r'card_holder',
    required: false,
    includeIfNull: false,
  )
  final String? cardHolder;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateGenericSubscriptionRequest &&
          other.gatewayId == gatewayId &&
          other.planId == planId &&
          other.country == country &&
          other.state == state &&
          other.currency == currency &&
          other.zipCode == zipCode &&
          other.couponCode == couponCode &&
          other.embedded == embedded &&
          other.cardHolder == cardHolder;

  @override
  int get hashCode =>
      gatewayId.hashCode +
      planId.hashCode +
      country.hashCode +
      (state == null ? 0 : state.hashCode) +
      currency.hashCode +
      (zipCode == null ? 0 : zipCode.hashCode) +
      (couponCode == null ? 0 : couponCode.hashCode) +
      (embedded == null ? 0 : embedded.hashCode) +
      (cardHolder == null ? 0 : cardHolder.hashCode);

  factory CreateGenericSubscriptionRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateGenericSubscriptionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateGenericSubscriptionRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
