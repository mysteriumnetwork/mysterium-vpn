//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'get_subscription_response.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GetSubscriptionResponse {
  /// Returns a new [GetSubscriptionResponse] instance.
  GetSubscriptionResponse({
    required this.active,
    this.periodStart,
    this.activeUntil,
    this.gateway,
    this.planId,
    this.portalUrl,
    required this.expired,
    required this.recurring,
    required this.subscriptionId,
    this.orderCurrency,
    this.orderNetAmount,
    this.orderCouponUsed,
  });

  @JsonKey(
    name: r'active',
    required: true,
    includeIfNull: false,
  )
  final bool active;

  @JsonKey(
    name: r'period_start',
    required: false,
    includeIfNull: false,
  )
  final DateTime? periodStart;

  @JsonKey(
    name: r'active_until',
    required: false,
    includeIfNull: false,
  )
  final DateTime? activeUntil;

  @JsonKey(
    name: r'gateway',
    required: false,
    includeIfNull: false,
  )
  final String? gateway;

  @JsonKey(
    name: r'plan_id',
    required: false,
    includeIfNull: false,
  )
  final String? planId;

  @JsonKey(
    name: r'portal_url',
    required: false,
    includeIfNull: false,
  )
  final String? portalUrl;

  @JsonKey(
    name: r'expired',
    required: true,
    includeIfNull: false,
  )
  final bool expired;

  @JsonKey(
    name: r'recurring',
    required: true,
    includeIfNull: false,
  )
  final bool recurring;

  @JsonKey(
    name: r'subscription_id',
    required: true,
    includeIfNull: false,
  )
  final String subscriptionId;

  @JsonKey(
    name: r'order_currency',
    required: false,
    includeIfNull: false,
  )
  final String? orderCurrency;

  @JsonKey(
    name: r'order_net_amount',
    required: false,
    includeIfNull: false,
  )
  final String? orderNetAmount;

  @JsonKey(
    name: r'order_coupon_used',
    required: false,
    includeIfNull: false,
  )
  final String? orderCouponUsed;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GetSubscriptionResponse &&
          other.active == active &&
          other.periodStart == periodStart &&
          other.activeUntil == activeUntil &&
          other.gateway == gateway &&
          other.planId == planId &&
          other.portalUrl == portalUrl &&
          other.expired == expired &&
          other.recurring == recurring &&
          other.subscriptionId == subscriptionId &&
          other.orderCurrency == orderCurrency &&
          other.orderNetAmount == orderNetAmount &&
          other.orderCouponUsed == orderCouponUsed;

  @override
  int get hashCode =>
      active.hashCode +
      (periodStart == null ? 0 : periodStart.hashCode) +
      (activeUntil == null ? 0 : activeUntil.hashCode) +
      (gateway == null ? 0 : gateway.hashCode) +
      (planId == null ? 0 : planId.hashCode) +
      (portalUrl == null ? 0 : portalUrl.hashCode) +
      expired.hashCode +
      recurring.hashCode +
      subscriptionId.hashCode +
      (orderCurrency == null ? 0 : orderCurrency.hashCode) +
      (orderNetAmount == null ? 0 : orderNetAmount.hashCode) +
      (orderCouponUsed == null ? 0 : orderCouponUsed.hashCode);

  factory GetSubscriptionResponse.fromJson(Map<String, dynamic> json) =>
      _$GetSubscriptionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetSubscriptionResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
