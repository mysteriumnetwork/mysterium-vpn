import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/home_tab.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/components/dialogs/subscription_onboarding_dialog.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/home_tabs_store.dart';
import 'package:mysterium_vpn/stores/subscription_onboarding_store.dart';
import 'package:mysterium_vpn/views/home/home_state.dart';
import 'package:mysterium_vpn_design/widgets/floating_button.dart';
import 'package:showcaseview/showcaseview.dart';

final shouldShowSubscriptionOnboardingShowcasePOD = FutureProvider<bool>((ref) async {
  if (!ref.watch(remoteConfigStorePOD).canShowSubscriptionOnboardingFlow) {
    return false;
  }

  return ref.watch(subscriptionOnboardingStorePOD).shouldShow();
});

class SubscriptionOnboardingShowcase extends HookConsumerWidget {
  const SubscriptionOnboardingShowcase({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionOnboardingStore = ref.watch<SubscriptionOnboardingStore>(
      subscriptionOnboardingStorePOD,
    );
    final homeTabsStore = ref.watch<HomeTabsStore>(homeTabsStorePOD);
    final homeState = ref.watch(homeStateProvider);

    final shouldRegisterShowcase = ref
        .watch(shouldShowSubscriptionOnboardingShowcasePOD)
        .maybeWhen(data: (value) => value, orElse: () => false);

    final startTour = useComputedValue(() => subscriptionOnboardingStore.startTour);

    useEffect(() {
      if (shouldRegisterShowcase) {
        ShowcaseView.register(
          disableBarrierInteraction: true,
          globalFloatingActionWidget: (context) => FloatingActionWidget(
            top: 50,
            right: 50,
            child: FloatingButton(
              onPressed: () {
                subscriptionOnboardingStore.markShown().ignore();
                subscriptionOnboardingStore.trackSkipped();
                ShowcaseView.get().dismiss();
              },
              label: LocaleKeys.skipBtn.tr(),
              icon: Icons.close,
            ),
          ),
          onStart: (index, key) => subscriptionOnboardingStore.trackStepViewed(index),
          onComplete: (index, key) => subscriptionOnboardingStore.trackStepCompleted(index),
          onFinish: () {
            subscriptionOnboardingStore.trackFinished();
            showSubscriptionOnboardingCompleteDialog(context: context).ignore();
          },
        );
      }

      // Unregister the showcase if it is not enabled
      return shouldRegisterShowcase ? ShowcaseView.get().unregister : null;
    }, [shouldRegisterShowcase]);

    // Show the prompt to start the tour
    useEffect(() {
      if (startTour) {
        Future.microtask(() {
          if (!context.mounted) {
            return;
          }

          subscriptionOnboardingStore.didShowSubscriptionOnboarding();

          _showPrompt(
            context: context,
            store: subscriptionOnboardingStore,
            homeTabsStore: homeTabsStore,
            keys: homeState.subscriptionOnboardingKeys,
          ).then((_) => ref.invalidate(shouldShowSubscriptionOnboardingShowcasePOD)).ignore();
        });
      }

      return null;
    }, [startTour]);

    return child;
  }

  // Show the prompt to start the tour
  Future<void> _showPrompt({
    required BuildContext context,
    required SubscriptionOnboardingStore store,
    required HomeTabsStore homeTabsStore,
    required List<GlobalKey<State<StatefulWidget>>> keys,
  }) async {
    await store.markShown();

    if (!context.mounted) {
      return;
    }

    await showSubscriptionOnboardingDialog(
      context: context,
      onStartTour: () => _startTour(
        context: context,
        store: store,
        homeTabsStore: homeTabsStore,
        keys: keys,
      ).ignore(),
      onCancelTour: () => _cancelTour(store: store).ignore(),
    );
  }

  // Start the tour
  Future<void> _startTour({
    required BuildContext context,
    required SubscriptionOnboardingStore store,
    required HomeTabsStore homeTabsStore,
    required List<GlobalKey<State<StatefulWidget>>> keys,
  }) async {
    store.trackStarted();

    homeTabsStore.trySelect(HomeTab.map);

    await Future.delayed(const Duration(milliseconds: 200));
    if (!context.mounted) {
      return;
    }

    ShowcaseView.get().startShowCase(keys);
  }

  // Cancel the tour
  Future<void> _cancelTour({required SubscriptionOnboardingStore store}) async {
    await store.markShown();
    store.trackSkipped();
  }
}
