//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'order_summary_response.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OrderSummaryResponse {
  /// Returns a new [OrderSummaryResponse] instance.
  OrderSummaryResponse({
    required this.currency,
    required this.itemName,
    required this.itemSubtotal,
    required this.taxName,
    required this.taxSubtotal,
    required this.orderTotal,
    this.discountAmount,
    this.discountUnits,
    required this.itemSubtotalBeforeDiscount,
    required this.taxSubtotalBeforeDiscount,
    required this.totalPriceBeforeDiscount,
  });

  @JsonKey(
    name: r'currency',
    required: true,
    includeIfNull: false,
  )
  final String currency;

  @JsonKey(
    name: r'item_name',
    required: true,
    includeIfNull: false,
  )
  final String itemName;

  @JsonKey(
    name: r'item_subtotal',
    required: true,
    includeIfNull: false,
  )
  final String itemSubtotal;

  @JsonKey(
    name: r'tax_name',
    required: true,
    includeIfNull: false,
  )
  final String taxName;

  @JsonKey(
    name: r'tax_subtotal',
    required: true,
    includeIfNull: false,
  )
  final String taxSubtotal;

  @JsonKey(
    name: r'order_total',
    required: true,
    includeIfNull: false,
  )
  final String orderTotal;

  @JsonKey(
    name: r'discount_amount',
    required: false,
    includeIfNull: false,
  )
  final String? discountAmount;

  @JsonKey(
    name: r'discount_units',
    required: false,
    includeIfNull: false,
  )
  final String? discountUnits;

  @JsonKey(
    name: r'item_subtotal_before_discount',
    required: true,
    includeIfNull: false,
  )
  final String itemSubtotalBeforeDiscount;

  @JsonKey(
    name: r'tax_subtotal_before_discount',
    required: true,
    includeIfNull: false,
  )
  final String taxSubtotalBeforeDiscount;

  @JsonKey(
    name: r'total_price_before_discount',
    required: true,
    includeIfNull: false,
  )
  final String totalPriceBeforeDiscount;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderSummaryResponse &&
          other.currency == currency &&
          other.itemName == itemName &&
          other.itemSubtotal == itemSubtotal &&
          other.taxName == taxName &&
          other.taxSubtotal == taxSubtotal &&
          other.orderTotal == orderTotal &&
          other.discountAmount == discountAmount &&
          other.discountUnits == discountUnits &&
          other.itemSubtotalBeforeDiscount == itemSubtotalBeforeDiscount &&
          other.taxSubtotalBeforeDiscount == taxSubtotalBeforeDiscount &&
          other.totalPriceBeforeDiscount == totalPriceBeforeDiscount;

  @override
  int get hashCode =>
      currency.hashCode +
      itemName.hashCode +
      itemSubtotal.hashCode +
      taxName.hashCode +
      taxSubtotal.hashCode +
      orderTotal.hashCode +
      (discountAmount == null ? 0 : discountAmount.hashCode) +
      (discountUnits == null ? 0 : discountUnits.hashCode) +
      itemSubtotalBeforeDiscount.hashCode +
      taxSubtotalBeforeDiscount.hashCode +
      totalPriceBeforeDiscount.hashCode;

  factory OrderSummaryResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderSummaryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderSummaryResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
