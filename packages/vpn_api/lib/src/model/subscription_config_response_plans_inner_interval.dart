//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'subscription_config_response_plans_inner_interval.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SubscriptionConfigResponsePlansInnerInterval {
  /// Returns a new [SubscriptionConfigResponsePlansInnerInterval] instance.
  SubscriptionConfigResponsePlansInnerInterval({
    required this.unit,
    required this.amount,
  });

  @JsonKey(
    name: r'unit',
    required: true,
    includeIfNull: false,
  )
  final SubscriptionConfigResponsePlansInnerIntervalUnitEnum unit;

  @JsonKey(
    name: r'amount',
    required: true,
    includeIfNull: false,
  )
  final num amount;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionConfigResponsePlansInnerInterval &&
          other.unit == unit &&
          other.amount == amount;

  @override
  int get hashCode => unit.hashCode + amount.hashCode;

  factory SubscriptionConfigResponsePlansInnerInterval.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionConfigResponsePlansInnerIntervalFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionConfigResponsePlansInnerIntervalToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

enum SubscriptionConfigResponsePlansInnerIntervalUnitEnum {
  @JsonValue(r'year')
  year(r'year'),
  @JsonValue(r'month')
  month(r'month');

  const SubscriptionConfigResponsePlansInnerIntervalUnitEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
