import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/icons/untitled_ui.dart';

enum SubscriptionOnboardingStep {
  connectButton(
    desktopIndex: 3,
    mobileIndex: 4,
    desktopIcon: UntitledUI.lock_01,
    mobileIcon: UntitledUI.lock_01,
  ),
  locations(
    desktopIndex: 5,
    mobileIndex: 1,
    desktopIcon: UntitledUI.flag_01,
    mobileIcon: UntitledUI.flag_01,
  ),
  map(
    desktopIndex: 0,
    mobileIndex: 0,
    desktopIcon: UntitledUI.map_01,
    mobileIcon: UntitledUI.map_01,
  ),
  products(
    desktopIndex: 1,
    mobileIndex: 2,
    desktopIcon: UntitledUI.star_06,
    mobileIcon: UntitledUI.star_06,
  ),
  search(
    desktopIndex: 4,
    mobileIndex: 5,
    desktopIcon: UntitledUI.search_sm,
    mobileIcon: UntitledUI.search_sm,
  ),
  settings(
    desktopIndex: 2,
    mobileIndex: 3,
    desktopIcon: UntitledUI.rocket_02,
    mobileIcon: UntitledUI.rocket_02,
  );

  const SubscriptionOnboardingStep({
    required this.desktopIndex,
    required this.mobileIndex,
    required this.desktopIcon,
    required this.mobileIcon,
  });

  final int desktopIndex;
  final int mobileIndex;
  final IconData desktopIcon;
  final IconData mobileIcon;

  int get totalSteps => SubscriptionOnboardingStep.values.length;

  /// Tour position for the rendered layout. [wideLayout] is the tablet/desktop
  /// scaffold — the one `ScreenTypeLayoutBuilder` picks, not the host OS.
  int platformIndex({required bool wideLayout}) => wideLayout ? desktopIndex : mobileIndex;

  static SubscriptionOnboardingStep? fromPlatformIndex(int index, {required bool wideLayout}) =>
      values.where((step) => step.platformIndex(wideLayout: wideLayout) == index).firstOrNull;

  IconData icon({required bool wideLayout}) => wideLayout ? desktopIcon : mobileIcon;
}
