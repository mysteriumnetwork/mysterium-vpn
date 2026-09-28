import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_summary.freezed.dart';

@freezed
abstract class OrderSummary with _$OrderSummary {
  factory OrderSummary({
    required String currency,

    /// Total price after discount
    required String totalPrice,

    /// Total price before discount
    required String totalPriceBeforeDiscount,
  }) = _OrderSummary;

  OrderSummary._();
}
