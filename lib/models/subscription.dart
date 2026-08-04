// Package imports:
import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/utils/payment_gateway.dart';

part 'subscription.freezed.dart';

@freezed
abstract class Subscription with _$Subscription {
  factory Subscription({
    required bool active,
    String? id,
    String? planId,
    String? gateway,
    DateTime? activeUntil,
    bool? expired,
    bool? recurring,
    bool? paused,
    DateTime? pausedUntil,
    String? storePlanId,
    DateTime? periodStart,
  }) = _Subscription;

  Subscription._();

  factory Subscription.empty() => Subscription(active: false, expired: false, recurring: false);

  bool get isExpired => activeUntil != null && activeUntil!.isBefore(DateTime.now());

  String get gatewayName => switch (gateway?.toLowerCase()) {
    null => '',
    'stripe' || 'adyen' => 'Credit Card',
    'apple' => 'Apple',
    'google' => 'Google',
    'paypal' => 'PayPal',
    'coingate' => 'Crypto',
    _ => gateway!.capitalize(),
  };

  bool get isGatewayOnCurrentPlatform => isGatewayOnPlatform(
    gateway,
    isIOS: Platform.isIOS,
    isAndroid: Platform.isAndroid,
    isMacOS: Platform.isMacOS,
  );

  bool get isGoogleGateway => gateway?.toLowerCase() == 'google';

  bool get isAppleGateway => gateway?.toLowerCase() == 'apple';

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
