// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoices_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoicesResponse _$InvoicesResponseFromJson(Map<String, dynamic> json) => $checkedCreate(
      'InvoicesResponse',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['data', 'paging'],
        );
        final val = InvoicesResponse(
          data: $checkedConvert(
              'data',
              (v) => (v as List<dynamic>)
                  .map((e) => Invoice.fromJson(e as Map<String, dynamic>))
                  .toList()),
          paging: $checkedConvert(
              'paging', (v) => InvoicesResponsePaging.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$InvoicesResponseToJson(InvoicesResponse instance) => <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
      'paging': instance.paging.toJson(),
    };
