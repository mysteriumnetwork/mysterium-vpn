// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_summary_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderSummaryResponse _$OrderSummaryResponseFromJson(Map<String, dynamic> json) => $checkedCreate(
      'OrderSummaryResponse',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            'currency',
            'item_name',
            'item_subtotal',
            'tax_name',
            'tax_subtotal',
            'order_total',
            'item_subtotal_before_discount',
            'tax_subtotal_before_discount',
            'total_price_before_discount'
          ],
        );
        final val = OrderSummaryResponse(
          currency: $checkedConvert('currency', (v) => v as String),
          itemName: $checkedConvert('item_name', (v) => v as String),
          itemSubtotal: $checkedConvert('item_subtotal', (v) => v as String),
          taxName: $checkedConvert('tax_name', (v) => v as String),
          taxSubtotal: $checkedConvert('tax_subtotal', (v) => v as String),
          orderTotal: $checkedConvert('order_total', (v) => v as String),
          discountAmount: $checkedConvert('discount_amount', (v) => v as String?),
          discountUnits: $checkedConvert('discount_units', (v) => v as String?),
          itemSubtotalBeforeDiscount:
              $checkedConvert('item_subtotal_before_discount', (v) => v as String),
          taxSubtotalBeforeDiscount:
              $checkedConvert('tax_subtotal_before_discount', (v) => v as String),
          totalPriceBeforeDiscount:
              $checkedConvert('total_price_before_discount', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'itemName': 'item_name',
        'itemSubtotal': 'item_subtotal',
        'taxName': 'tax_name',
        'taxSubtotal': 'tax_subtotal',
        'orderTotal': 'order_total',
        'discountAmount': 'discount_amount',
        'discountUnits': 'discount_units',
        'itemSubtotalBeforeDiscount': 'item_subtotal_before_discount',
        'taxSubtotalBeforeDiscount': 'tax_subtotal_before_discount',
        'totalPriceBeforeDiscount': 'total_price_before_discount'
      },
    );

Map<String, dynamic> _$OrderSummaryResponseToJson(OrderSummaryResponse instance) {
  final val = <String, dynamic>{
    'currency': instance.currency,
    'item_name': instance.itemName,
    'item_subtotal': instance.itemSubtotal,
    'tax_name': instance.taxName,
    'tax_subtotal': instance.taxSubtotal,
    'order_total': instance.orderTotal,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('discount_amount', instance.discountAmount);
  writeNotNull('discount_units', instance.discountUnits);
  val['item_subtotal_before_discount'] = instance.itemSubtotalBeforeDiscount;
  val['tax_subtotal_before_discount'] = instance.taxSubtotalBeforeDiscount;
  val['total_price_before_discount'] = instance.totalPriceBeforeDiscount;
  return val;
}
