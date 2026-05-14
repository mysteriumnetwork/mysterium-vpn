import 'dart:math';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/step_controller_hook.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

part 'comparison_step.dart';
part 'connection_widgets.dart';
part 'exposed_step.dart';
part 'layout_constants.dart';
part 'map_backdrop.dart';
part 'protected_step.dart';
part 'step_footer.dart';

// ─── Steps ────────────────────────────────────────────────────────────────────

enum _Step {
  exposed(
    title: LocaleKeys.onboardingStep1Title,
    desc: LocaleKeys.onboardingStep1Desc,
    accent: Color(0xFFDE3B3D),
    content: _ExposedStep(),
  ),
  protected(
    title: LocaleKeys.onboardingStep2Title,
    desc: LocaleKeys.onboardingStep2Desc,
    accent: Color(0xFF28AA6E),
    content: _ProtectedStep(),
  ),
  comparison(
    title: LocaleKeys.onboardingStep3Title,
    desc: LocaleKeys.onboardingStep3Desc,
    accent: Color(0xFFDA78FA),
    content: _ComparisonStep(),
  );

  const _Step({
    required this.title,
    required this.desc,
    required this.accent,
    required this.content,
  });

  final String title;
  final String desc;
  final Color accent;
  final Widget content;
}

// ─── Hooks ────────────────────────────────────────────────────────────────────

void Function(AnalyticsEvent event) _useOnboardingAnalytics(int step) {
  final store = useProvider<AnalyticsStore>(analyticsStorePOD);

  useEffect(() {
    store.logEvent(AnalyticsEvent.onboardingShown);
    return null;
  }, const []);

  useEffect(() {
    store.logEvent(AnalyticsEvent.onboardingStepView, parameters: {'step': step + 1});
    return null;
  }, [step]);

  return (event) {
    final params = event == AnalyticsEvent.onboardingSeePlansClick ? null : {'step': step + 1};
    store.logEvent(event, parameters: params);
  };
}

// ─── Entry point ──────────────────────────────────────────────────────────────

/// Opens the non-subscriber onboarding dialog. [initialStep] is the step to
/// resume from — pass the value persisted by
/// [UserPreferencesStore.getNoneSubsOnboardingStep] so an interrupted flow
/// picks up where it left off.
Future<void> showOnboardingDialog(BuildContext context, {int initialStep = 0}) => showDialog(
  context: context,
  barrierDismissible: false,
  useSafeArea: false,
  builder: (_) => _OnboardingDialog(initialStep: initialStep),
);

// ─── Dialog ───────────────────────────────────────────────────────────────────

class _OnboardingDialog extends HookWidget {
  const _OnboardingDialog({required this.initialStep});

  final int initialStep;

  @override
  Widget build(BuildContext context) {
    final userPreferences = useProvider<UserPreferencesStore>(userPreferencesStorePOD);
    // Clamp the persisted step in case the step count has shrunk since it
    // was last saved (e.g. removed step in a future build).
    final safeInitialStep = initialStep.clamp(0, _Step.values.length - 1);
    final controller = useStepController(
      _Step.values.length,
      initialStep: safeInitialStep,
      onStepChange: userPreferences.setNoneSubsOnboardingStep,
    );
    final step = _Step.values[controller.step];
    final track = _useOnboardingAnalytics(controller.step);
    final handleSubscribe = useHandleSubscribe();

    void onClose() {
      track(AnalyticsEvent.onboardingCloseClick);
      Navigator.of(context).pop();
    }

    void onBack() {
      track(AnalyticsEvent.onboardingBackClick);
      controller.back();
    }

    Future<void> onContinue() async {
      if (controller.isLast) {
        track(AnalyticsEvent.onboardingSeePlansClick);
        Navigator.of(context).pop();
        await handleSubscribe();
        return;
      }
      track(AnalyticsEvent.onboardingContinueClick);
      controller.next();
    }

    return Dialog.fullscreen(
      backgroundColor: Theme.of(context).palette.bgSidePanel,
      child: _OnboardingContent(
        step: step,
        onClose: onClose,
        onBack: onBack,
        onContinue: onContinue,
      ),
    );
  }
}

class _OnboardingContent extends StatelessWidget {
  const _OnboardingContent({
    required this.step,
    required this.onClose,
    required this.onBack,
    required this.onContinue,
  });

  final _Step step;
  final VoidCallback onClose;
  final VoidCallback onBack;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final isMobile = _isCompact(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        _MapBackdrop(step: step),
        Column(
          children: [
            Header.logo(
              backgroundColor: Palette.transparent,
              showBackButton: step.index > 0,
              onBackPressed: onBack,
              centerTitle: true,
              actions: [
                IconButton(onPressed: onClose, icon: const Icon(UntitledUI.x_close, size: 24)),
              ],
            ),
            Expanded(
              child: _OnboardingBody(step: step, isMobile: isMobile, onContinue: onContinue),
            ),
          ],
        ),
      ],
    );
  }
}

/// Scrollable body that fills the remaining viewport when content fits and
/// scrolls when the viewport is shorter than the content.
class _OnboardingBody extends StatelessWidget {
  const _OnboardingBody({required this.step, required this.isMobile, required this.onContinue});

  final _Step step;
  final bool isMobile;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).spacing;
    final hPad = isMobile ? spacing.xl2 : spacing.xl3;
    final topGap = isMobile ? _kHeaderContentGapMobile : _kHeaderContentGapDesktop;
    final isLast = step == _Step.values.last;
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Padding(
            padding: EdgeInsets.fromLTRB(hPad, topGap, hPad, spacing.xl3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                step.content,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _StepCopy(step: step, isMobile: isMobile),
                    SizedBox(height: spacing.xl3),
                    _ContinueButton(
                      isMobile: isMobile,
                      onPressed: onContinue,
                      label: isLast ? LocaleKeys.seePlansBtn.tr() : LocaleKeys.continueBtn.tr(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
