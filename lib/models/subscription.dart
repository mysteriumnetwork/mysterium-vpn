// Package imports:
import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/utils/payment_gateway.dart';
import 'package:mysterium_vpn/models/extra_duration.dart';
import 'package:mysterium_vpn/models/order_summary.dart';

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
    bool? pauseAllowed,
    DateTime? pausedFrom,
    DateTime? pausedUntil,
    String? storePlanId,
    DateTime? periodStart,
    ExtraDuration? extraDuration,
    OrderSummary? orderSummary,
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

  bool get isPaused => paused ?? false;

  /// Server-side pause eligibility — the single source of truth for the pause offer.
  bool get isPauseAllowed => pauseAllowed ?? false;

  /// The single rule for whether this subscription entitles the user to a
  /// tunnel. Read by `VpnGuard` before connecting, and by the reaction that
  /// tears an established tunnel down when entitlement is lost.
  bool get grantsVpnAccess => active && !isPaused;

  /// Analytics-friendly status: paused / active / expired / inactive.
  String get analyticsStatus {
    if (paused == true) {
      return 'paused';
    }
    if (active) {
      return 'active';
    }
    if (expired == true || isExpired) {
      return 'expired';
    }
    return 'inactive';
  }

  /// The bonus period, or `null` when there is none to show. A bonus only
  /// counts when it adds at least one whole unit.
  ExtraDuration? get bonusDuration {
    final extra = extraDuration;
    return extra != null && extra.amount > 0 ? extra : null;
  }

  /// Standard billing period in months, inferred from the plan id. `null` for
  /// an unrecognised plan. Best-effort, for analytics only — anything shown to
  /// the user reads `SubscriptionStore.billingPeriodMonths` instead.
  int? get standardPeriodMonths {
    // Segment-wise, not substring: a `contains('months') && contains('6')`
    // ladder reads `plan_16_months` as 6.
    final segments = planId?.split('_') ?? const [];

    if (segments.contains('monthly')) {
      return 1;
    }
    if (segments.contains('yearly')) {
      return 12;
    }

    for (var i = 0; i + 1 < segments.length; i++) {
      final amount = int.tryParse(segments[i]);
      if (amount == null) {
        continue;
      }
      if (segments[i + 1] == 'years') {
        return amount * 12;
      }
      if (segments[i + 1] == 'months') {
        return amount;
      }
    }

    return null;
  }
}
