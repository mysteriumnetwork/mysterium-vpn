//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:vpn_api/src/model/invoice.dart';
import 'package:vpn_api/src/model/invoices_response_paging.dart';
import 'package:json_annotation/json_annotation.dart';

part 'invoices_response.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class InvoicesResponse {
  /// Returns a new [InvoicesResponse] instance.
  InvoicesResponse({
    required this.data,
    required this.paging,
  });

  @JsonKey(
    name: r'data',
    required: true,
    includeIfNull: false,
  )
  final List<Invoice> data;

  @JsonKey(
    name: r'paging',
    required: true,
    includeIfNull: false,
  )
  final InvoicesResponsePaging paging;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoicesResponse && other.data == data && other.paging == paging;

  @override
  int get hashCode => data.hashCode + paging.hashCode;

  factory InvoicesResponse.fromJson(Map<String, dynamic> json) => _$InvoicesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InvoicesResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
