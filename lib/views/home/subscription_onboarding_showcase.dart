import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/dialogs/subscription_onboarding_dialog.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/tooltip_content.dart';
import 'package:mysterium_vpn/stores/home_tabs_store.dart';
import 'package:mysterium_vpn/stores/subscription_onboarding_store.dart';
import 'package:mysterium_vpn_design/icons/untitled_ui.dart';
import 'package:mysterium_vpn_design/widgets/floating_button.dart';
import 'package:showcaseview/showcaseview.dart';

class SubscriptionOnboardingShowcase {
  SubscriptionOnboardingShowcase({
    required SubscriptionOnboardingStore subscriptionOnboardingStore,
    required HomeTabsStore homeTabsStore,
  }) : _store = subscriptionOnboardingStore,
       _homeTabsStore = homeTabsStore,
       _keys = List.generate(_totalSteps, (_) => GlobalKey<State<StatefulWidget>>());

  static const _totalSteps = 6;

  static const _mapIndex = 0;
  static const _locationsIndex = 1;
  static const _productsIndex = 2;
  static const _connectButtonIndex = 3;
  static const _settingsIndex = 4;
  static const _searchIndex = 5;

  final SubscriptionOnboardingStore _store;
  final HomeTabsStore _homeTabsStore;
  final List<GlobalKey<State<StatefulWidget>>> _keys;

  bool _isRegistered = false;

  List<int> get _orderedIndexes => isDesktop()
      ? [
          _mapIndex,
          _productsIndex,
          _settingsIndex,
          _connectButtonIndex,
          _searchIndex,
          _locationsIndex,
        ]
      : [
          _mapIndex,
          _locationsIndex,
          _productsIndex,
          _settingsIndex,
          _connectButtonIndex,
          _searchIndex,
        ];

  List<GlobalKey<State<StatefulWidget>>> get _orderedKeys => [
    for (final index in _orderedIndexes) _keys[index],
  ];

  int get visibleStepsCount => _orderedIndexes.length;

  List<TooltipContent> get _tooltipContents =>
      isDesktop() ? _desktopTooltipContents : _mobileTooltipContents;

  TooltipContent tooltipContentForTab(HomeTab tab) => _tooltipContents[_indexForTab(tab)];

  int stepIndexForTab(HomeTab tab) => _stepIndex(_indexForTab(tab));

  GlobalKey<State<StatefulWidget>> keyForTab(HomeTab tab) => _keys[_indexForTab(tab)];

  GlobalKey<State<StatefulWidget>> get connectButtonKey => _keys[_connectButtonIndex];

  TooltipContent get connectButtonTooltipContent => _tooltipContents[_connectButtonIndex];

  int get connectButtonStepIndex => _stepIndex(_connectButtonIndex);

  GlobalKey<State<StatefulWidget>> get searchKey => _keys[_searchIndex];

  TooltipContent get searchTooltipContent => _tooltipContents[_searchIndex];

  int get searchStepIndex => _stepIndex(_searchIndex);

  GlobalKey<State<StatefulWidget>> get locationsListKey => _keys[_locationsIndex];

  TooltipContent get locationsListTooltipContent => _tooltipContents[_locationsIndex];

  int get locationsListStepIndex => _stepIndex(_locationsIndex);

  Future<void> showPrompt(BuildContext context) async {
    if (!context.mounted) {
      return;
    }

    await showSubscriptionOnboardingDialog(
      context: context,
      onStartTour: () => unawaited(_markShownAndStartTour(context)),
      onCancelTour: () => unawaited(_markShownAndSkip()),
    );
  }

  Future<void> _markShownAndStartTour(BuildContext context) async {
    await _store.markShown();
    if (!context.mounted) {
      return;
    }

    await startTour(context);
  }

  Future<void> _markShownAndSkip() async {
    await _store.markShown();
    _store.trackSkipped();
  }

  void register(BuildContext context) {
    if (_isRegistered) {
      return;
    }

    ShowcaseView.register(
      disableBarrierInteraction: true,
      globalFloatingActionWidget: (context) => FloatingActionWidget(
        top: 50,
        right: 50,
        child: FloatingButton(
          onPressed: () {
            _store.trackSkipped();
            ShowcaseView.get().dismiss();
          },
          label: LocaleKeys.skipBtn.tr(),
          icon: Icons.close,
        ),
      ),
      onStart: (index, key) => _store.trackStepViewed(index),
      onComplete: (index, key) => _store.trackStepCompleted(index),
      onFinish: () {
        _store.trackFinished();
        showSubscriptionOnboardingCompleteDialog(context: context).ignore();
      },
    );

    _isRegistered = true;
  }

  void unregister() {
    if (!_isRegistered) {
      return;
    }

    ShowcaseView.get().unregister();
    _isRegistered = false;
  }

  Future<void> startTour(BuildContext context) async {
    _store.trackStarted();

    if (isDesktop()) {
      _homeTabsStore.trySelect(HomeTab.map);
    } else {
      final beamer = Beamer.of(context);
      if (beamer.configuration.uri.path != Routes.main.path) {
        beamer.beamToNamed(Routes.main.path);
      }
    }

    await Future.delayed(const Duration(milliseconds: 200));
    if (!context.mounted) {
      return;
    }
    ShowcaseView.get().startShowCase(_orderedKeys);
  }

  void showNextTip(int stepIndex) => ShowcaseView.get().next();

  void dispose() => unregister();

  int _stepIndex(int targetIndex) =>
      _orderedIndexes.indexOf(targetIndex).clamp(0, visibleStepsCount - 1);

  int _indexForTab(HomeTab tab) => switch (tab) {
    HomeTab.map => _mapIndex,
    HomeTab.locations => _locationsIndex,
    HomeTab.products => _productsIndex,
    HomeTab.settings => _settingsIndex,
  };
}

List<TooltipContent> get _mobileTooltipContents => [
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingMapMobileTitle,
    description: LocaleKeys.subscriptionOnboardingMapMobileDescription,
    icon: UntitledUI.map_01,
  ),
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingVPNLocationsTitle,
    description: LocaleKeys.subscriptionOnboardingVPNLocationsMobileDescription,
    icon: UntitledUI.flag_01,
  ),
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingManagePlanTitle,
    description: LocaleKeys.subscriptionOnboardingManagePlanDescription,
    icon: UntitledUI.star_06,
  ),
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingConnectTitle,
    description: LocaleKeys.subscriptionOnboardingConnectDescription,
    icon: UntitledUI.rocket_02,
  ),
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingBoostProtectionTitle,
    description: LocaleKeys.subscriptionOnboardingBoostProtectionDescription,
    icon: UntitledUI.lock_01,
  ),
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingSearchTitle,
    description: LocaleKeys.subscriptionOnboardingSearchDescription,
    icon: UntitledUI.search_sm,
  ),
];

List<TooltipContent> get _desktopTooltipContents => [
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingMapDesktopTitle,
    description: LocaleKeys.subscriptionOnboardingMapDesktopDescription,
    icon: UntitledUI.map_01,
  ),
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingVPNLocationsTitle,
    description: LocaleKeys.subscriptionOnboardingVPNLocationsDesktopDescription,
    icon: UntitledUI.star_06,
  ),
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingManagePlanTitle,
    description: LocaleKeys.subscriptionOnboardingManagePlanDescription,
    icon: UntitledUI.rocket_02,
  ),
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingConnectTitle,
    description: LocaleKeys.subscriptionOnboardingConnectDescription,
    icon: UntitledUI.lock_01,
  ),
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingBoostProtectionTitle,
    description: LocaleKeys.subscriptionOnboardingBoostProtectionDescription,
    icon: UntitledUI.search_sm,
  ),
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingSearchTitle,
    description: LocaleKeys.subscriptionOnboardingSearchDescription,
    icon: UntitledUI.flag_01,
  ),
];
