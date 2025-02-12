//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'create_adyen_subscription_request.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateAdyenSubscriptionRequest {
  /// Returns a new [CreateAdyenSubscriptionRequest] instance.
  CreateAdyenSubscriptionRequest({
    required this.planId,
    required this.country,
    this.state,
    required this.currency,
    this.zipCode,
    this.couponCode,
    this.embedded,
    this.cardHolder,
    required this.amount,
    required this.origin,
    required this.gatewayId,
    this.paymentData,
  });

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

  @JsonKey(
    name: r'amount',
    required: true,
    includeIfNull: false,
  )
  final num amount;

  @JsonKey(
    name: r'origin',
    required: true,
    includeIfNull: false,
  )
  final String origin;

  @JsonKey(
    name: r'gateway_id',
    required: true,
    includeIfNull: false,
  )
  final CreateAdyenSubscriptionRequestGatewayIdEnum gatewayId;

  @JsonKey(
    name: r'payment_data',
    required: false,
    includeIfNull: false,
  )
  final Object? paymentData;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateAdyenSubscriptionRequest &&
          other.planId == planId &&
          other.country == country &&
          other.state == state &&
          other.currency == currency &&
          other.zipCode == zipCode &&
          other.couponCode == couponCode &&
          other.embedded == embedded &&
          other.cardHolder == cardHolder &&
          other.amount == amount &&
          other.origin == origin &&
          other.gatewayId == gatewayId &&
          other.paymentData == paymentData;

  @override
  int get hashCode =>
      planId.hashCode +
      country.hashCode +
      (state == null ? 0 : state.hashCode) +
      currency.hashCode +
      (zipCode == null ? 0 : zipCode.hashCode) +
      (couponCode == null ? 0 : couponCode.hashCode) +
      (embedded == null ? 0 : embedded.hashCode) +
      (cardHolder == null ? 0 : cardHolder.hashCode) +
      amount.hashCode +
      origin.hashCode +
      gatewayId.hashCode +
      (paymentData == null ? 0 : paymentData.hashCode);

  factory CreateAdyenSubscriptionRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateAdyenSubscriptionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateAdyenSubscriptionRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

enum CreateAdyenSubscriptionRequestGatewayIdEnum {
  @JsonValue(r'adyen')
  adyen(r'adyen');

  const CreateAdyenSubscriptionRequestGatewayIdEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
