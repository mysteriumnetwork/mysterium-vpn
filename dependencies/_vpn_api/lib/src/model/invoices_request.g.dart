// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoices_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoicesRequest _$InvoicesRequestFromJson(Map<String, dynamic> json) => $checkedCreate(
      'InvoicesRequest',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['page', 'page_size'],
        );
        final val = InvoicesRequest(
          page: $checkedConvert('page', (v) => v as String),
          pageSize: $checkedConvert('page_size', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'pageSize': 'page_size'},
    );

Map<String, dynamic> _$InvoicesRequestToJson(InvoicesRequest instance) => <String, dynamic>{
      'page': instance.page,
      'page_size': instance.pageSize,
    };
