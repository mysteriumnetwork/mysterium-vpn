import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/tooltip_content.dart';
import 'package:mysterium_vpn_design/icons/untitled_ui.dart';
import 'package:showcaseview/showcaseview.dart';

final subscriptionOnboardingSetupPOD = Provider<SubscriptionOnboardingSetup>(
  (ref) => _SubscriptionOnboardingSetup(),
);

abstract interface class SubscriptionOnboardingSetup {
  static const totalSteps = 6;

  static const mapIndex = 0;
  static const locationsIndex = 1;
  static const productsIndex = 2;
  static const connectButtonIndex = 3;
  static const settingsIndex = 4;
  static const searchIndex = 5;

  List<GlobalKey<State<StatefulWidget>>> get orderedKeys;

  int get visibleStepsCount;

  List<TooltipContent> get tooltipContents;

  GlobalKey<State<StatefulWidget>> get connectButtonKey;

  TooltipContent get connectButtonTooltipContent;

  GlobalKey<State<StatefulWidget>> get searchKey;

  TooltipContent get searchTooltipContent;

  GlobalKey<State<StatefulWidget>> keyForTab(HomeTab tab);

  int stepIndex(int targetIndex);

  int displayIndexForTab(HomeTab tab);

  int indexForTab(HomeTab tab);
}

class _SubscriptionOnboardingSetup implements SubscriptionOnboardingSetup {
  _SubscriptionOnboardingSetup()
    : keys = List.generate(
        SubscriptionOnboardingSetup.totalSteps,
        (_) => GlobalKey<State<StatefulWidget>>(),
      );

  final List<GlobalKey<State<StatefulWidget>>> keys;

  List<int> get orderedIndexes => isDesktop()
      ? [
          SubscriptionOnboardingSetup.mapIndex,
          SubscriptionOnboardingSetup.productsIndex,
          SubscriptionOnboardingSetup.settingsIndex,
          SubscriptionOnboardingSetup.connectButtonIndex,
          SubscriptionOnboardingSetup.searchIndex,
          SubscriptionOnboardingSetup.locationsIndex,
        ]
      : [
          SubscriptionOnboardingSetup.mapIndex,
          SubscriptionOnboardingSetup.locationsIndex,
          SubscriptionOnboardingSetup.productsIndex,
          SubscriptionOnboardingSetup.settingsIndex,
          SubscriptionOnboardingSetup.connectButtonIndex,
          SubscriptionOnboardingSetup.searchIndex,
        ];

  @override
  List<GlobalKey<State<StatefulWidget>>> get orderedKeys => [
    for (final index in orderedIndexes) keys[index],
  ];

  @override
  int get visibleStepsCount => orderedIndexes.length;

  @override
  List<TooltipContent> get tooltipContents =>
      isDesktop() ? _desktopTooltipContents : _mobileTooltipContents;

  @override
  GlobalKey<State<StatefulWidget>> get connectButtonKey =>
      keys[SubscriptionOnboardingSetup.connectButtonIndex];

  @override
  TooltipContent get connectButtonTooltipContent =>
      tooltipContents[SubscriptionOnboardingSetup.connectButtonIndex];

  @override
  GlobalKey<State<StatefulWidget>> get searchKey => keys[SubscriptionOnboardingSetup.searchIndex];

  @override
  TooltipContent get searchTooltipContent =>
      tooltipContents[SubscriptionOnboardingSetup.searchIndex];

  @override
  GlobalKey<State<StatefulWidget>> keyForTab(HomeTab tab) => keys[indexForTab(tab)];

  @override
  int stepIndex(int targetIndex) {
    final stepIndex = orderedIndexes.indexOf(targetIndex);
    return stepIndex == -1 ? targetIndex : stepIndex;
  }

  @override
  int displayIndexForTab(HomeTab tab) => stepIndex(indexForTab(tab));

  @override
  int indexForTab(HomeTab tab) => switch (tab) {
    HomeTab.map => SubscriptionOnboardingSetup.mapIndex,
    HomeTab.locations => SubscriptionOnboardingSetup.locationsIndex,
    HomeTab.products => SubscriptionOnboardingSetup.productsIndex,
    HomeTab.settings => SubscriptionOnboardingSetup.settingsIndex,
  };
}

List<TooltipContent> get _mobileTooltipContents => [
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingMapMobileTitle.tr(),
    description: LocaleKeys.subscriptionOnboardingMapMobileDescription.tr(),
    icon: UntitledUI.map_01,
    onActionPressed: () => ShowcaseView.get().next(),
  ),
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingVPNLocationsTitle.tr(),
    description: LocaleKeys.subscriptionOnboardingVPNLocationsMobileDescription.tr(),
    icon: UntitledUI.flag_01,
    onActionPressed: () => ShowcaseView.get().next(),
  ),
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingManagePlanTitle.tr(),
    description: LocaleKeys.subscriptionOnboardingManagePlanDescription.tr(),
    icon: UntitledUI.star_06,
    onActionPressed: () => ShowcaseView.get().next(),
  ),
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingConnectTitle.tr(),
    description: LocaleKeys.subscriptionOnboardingConnectDescription.tr(),
    icon: UntitledUI.rocket_02,
    onActionPressed: () => ShowcaseView.get().next(),
  ),
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingBoostProtectionTitle.tr(),
    description: LocaleKeys.subscriptionOnboardingBoostProtectionDescription.tr(),
    icon: UntitledUI.lock_01,
    onActionPressed: () => ShowcaseView.get().next(),
  ),
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingSearchTitle.tr(),
    description: LocaleKeys.subscriptionOnboardingSearchDescription.tr(),
    icon: UntitledUI.search_sm,
    onActionPressed: () => ShowcaseView.get().next(),
  ),
];

List<TooltipContent> get _desktopTooltipContents => [
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingMapDesktopDescription.tr(),
    description: LocaleKeys.subscriptionOnboardingMapDesktopDescription.tr(),
    icon: UntitledUI.map_01,
    onActionPressed: () => ShowcaseView.get().next(),
  ),
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingVPNLocationsTitle.tr(),
    description: LocaleKeys.subscriptionOnboardingVPNLocationsDesktopDescription.tr(),
    icon: UntitledUI.star_06,
    onActionPressed: () => ShowcaseView.get().next(),
  ),
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingManagePlanTitle.tr(),
    description: LocaleKeys.subscriptionOnboardingManagePlanDescription.tr(),
    icon: UntitledUI.rocket_02,
    onActionPressed: () => ShowcaseView.get().next(),
  ),
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingConnectTitle.tr(),
    description: LocaleKeys.subscriptionOnboardingConnectDescription.tr(),
    icon: UntitledUI.lock_01,
    onActionPressed: () => ShowcaseView.get().next(),
  ),
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingBoostProtectionTitle.tr(),
    description: LocaleKeys.subscriptionOnboardingBoostProtectionDescription.tr(),
    icon: UntitledUI.search_sm,
    onActionPressed: () => ShowcaseView.get().next(),
  ),
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingSearchTitle.tr(),
    description: LocaleKeys.subscriptionOnboardingSearchDescription.tr(),
    icon: UntitledUI.flag_01,
    onActionPressed: () => ShowcaseView.get().next(),
  ),
];
