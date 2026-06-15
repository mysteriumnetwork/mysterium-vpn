import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/utils/platform.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn_design/icons/untitled_ui.dart';

enum SubscriptionOnboardingStep {
  connectButton(
    desktopIndex: 3,
    mobileIndex: 4,
    desktopIcon: UntitledUI.rocket_02,
    mobileIcon: UntitledUI.rocket_02,
    desktopTitle: LocaleKeys.subscriptionOnboardingConnectTitle,
    mobileTitle: LocaleKeys.subscriptionOnboardingConnectTitle,
    desktopDescription: LocaleKeys.subscriptionOnboardingConnectDescription,
    mobileDescription: LocaleKeys.subscriptionOnboardingConnectDescription,
  ),
  locations(
    desktopIndex: 5,
    mobileIndex: 1,
    desktopIcon: UntitledUI.flag_01,
    mobileIcon: UntitledUI.flag_01,
    desktopTitle: LocaleKeys.subscriptionOnboardingVPNLocationsTitle,
    mobileTitle: LocaleKeys.subscriptionOnboardingVPNLocationsTitle,
    desktopDescription: LocaleKeys.subscriptionOnboardingVPNLocationsDesktopDescription,
    mobileDescription: LocaleKeys.subscriptionOnboardingVPNLocationsMobileDescription,
  ),
  map(
    desktopIndex: 0,
    mobileIndex: 0,
    desktopIcon: UntitledUI.map_01,
    mobileIcon: UntitledUI.map_01,
    desktopTitle: LocaleKeys.subscriptionOnboardingMapDesktopTitle,
    mobileTitle: LocaleKeys.subscriptionOnboardingMapMobileTitle,
    desktopDescription: LocaleKeys.subscriptionOnboardingMapDesktopDescription,
    mobileDescription: LocaleKeys.subscriptionOnboardingMapMobileDescription,
  ),
  products(
    desktopIndex: 1,
    mobileIndex: 2,
    desktopIcon: UntitledUI.star_06,
    mobileIcon: UntitledUI.star_06,
    desktopTitle: LocaleKeys.subscriptionOnboardingManagePlanTitle,
    mobileTitle: LocaleKeys.subscriptionOnboardingManagePlanTitle,
    desktopDescription: LocaleKeys.subscriptionOnboardingManagePlanDescription,
    mobileDescription: LocaleKeys.subscriptionOnboardingManagePlanDescription,
  ),
  search(
    desktopIndex: 4,
    mobileIndex: 5,
    desktopIcon: UntitledUI.search_sm,
    mobileIcon: UntitledUI.search_sm,
    desktopTitle: LocaleKeys.subscriptionOnboardingSearchTitle,
    mobileTitle: LocaleKeys.subscriptionOnboardingSearchTitle,
    desktopDescription: LocaleKeys.subscriptionOnboardingSearchDescription,
    mobileDescription: LocaleKeys.subscriptionOnboardingSearchDescription,
  ),
  settings(
    desktopIndex: 2,
    mobileIndex: 3,
    desktopIcon: UntitledUI.lock_01,
    mobileIcon: UntitledUI.lock_01,
    desktopTitle: LocaleKeys.subscriptionOnboardingBoostProtectionTitle,
    mobileTitle: LocaleKeys.subscriptionOnboardingBoostProtectionTitle,
    desktopDescription: LocaleKeys.subscriptionOnboardingBoostProtectionDescription,
    mobileDescription: LocaleKeys.subscriptionOnboardingBoostProtectionDescription,
  );

  const SubscriptionOnboardingStep({
    required this.desktopIndex,
    required this.mobileIndex,
    required this.desktopIcon,
    required this.mobileIcon,
    required this.desktopTitle,
    required this.mobileTitle,
    required this.desktopDescription,
    required this.mobileDescription,
  });

  final int desktopIndex;
  final int mobileIndex;
  final IconData desktopIcon;
  final IconData mobileIcon;
  final String desktopTitle;
  final String mobileTitle;
  final String desktopDescription;
  final String mobileDescription;

  int get totalSteps => SubscriptionOnboardingStep.values.length;

  int get platformIndex => isDesktop() ? desktopIndex : mobileIndex;

  String get title => isDesktop() ? desktopTitle : mobileTitle;

  String get description => isDesktop() ? desktopDescription : mobileDescription;

  IconData get icon => isDesktop() ? desktopIcon : mobileIcon;
}
