//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'subscription_config_response_plans_inner_price.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SubscriptionConfigResponsePlansInnerPrice {
  /// Returns a new [SubscriptionConfigResponsePlansInnerPrice] instance.
  SubscriptionConfigResponsePlansInnerPrice({
    required this.USD,
  });

  @JsonKey(
    name: r'USD',
    required: true,
    includeIfNull: false,
  )
  final num USD;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionConfigResponsePlansInnerPrice && other.USD == USD;

  @override
  int get hashCode => USD.hashCode;

  factory SubscriptionConfigResponsePlansInnerPrice.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionConfigResponsePlansInnerPriceFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionConfigResponsePlansInnerPriceToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
