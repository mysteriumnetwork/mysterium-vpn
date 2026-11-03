import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/icons/untitled_ui.dart';

enum SubscriptionOnboardingStep {
  connectButton(desktopIndex: 3, mobileIndex: 4, icon: UntitledUI.lock_01),
  locations(desktopIndex: 5, mobileIndex: 1, icon: UntitledUI.flag_01),
  map(desktopIndex: 0, mobileIndex: 0, icon: UntitledUI.map_01),
  products(desktopIndex: 1, mobileIndex: 2, icon: UntitledUI.star_06),
  search(desktopIndex: 4, mobileIndex: 5, icon: UntitledUI.search_sm),
  settings(desktopIndex: 2, mobileIndex: 3, icon: UntitledUI.rocket_02);

  const SubscriptionOnboardingStep({
    required this.desktopIndex,
    required this.mobileIndex,
    required this.icon,
  });

  final int desktopIndex;
  final int mobileIndex;
  final IconData icon;

  int get totalSteps => SubscriptionOnboardingStep.values.length;

  /// Tour position for the rendered layout. [wideLayout] is the tablet/desktop
  /// scaffold — the one `ScreenTypeLayoutBuilder` picks, not the host OS.
  int platformIndex({required bool wideLayout}) => wideLayout ? desktopIndex : mobileIndex;

  static SubscriptionOnboardingStep? fromPlatformIndex(int index, {required bool wideLayout}) =>
      values.where((step) => step.platformIndex(wideLayout: wideLayout) == index).firstOrNull;
}
