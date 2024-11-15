//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'invoices_response_paging.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class InvoicesResponsePaging {
  /// Returns a new [InvoicesResponsePaging] instance.
  InvoicesResponsePaging({
    required this.page,
    required this.pageSize,
    required this.totalCount,
  });

  @JsonKey(
    name: r'page',
    required: true,
    includeIfNull: false,
  )
  final num page;

  @JsonKey(
    name: r'page_size',
    required: true,
    includeIfNull: false,
  )
  final num pageSize;

  @JsonKey(
    name: r'total_count',
    required: true,
    includeIfNull: false,
  )
  final num totalCount;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoicesResponsePaging &&
          other.page == page &&
          other.pageSize == pageSize &&
          other.totalCount == totalCount;

  @override
  int get hashCode => page.hashCode + pageSize.hashCode + totalCount.hashCode;

  factory InvoicesResponsePaging.fromJson(Map<String, dynamic> json) =>
      _$InvoicesResponsePagingFromJson(json);

  Map<String, dynamic> toJson() => _$InvoicesResponsePagingToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
