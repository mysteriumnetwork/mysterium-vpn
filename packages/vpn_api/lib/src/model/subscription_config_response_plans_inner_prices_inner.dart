//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'subscription_config_response_plans_inner_prices_inner.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SubscriptionConfigResponsePlansInnerPricesInner {
  /// Returns a new [SubscriptionConfigResponsePlansInnerPricesInner] instance.
  SubscriptionConfigResponsePlansInnerPricesInner({
    required this.currency,
    required this.discountAmount,
    required this.discountUnits,
    required this.discountedFullPrice,
    required this.discountedMonthlyPrice,
    required this.fullPrice,
    required this.monthlyPrice,
  });

  @JsonKey(
    name: r'currency',
    required: true,
    includeIfNull: false,
  )
  final String currency;

  @JsonKey(
    name: r'discount_amount',
    required: true,
    includeIfNull: false,
  )
  final String discountAmount;

  @JsonKey(
    name: r'discount_units',
    required: true,
    includeIfNull: false,
  )
  final String discountUnits;

  @JsonKey(
    name: r'discounted_full_price',
    required: true,
    includeIfNull: false,
  )
  final String discountedFullPrice;

  @JsonKey(
    name: r'discounted_monthly_price',
    required: true,
    includeIfNull: false,
  )
  final String discountedMonthlyPrice;

  @JsonKey(
    name: r'full_price',
    required: true,
    includeIfNull: false,
  )
  final String fullPrice;

  @JsonKey(
    name: r'monthly_price',
    required: true,
    includeIfNull: false,
  )
  final String monthlyPrice;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionConfigResponsePlansInnerPricesInner &&
          other.currency == currency &&
          other.discountAmount == discountAmount &&
          other.discountUnits == discountUnits &&
          other.discountedFullPrice == discountedFullPrice &&
          other.discountedMonthlyPrice == discountedMonthlyPrice &&
          other.fullPrice == fullPrice &&
          other.monthlyPrice == monthlyPrice;

  @override
  int get hashCode =>
      currency.hashCode +
      discountAmount.hashCode +
      discountUnits.hashCode +
      discountedFullPrice.hashCode +
      discountedMonthlyPrice.hashCode +
      fullPrice.hashCode +
      monthlyPrice.hashCode;

  factory SubscriptionConfigResponsePlansInnerPricesInner.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionConfigResponsePlansInnerPricesInnerFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionConfigResponsePlansInnerPricesInnerToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
