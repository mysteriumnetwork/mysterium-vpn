import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/tooltip_content.dart';
import 'package:showcaseview/showcaseview.dart';

final subscriptionOnboardingSetupPOD = Provider<SubscriptionOnboardingSetup>(
  (ref) => SubscriptionOnboardingSetup(),
);

class SubscriptionOnboardingSetup {
  SubscriptionOnboardingSetup()
    : keys = List.generate(totalSteps, (_) => GlobalKey<State<StatefulWidget>>());

  static const totalSteps = 6;

  static const mapIndex = 0;
  static const locationsIndex = 1;
  static const productsIndex = 2;
  static const connectButtonIndex = 3;
  static const settingsIndex = 4;
  static const searchIndex = 5;

  final List<GlobalKey<State<StatefulWidget>>> keys;

  List<int> get orderedIndexes => isDesktop()
      ? [mapIndex, productsIndex, settingsIndex, connectButtonIndex, searchIndex, locationsIndex]
      : [mapIndex, locationsIndex, productsIndex, settingsIndex, connectButtonIndex, searchIndex];

  List<GlobalKey<State<StatefulWidget>>> get orderedKeys => [
    for (final index in orderedIndexes) keys[index],
  ];

  int get visibleStepsCount => orderedIndexes.length;

  List<TooltipContent> get tooltipContents =>
      isDesktop() ? _desktopTooltipContents : _mobileTooltipContents;

  GlobalKey<State<StatefulWidget>> get connectButtonKey => keys[connectButtonIndex];

  TooltipContent get connectButtonTooltipContent => tooltipContents[connectButtonIndex];

  GlobalKey<State<StatefulWidget>> get searchKey => keys[searchIndex];

  TooltipContent get searchTooltipContent => tooltipContents[searchIndex];

  GlobalKey<State<StatefulWidget>> keyForTab(HomeTab tab) => keys[indexForTab(tab)];

  int displayIndexForStep(int stepIndex) {
    final index = orderedIndexes.indexOf(stepIndex);
    return index == -1 ? stepIndex : index;
  }

  int displayIndexForTab(HomeTab tab) => displayIndexForStep(indexForTab(tab));

  int indexForTab(HomeTab tab) => switch (tab) {
    HomeTab.map => mapIndex,
    HomeTab.locations => locationsIndex,
    HomeTab.products => productsIndex,
    HomeTab.settings => settingsIndex,
  };
}

List<TooltipContent> get _mobileTooltipContents => [
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
    title: LocaleKeys.subscriptionOnboardingConnectTitle.tr(),
    description: LocaleKeys.subscriptionOnboardingConnectDescription.tr(),
    onActionPressed: () => ShowcaseView.get().next(),
  ),
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingBoostProtectionTitle.tr(),
    description: LocaleKeys.subscriptionOnboardingBoostProtectionDescription.tr(),
    onActionPressed: () => ShowcaseView.get().next(),
  ),
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingSearchTitle.tr(),
    description: LocaleKeys.subscriptionOnboardingSearchDescription.tr(),
    onActionPressed: () => ShowcaseView.get().next(),
  ),
];

List<TooltipContent> get _desktopTooltipContents => [
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingMapDesktopDescription.tr(),
    description: LocaleKeys.subscriptionOnboardingMapDesktopDescription.tr(),
    onActionPressed: () => ShowcaseView.get().next(),
  ),
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingVPNLocationsTitle.tr(),
    description: LocaleKeys.subscriptionOnboardingVPNLocationsDesktopDescription.tr(),
    onActionPressed: () => ShowcaseView.get().next(),
  ),
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingManagePlanTitle.tr(),
    description: LocaleKeys.subscriptionOnboardingManagePlanDescription.tr(),
    onActionPressed: () => ShowcaseView.get().next(),
  ),
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingConnectTitle.tr(),
    description: LocaleKeys.subscriptionOnboardingConnectDescription.tr(),
    onActionPressed: () => ShowcaseView.get().next(),
  ),
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingBoostProtectionTitle.tr(),
    description: LocaleKeys.subscriptionOnboardingBoostProtectionDescription.tr(),
    onActionPressed: () => ShowcaseView.get().next(),
  ),
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingSearchTitle.tr(),
    description: LocaleKeys.subscriptionOnboardingSearchDescription.tr(),
    onActionPressed: () => ShowcaseView.get().next(),
  ),
];
