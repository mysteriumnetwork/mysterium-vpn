//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:vpn_api/src/model/subscription_config_response_plans_inner_interval.dart';
import 'package:vpn_api/src/model/subscription_config_response_plans_inner_price.dart';
import 'package:vpn_api/src/model/subscription_config_response_plans_inner_prices_inner.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subscription_config_response_plans_inner.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SubscriptionConfigResponsePlansInner {
  /// Returns a new [SubscriptionConfigResponsePlansInner] instance.
  SubscriptionConfigResponsePlansInner({
    required this.id,
    required this.appleProductId,
    required this.googleProductId,
    required this.interval,
    required this.price,
    required this.prices,
    required this.supportedGateways,
  });

  @JsonKey(
    name: r'id',
    required: true,
    includeIfNull: false,
  )
  final String id;

  @JsonKey(
    name: r'apple_product_id',
    required: true,
    includeIfNull: false,
  )
  final String appleProductId;

  @JsonKey(
    name: r'google_product_id',
    required: true,
    includeIfNull: false,
  )
  final String googleProductId;

  @JsonKey(
    name: r'interval',
    required: true,
    includeIfNull: false,
  )
  final SubscriptionConfigResponsePlansInnerInterval interval;

  @JsonKey(
    name: r'price',
    required: true,
    includeIfNull: false,
  )
  final SubscriptionConfigResponsePlansInnerPrice price;

  @JsonKey(
    name: r'prices',
    required: true,
    includeIfNull: false,
  )
  final List<SubscriptionConfigResponsePlansInnerPricesInner> prices;

  @JsonKey(
    name: r'supported_gateways',
    required: true,
    includeIfNull: false,
  )
  final List<String> supportedGateways;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionConfigResponsePlansInner &&
          other.id == id &&
          other.appleProductId == appleProductId &&
          other.googleProductId == googleProductId &&
          other.interval == interval &&
          other.price == price &&
          other.prices == prices &&
          other.supportedGateways == supportedGateways;

  @override
  int get hashCode =>
      id.hashCode +
      appleProductId.hashCode +
      googleProductId.hashCode +
      interval.hashCode +
      price.hashCode +
      prices.hashCode +
      supportedGateways.hashCode;

  factory SubscriptionConfigResponsePlansInner.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionConfigResponsePlansInnerFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionConfigResponsePlansInnerToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
