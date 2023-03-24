// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mysterium_vpn/models/gateway.dart';
import 'package:mysterium_vpn/models/plan_details.dart';

part 'subscription_config.freezed.dart';
part 'subscription_config.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class SubscriptionConfig with _$SubscriptionConfig {
  factory SubscriptionConfig({
    required List<Gateway> gateways,
    required List<PlanDetails> plans,
  }) = _SubscriptionConfig;

  factory SubscriptionConfig.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionConfigFromJson(json);
}
