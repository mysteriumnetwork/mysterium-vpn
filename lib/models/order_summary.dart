import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';

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

  String? get currencySymbol => switch (currency.toLowerCase()) {
    'usd' => r'$',
    _ => null,
  };

  bool get hasDiscount {
    if (currencySymbol == null) {
      return false;
    }

    final discountedPrice = double.tryParse(totalPrice);
    final priceBeforeDiscount = double.tryParse(totalPriceBeforeDiscount);
    if (discountedPrice.isNullOrNotFinite || priceBeforeDiscount.isNullOrNotFinite) {
      return false;
    }

    return (priceBeforeDiscount! * 100).round() > (discountedPrice! * 100).round();
  }
}
