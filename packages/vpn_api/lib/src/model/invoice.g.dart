// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invoice _$InvoiceFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Invoice',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            'id',
            'plan_id',
            'amount_gross',
            'name',
            'gateway',
            'status',
            'created_at'
          ],
        );
        final val = Invoice(
          id: $checkedConvert('id', (v) => v as String),
          planId: $checkedConvert('plan_id', (v) => v as String),
          amountGross: $checkedConvert('amount_gross', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
          gateway: $checkedConvert('gateway', (v) => v as String),
          status: $checkedConvert('status', (v) => v as String),
          createdAt: $checkedConvert('created_at', (v) => DateTime.parse(v as String)),
        );
        return val;
      },
      fieldKeyMap: const {
        'planId': 'plan_id',
        'amountGross': 'amount_gross',
        'createdAt': 'created_at'
      },
    );

Map<String, dynamic> _$InvoiceToJson(Invoice instance) => <String, dynamic>{
      'id': instance.id,
      'plan_id': instance.planId,
      'amount_gross': instance.amountGross,
      'name': instance.name,
      'gateway': instance.gateway,
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
    };
