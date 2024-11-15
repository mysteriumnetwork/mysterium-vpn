//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:vpn_api/src/model/subscription_config_response_plans_inner.dart';
import 'package:vpn_api/src/model/subscription_config_response_gateways_inner.dart';
import 'package:vpn_api/src/model/country.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subscription_config_response.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SubscriptionConfigResponse {
  /// Returns a new [SubscriptionConfigResponse] instance.
  SubscriptionConfigResponse({
    required this.gateways,
    required this.plans,
    required this.countries,
    required this.stripeReturnUrl,
    required this.stripePublishableKey,
  });

  @JsonKey(
    name: r'gateways',
    required: true,
    includeIfNull: false,
  )
  final List<SubscriptionConfigResponseGatewaysInner> gateways;

  @JsonKey(
    name: r'plans',
    required: true,
    includeIfNull: false,
  )
  final List<SubscriptionConfigResponsePlansInner> plans;

  @JsonKey(
    name: r'countries',
    required: true,
    includeIfNull: false,
  )
  final List<Country> countries;

  @JsonKey(
    name: r'stripe_return_url',
    required: true,
    includeIfNull: false,
  )
  final String stripeReturnUrl;

  @JsonKey(
    name: r'stripe_publishable_key',
    required: true,
    includeIfNull: false,
  )
  final String stripePublishableKey;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionConfigResponse &&
          other.gateways == gateways &&
          other.plans == plans &&
          other.countries == countries &&
          other.stripeReturnUrl == stripeReturnUrl &&
          other.stripePublishableKey == stripePublishableKey;

  @override
  int get hashCode =>
      gateways.hashCode +
      plans.hashCode +
      countries.hashCode +
      stripeReturnUrl.hashCode +
      stripePublishableKey.hashCode;

  factory SubscriptionConfigResponse.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionConfigResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionConfigResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
