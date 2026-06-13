import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/home_tab.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/components/dialogs/subscription_onboarding_dialog.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
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

class SubscriptionOnboardingShowcase extends StatefulHookConsumerWidget {
  const SubscriptionOnboardingShowcase({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<SubscriptionOnboardingShowcase> createState() =>
      _SubscriptionOnboardingShowcaseState();
}

class _SubscriptionOnboardingShowcaseState extends ConsumerState<SubscriptionOnboardingShowcase> {
  SubscriptionOnboardingStore get _store => ref.read(subscriptionOnboardingStorePOD);

  @override
  void dispose() {
    ShowcaseView.get().unregister();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionOnboardingStore = ref.watch<SubscriptionOnboardingStore>(
      subscriptionOnboardingStorePOD,
    );
    final canShowSubscriptionOnboarding = ref
        .watch(shouldShowSubscriptionOnboardingShowcasePOD)
        .maybeWhen(data: (value) => value, orElse: () => false);

    final startTour = useComputedValue(() => subscriptionOnboardingStore.startTour);

    useMemoized(
      () => ShowcaseView.register(
        disableBarrierInteraction: true,
        globalFloatingActionWidget: (context) => FloatingActionWidget(
          top: 50,
          right: 50,
          child: FloatingButton(
            onPressed: () {
              _store.trackSkipped();
              ShowcaseView.get().dismiss();
              _markOnboardingAsShown().ignore();
            },
            label: LocaleKeys.skipBtn.tr(),
            icon: Icons.close,
          ),
        ),
        onStart: (index, key) => _store.trackStepViewed(index),
        onComplete: (index, key) => _store.trackStepCompleted(index),
        onFinish: () {
          _store.trackFinished();
          _markOnboardingAsShown().then((_) {
            if (!context.mounted) {
              return;
            }
            showSubscriptionOnboardingCompleteDialog(context: context).ignore();
          }).ignore();
        },
      ),
      [],
    );

    useEffect(() {
      if (startTour) {
        if (!canShowSubscriptionOnboarding) {
          return;
        }

        Future.microtask(() {
          if (!mounted) {
            return;
          }

          _showPrompt().ignore();
        });
      }

      return null;
    }, [startTour, canShowSubscriptionOnboarding]);

    return widget.child;
  }

  Future<void> _markOnboardingAsShown() async {
    await _store.markShown();
    ref.invalidate(shouldShowSubscriptionOnboardingShowcasePOD);
  }

  Future<void> _showPrompt() async {
    if (!mounted) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      showSubscriptionOnboardingDialog(
        context: context,
        onStartTour: () => _startTour().ignore(),
        onCancelTour: () => _cancelTour().ignore(),
      );
    });
  }

  Future<void> _startTour() async {
    _store.trackStarted();

    ref.read(homeTabsStorePOD).trySelect(HomeTab.map);

    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) {
      return;
    }

    final keys = ref.read(homeStateProvider).subscriptionOnboardingKeys;
    ShowcaseView.get().startShowCase(keys);
  }

  Future<void> _cancelTour() async {
    _store.trackSkipped();
    await _markOnboardingAsShown();
  }
}
