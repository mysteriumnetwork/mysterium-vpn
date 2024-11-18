//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'invoices_request.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class InvoicesRequest {
  /// Returns a new [InvoicesRequest] instance.
  InvoicesRequest({
    required this.page,
    required this.pageSize,
  });

  @JsonKey(
    name: r'page',
    required: true,
    includeIfNull: false,
  )
  final String page;

  @JsonKey(
    name: r'page_size',
    required: true,
    includeIfNull: false,
  )
  final String pageSize;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoicesRequest && other.page == page && other.pageSize == pageSize;

  @override
  int get hashCode => page.hashCode + pageSize.hashCode;

  factory InvoicesRequest.fromJson(Map<String, dynamic> json) => _$InvoicesRequestFromJson(json);

  Map<String, dynamic> toJson() => _$InvoicesRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
