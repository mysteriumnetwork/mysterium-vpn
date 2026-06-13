import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:hooks_riverpod/legacy.dart';
import 'package:mysterium_vpn/views/home/arrowed_progress_card.dart';

class _HomeState extends ChangeNotifier {
  _HomeState();

  final typeSwitcherKey = GlobalKey();
  final locationsKey = GlobalKey();

  /// Anchors the residential-IP education reminder popover to the connection
  /// card on the map.
  final connectedCardKey = GlobalKey();

  ScrollController? scrollController;

  /// Indexed by [SubscriptionOnboardingStep.platformIndex] (tour order),
  /// not by enum declaration order.
  final subscriptionOnboardingKeys = [
    for (final _ in SubscriptionOnboardingStep.values) GlobalKey<State<StatefulWidget>>(),
  ];

  /// Tracks the country code that was already scrolled to, so the
  /// scroll-to-selected logic fires only once per selection.
  String? lastScrolledCountryCode;
}

// ignore: deprecated_member_use
final homeStateProvider = ChangeNotifierProvider.autoDispose((ref) => _HomeState());
