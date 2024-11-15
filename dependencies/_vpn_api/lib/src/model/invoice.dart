//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'invoice.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Invoice {
  /// Returns a new [Invoice] instance.
  Invoice({
    required this.id,
    required this.planId,
    required this.amountGross,
    required this.name,
    required this.gateway,
    required this.status,
    required this.createdAt,
  });

  @JsonKey(
    name: r'id',
    required: true,
    includeIfNull: false,
  )
  final String id;

  @JsonKey(
    name: r'plan_id',
    required: true,
    includeIfNull: false,
  )
  final String planId;

  @JsonKey(
    name: r'amount_gross',
    required: true,
    includeIfNull: false,
  )
  final String amountGross;

  @JsonKey(
    name: r'name',
    required: true,
    includeIfNull: false,
  )
  final String name;

  @JsonKey(
    name: r'gateway',
    required: true,
    includeIfNull: false,
  )
  final String gateway;

  @JsonKey(
    name: r'status',
    required: true,
    includeIfNull: false,
  )
  final String status;

  @JsonKey(
    name: r'created_at',
    required: true,
    includeIfNull: false,
  )
  final DateTime createdAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Invoice &&
          other.id == id &&
          other.planId == planId &&
          other.amountGross == amountGross &&
          other.name == name &&
          other.gateway == gateway &&
          other.status == status &&
          other.createdAt == createdAt;

  @override
  int get hashCode =>
      id.hashCode +
      planId.hashCode +
      amountGross.hashCode +
      name.hashCode +
      gateway.hashCode +
      status.hashCode +
      createdAt.hashCode;

  factory Invoice.fromJson(Map<String, dynamic> json) => _$InvoiceFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
