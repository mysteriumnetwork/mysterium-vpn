// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoices_response_paging.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoicesResponsePaging _$InvoicesResponsePagingFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'InvoicesResponsePaging',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['page', 'page_size', 'total_count'],
        );
        final val = InvoicesResponsePaging(
          page: $checkedConvert('page', (v) => v as num),
          pageSize: $checkedConvert('page_size', (v) => v as num),
          totalCount: $checkedConvert('total_count', (v) => v as num),
        );
        return val;
      },
      fieldKeyMap: const {'pageSize': 'page_size', 'totalCount': 'total_count'},
    );

Map<String, dynamic> _$InvoicesResponsePagingToJson(InvoicesResponsePaging instance) =>
    <String, dynamic>{
      'page': instance.page,
      'page_size': instance.pageSize,
      'total_count': instance.totalCount,
    };
