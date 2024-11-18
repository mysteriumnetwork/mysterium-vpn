//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'order_summary_request.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OrderSummaryRequest {
  /// Returns a new [OrderSummaryRequest] instance.
  OrderSummaryRequest({
    required this.country,
    this.state,
    required this.planId,
    this.couponCode,
  });

  @JsonKey(
    name: r'country',
    required: true,
    includeIfNull: false,
  )
  final String country;

  @JsonKey(
    name: r'state',
    required: false,
    includeIfNull: false,
  )
  final String? state;

  @JsonKey(
    name: r'plan_id',
    required: true,
    includeIfNull: false,
  )
  final String planId;

  @JsonKey(
    name: r'coupon_code',
    required: false,
    includeIfNull: false,
  )
  final String? couponCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderSummaryRequest &&
          other.country == country &&
          other.state == state &&
          other.planId == planId &&
          other.couponCode == couponCode;

  @override
  int get hashCode =>
      country.hashCode +
      (state == null ? 0 : state.hashCode) +
      planId.hashCode +
      (couponCode == null ? 0 : couponCode.hashCode);

  factory OrderSummaryRequest.fromJson(Map<String, dynamic> json) =>
      _$OrderSummaryRequestFromJson(json);

  Map<String, dynamic> toJson() => _$OrderSummaryRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
