// Package imports:
import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';

part 'subscription.freezed.dart';
part 'subscription.g.dart';

@freezed
abstract class Subscription with _$Subscription {
  factory Subscription({
    required bool active,
    @JsonKey(name: 'plan_id') String? planId,
    @JsonKey(name: 'gateway') String? gateway,
    @JsonKey(name: 'active_until') DateTime? activeUntil,
    @JsonKey(name: 'expired') bool? expired,
    @JsonKey(name: 'recurring') bool? recurring,
  }) = _Subscription;

  Subscription._();

  factory Subscription.fromJson(Map<String, dynamic> json) => _$SubscriptionFromJson(json);

  factory Subscription.empty() => Subscription(active: false, expired: false, recurring: false);

  bool get isExpired => activeUntil != null && activeUntil!.isBefore(DateTime.now());

  String get gatewayName => switch (gateway?.toLowerCase()) {
        null => '',
        'stripe' || 'adyen' => 'Credit Card',
        'apple' => 'Apple',
        'google' => 'Google',
        'paypal' => 'PayPal',
        'coingate' => 'Crypto',
        _ => gateway!.capitalize()
      };

  bool get isGatewayOnCurrentPlatform => switch (gateway?.toLowerCase()) {
        'apple' => Platform.isIOS || Platform.isMacOS,
        'google' => Platform.isAndroid,
        _ => false,
      };

  String? get durationInMonthsBasedOnPlanId {
    final id = planId;
    if (id == null || id.isEmpty) {
      return null;
    }

    if (id.contains('monthly')) {
      return '1';
    }
    if (id.contains('years') && id.contains('2')) {
      return '24';
    }
    if (id.contains('yearly')) {
      return '12';
    }
    if (id.contains('months') && id.contains('6')) {
      return '6';
    }

    return null;
  }
}
