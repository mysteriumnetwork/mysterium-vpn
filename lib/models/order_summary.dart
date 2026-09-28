import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_summary.freezed.dart';

@freezed
abstract class OrderSummary with _$OrderSummary {
  factory OrderSummary({
    required String country,
    required String currency,
    required String itemSubtotal,
    required String itemSubtotalBeforeDiscount,
    required String taxRate,
    required String taxSubtotal,
    required String taxSubtotalBeforeDiscount,
    required String taxType,
    required String totalPrice,
    required String totalPriceBeforeDiscount,
    String? discountAmount,
    String? discountUnits,
  }) = _OrderSummary;

  OrderSummary._();
}
