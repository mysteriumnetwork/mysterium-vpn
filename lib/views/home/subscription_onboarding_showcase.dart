import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/components/dialogs/subscription_onboarding_dialog.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/tooltip_content.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/home_tabs_store.dart';
import 'package:mysterium_vpn/stores/subscription_onboarding_store.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:showcaseview/showcaseview.dart';

const _subscriptionOnboardingScope = 'subscription-onboarding-scope';

enum SubscriptionOnboardingStep { map, locations, products, settings, connect, search }

final subscriptionOnboardingShowcaseControllerPOD = Provider<SubscriptionOnboardingShowcaseController>(
  (ref) => throw StateError(
    'subscriptionOnboardingShowcaseControllerPOD must be overridden by SubscriptionOnboardingShowcase.',
  ),
);

class SubscriptionOnboardingShowcase extends ConsumerStatefulWidget {
  const SubscriptionOnboardingShowcase({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<SubscriptionOnboardingShowcase> createState() =>
      _SubscriptionOnboardingShowcaseState();
}

class _SubscriptionOnboardingShowcaseState extends ConsumerState<SubscriptionOnboardingShowcase> {
  late final SubscriptionOnboardingShowcaseController _controller;
  late final ShowcaseView _showcaseView;
  late final Map<SubscriptionOnboardingStep, GlobalKey<State<StatefulWidget>>> _keys;

  SubscriptionOnboardingStore get _store => ref.read(subscriptionOnboardingStorePOD);
  HomeTabsStore get _homeTabsStore => ref.read(homeTabsStorePOD);

  @override
  void initState() {
    super.initState();
    _controller = SubscriptionOnboardingShowcaseController._(this);
    _keys = {
      for (final step in SubscriptionOnboardingStep.values)
        step: GlobalKey<State<StatefulWidget>>(),
    };
    _showcaseView = ShowcaseView.register(
      scope: _subscriptionOnboardingScope,
      disableBarrierInteraction: true,
      globalFloatingActionWidget: (_) => FloatingActionWidget(
        top: 50,
        right: 50,
        child: FloatingButton(
          onPressed: _skipTour,
          label: LocaleKeys.skipBtn.tr(),
          icon: Icons.close,
        ),
      ),
      onStart: (index, key) => _store.trackStepViewed(index),
      onComplete: (index, key) => _store.trackStepCompleted(index),
      onFinish: _finishTour,
    );
  }

  @override
  Widget build(BuildContext context) => ProviderScope(
    overrides: [subscriptionOnboardingShowcaseControllerPOD.overrideWithValue(_controller)],
    child: widget.child,
  );

  @override
  void dispose() {
    _showcaseView.unregister();
    super.dispose();
  }

  ScreenType get _screenType => ScreenType.of(context);

  List<SubscriptionOnboardingStepSpec> get _orderedSteps =>
      subscriptionOnboardingStepsFor(_screenType);

  List<GlobalKey<State<StatefulWidget>>> get _orderedKeys => [
    for (final spec in _orderedSteps) _keys[spec.step]!,
  ];

  Future<void> _showPrompt(BuildContext context) async {
    if (!context.mounted) {
      return;
    }

    await showSubscriptionOnboardingDialog(
      context: context,
      onStartTour: () => _startTourFromPrompt().ignore(),
      onCancelTour: () => _store.skipPrompt().ignore(),
    );
  }

  Future<void> _startTourFromPrompt() async {
    await _store.acceptPrompt();
    if (!mounted) {
      return;
    }

    await _startTour();
  }

  Future<void> _startTour() async {
    _homeTabsStore.trySelect(HomeTab.map);

    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) {
      return;
    }

    _showcaseView.startShowCase(_orderedKeys);
  }

  void _next() => _showcaseView.next();

  void _skipTour() {
    _store.skipTour();
    _showcaseView.dismiss();
  }

  void _finishTour() {
    _store.completeTour();
    if (!mounted) {
      return;
    }
    showSubscriptionOnboardingCompleteDialog(context: context).ignore();
  }

  SubscriptionOnboardingTarget _targetForStep(SubscriptionOnboardingStep step) {
    final specs = _orderedSteps;
    final index = specs.indexWhere((spec) => spec.step == step);
    assert(index != -1, 'Missing subscription onboarding step: $step');

    final effectiveIndex = index.clamp(0, specs.length - 1);
    final spec = specs[effectiveIndex];

    return SubscriptionOnboardingTarget(
      key: _keys[step]!,
      spec: spec,
      index: effectiveIndex,
      totalSteps: specs.length,
      scope: _subscriptionOnboardingScope,
    );
  }
}

class SubscriptionOnboardingShowcaseController {
  SubscriptionOnboardingShowcaseController._(this._state);

  final _SubscriptionOnboardingShowcaseState _state;

  String get scope => _subscriptionOnboardingScope;

  int get visibleStepsCount => _state._orderedSteps.length;

  SubscriptionOnboardingTarget targetForTab(HomeTab tab) => targetForStep(switch (tab) {
    HomeTab.map => SubscriptionOnboardingStep.map,
    HomeTab.locations => SubscriptionOnboardingStep.locations,
    HomeTab.products => SubscriptionOnboardingStep.products,
    HomeTab.settings => SubscriptionOnboardingStep.settings,
  });

  SubscriptionOnboardingTarget targetForStep(SubscriptionOnboardingStep step) =>
      _state._targetForStep(step);

  Future<void> showPrompt(BuildContext context) => _state._showPrompt(context);

  void next() => _state._next();
}

class SubscriptionOnboardingTarget {
  const SubscriptionOnboardingTarget({
    required this.key,
    required this.spec,
    required this.index,
    required this.totalSteps,
    required this.scope,
  });

  final GlobalKey<State<StatefulWidget>> key;
  final SubscriptionOnboardingStepSpec spec;
  final int index;
  final int totalSteps;
  final String scope;
}

class SubscriptionOnboardingStepSpec {
  const SubscriptionOnboardingStepSpec({
    required this.step,
    required this.content,
    required this.position,
  });

  final SubscriptionOnboardingStep step;
  final TooltipContent content;
  final TooltipPosition position;
}

List<SubscriptionOnboardingStepSpec> subscriptionOnboardingStepsFor(ScreenType screenType) =>
    switch (screenType) {
      ScreenType.watch || ScreenType.mobile => _mobileSteps,
      ScreenType.tablet || ScreenType.desktop => _desktopSteps,
    };

List<SubscriptionOnboardingStepSpec> get _mobileSteps => [
  SubscriptionOnboardingStepSpec(
    step: SubscriptionOnboardingStep.map,
    position: TooltipPosition.top,
    content: TooltipContent(
      title: LocaleKeys.subscriptionOnboardingMapMobileTitle,
      description: LocaleKeys.subscriptionOnboardingMapMobileDescription,
      icon: UntitledUI.map_01,
    ),
  ),
  SubscriptionOnboardingStepSpec(
    step: SubscriptionOnboardingStep.locations,
    position: TooltipPosition.top,
    content: TooltipContent(
      title: LocaleKeys.subscriptionOnboardingVPNLocationsTitle,
      description: LocaleKeys.subscriptionOnboardingVPNLocationsMobileDescription,
      icon: UntitledUI.flag_01,
    ),
  ),
  SubscriptionOnboardingStepSpec(
    step: SubscriptionOnboardingStep.products,
    position: TooltipPosition.top,
    content: TooltipContent(
      title: LocaleKeys.subscriptionOnboardingManagePlanTitle,
      description: LocaleKeys.subscriptionOnboardingManagePlanDescription,
      icon: UntitledUI.star_06,
    ),
  ),
  SubscriptionOnboardingStepSpec(
    step: SubscriptionOnboardingStep.settings,
    position: TooltipPosition.top,
    content: TooltipContent(
      title: LocaleKeys.subscriptionOnboardingBoostProtectionTitle,
      description: LocaleKeys.subscriptionOnboardingBoostProtectionDescription,
      icon: UntitledUI.lock_01,
    ),
  ),
  SubscriptionOnboardingStepSpec(
    step: SubscriptionOnboardingStep.connect,
    position: TooltipPosition.top,
    content: TooltipContent(
      title: LocaleKeys.subscriptionOnboardingConnectTitle,
      description: LocaleKeys.subscriptionOnboardingConnectDescription,
      icon: UntitledUI.rocket_02,
    ),
  ),
  SubscriptionOnboardingStepSpec(
    step: SubscriptionOnboardingStep.search,
    position: TooltipPosition.bottom,
    content: TooltipContent(
      title: LocaleKeys.subscriptionOnboardingSearchTitle,
      description: LocaleKeys.subscriptionOnboardingSearchDescription,
      icon: UntitledUI.search_sm,
    ),
  ),
];

List<SubscriptionOnboardingStepSpec> get _desktopSteps => [
  SubscriptionOnboardingStepSpec(
    step: SubscriptionOnboardingStep.map,
    position: TooltipPosition.right,
    content: TooltipContent(
      title: LocaleKeys.subscriptionOnboardingMapDesktopTitle,
      description: LocaleKeys.subscriptionOnboardingMapDesktopDescription,
      icon: UntitledUI.map_01,
    ),
  ),
  SubscriptionOnboardingStepSpec(
    step: SubscriptionOnboardingStep.products,
    position: TooltipPosition.right,
    content: TooltipContent(
      title: LocaleKeys.subscriptionOnboardingManagePlanTitle,
      description: LocaleKeys.subscriptionOnboardingManagePlanDescription,
      icon: UntitledUI.star_06,
    ),
  ),
  SubscriptionOnboardingStepSpec(
    step: SubscriptionOnboardingStep.settings,
    position: TooltipPosition.right,
    content: TooltipContent(
      title: LocaleKeys.subscriptionOnboardingBoostProtectionTitle,
      description: LocaleKeys.subscriptionOnboardingBoostProtectionDescription,
      icon: UntitledUI.lock_01,
    ),
  ),
  SubscriptionOnboardingStepSpec(
    step: SubscriptionOnboardingStep.connect,
    position: TooltipPosition.top,
    content: TooltipContent(
      title: LocaleKeys.subscriptionOnboardingConnectTitle,
      description: LocaleKeys.subscriptionOnboardingConnectDescription,
      icon: UntitledUI.rocket_02,
    ),
  ),
  SubscriptionOnboardingStepSpec(
    step: SubscriptionOnboardingStep.search,
    position: TooltipPosition.bottom,
    content: TooltipContent(
      title: LocaleKeys.subscriptionOnboardingSearchTitle,
      description: LocaleKeys.subscriptionOnboardingSearchDescription,
      icon: UntitledUI.search_sm,
    ),
  ),
  SubscriptionOnboardingStepSpec(
    step: SubscriptionOnboardingStep.locations,
    position: TooltipPosition.top,
    content: TooltipContent(
      title: LocaleKeys.subscriptionOnboardingVPNLocationsTitle,
      description: LocaleKeys.subscriptionOnboardingVPNLocationsDesktopDescription,
      icon: UntitledUI.flag_01,
    ),
  ),
];
