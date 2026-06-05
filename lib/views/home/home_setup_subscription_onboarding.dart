import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/tooltip_content.dart';
import 'package:showcaseview/showcaseview.dart';

(List<TooltipContent>, List<GlobalKey<State<StatefulWidget>>>) setupSubscriptionOnboarding({
  required int keysCount,
}) {
  final tooltipContents = _getTooltipContents();

  final globalKeys = useMemoized(
    () => List.generate(keysCount, (index) => GlobalKey<State<StatefulWidget>>()),
  );

  return (tooltipContents, globalKeys);
}

List<TooltipContent> _getTooltipContents() {
  final mobileTooltipContents = [
    TooltipContent(
      title: LocaleKeys.subscriptionOnboardingMapMobileTitle.tr(),
      description: LocaleKeys.subscriptionOnboardingMapMobileDescription.tr(),
      onActionPressed: () => ShowcaseView.get().next(),
    ),
    TooltipContent(
      title: LocaleKeys.subscriptionOnboardingVPNLocationsTitle.tr(),
      description: LocaleKeys.subscriptionOnboardingVPNLocationsMobileDescription.tr(),
      onActionPressed: () => ShowcaseView.get().next(),
    ),
    TooltipContent(
      title: LocaleKeys.subscriptionOnboardingManagePlanTitle.tr(),
      description: LocaleKeys.subscriptionOnboardingManagePlanDescription.tr(),
      onActionPressed: () => ShowcaseView.get().next(),
    ),
    TooltipContent(
      title: LocaleKeys.subscriptionOnboardingBoostProtectionTitle.tr(),
      description: LocaleKeys.subscriptionOnboardingBoostProtectionDescription.tr(),
      onActionPressed: () => ShowcaseView.get().next(),
    ),
    TooltipContent(
      title: LocaleKeys.subscriptionOnboardingConnectTitle.tr(),
      description: LocaleKeys.subscriptionOnboardingConnectDescription.tr(),
      onActionPressed: () => ShowcaseView.get().next(),
    ),
    TooltipContent(
      title: LocaleKeys.subscriptionOnboardingSearchTitle.tr(),
      description: LocaleKeys.subscriptionOnboardingSearchDescription.tr(),
      onActionPressed: () => ShowcaseView.get().next(),
    ),
  ];

  final desktopTooltipContents = [
    TooltipContent(
      title: LocaleKeys.subscriptionOnboardingMapDesktopDescription.tr(),
      description: LocaleKeys.subscriptionOnboardingMapDesktopDescription.tr(),
      onActionPressed: () => ShowcaseView.get().next(),
    ),
    TooltipContent(
      title: LocaleKeys.subscriptionOnboardingManagePlanTitle.tr(),
      description: LocaleKeys.subscriptionOnboardingManagePlanDescription.tr(),
      onActionPressed: () => ShowcaseView.get().next(),
    ),
    TooltipContent(
      title: LocaleKeys.subscriptionOnboardingBoostProtectionTitle.tr(),
      description: LocaleKeys.subscriptionOnboardingBoostProtectionDescription.tr(),
      onActionPressed: () => ShowcaseView.get().next(),
    ),
    TooltipContent(
      title: LocaleKeys.subscriptionOnboardingConnectTitle.tr(),
      description: LocaleKeys.subscriptionOnboardingConnectDescription.tr(),
      onActionPressed: () => ShowcaseView.get().next(),
    ),
    TooltipContent(
      title: LocaleKeys.subscriptionOnboardingSearchTitle.tr(),
      description: LocaleKeys.subscriptionOnboardingSearchDescription.tr(),
      onActionPressed: () => ShowcaseView.get().next(),
    ),
    TooltipContent(
      title: LocaleKeys.subscriptionOnboardingVPNLocationsTitle.tr(),
      description: LocaleKeys.subscriptionOnboardingVPNLocationsDesktopDescription.tr(),
      onActionPressed: () => ShowcaseView.get().next(),
    ),
  ];

  return isDesktop() ? desktopTooltipContents : mobileTooltipContents;
}
