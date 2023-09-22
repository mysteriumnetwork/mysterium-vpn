// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';

part 'subscription.freezed.dart';
part 'subscription.g.dart';

@freezed
class Subscription with _$Subscription {
  factory Subscription({
    required bool active,
    @JsonKey(name: 'plan_id') String? planId,
    @JsonKey(name: 'gateway') String? gateway,
    @JsonKey(name: 'active_until') DateTime? activeUntil,
    @JsonKey(name: 'expired') bool? expired,
    @JsonKey(name: 'recurring') bool? recurring,
  }) = _Subscription;
  factory Subscription.fromJson(Map<String, dynamic> json) => _$SubscriptionFromJson(json);
}

extension SubscriptionExtension on Subscription {
  bool get isExpired => activeUntil != null && activeUntil!.isBefore(DateTime.now());
  String get gatewayName => switch (gateway?.toLowerCase()) {
        null => '',
        'stripe' => 'Credit Card',
        'apple' => 'Apple',
        'google' => 'Google',
        'paypal' => 'PayPal',
        _ => gateway!.capitalize()
      };
}
