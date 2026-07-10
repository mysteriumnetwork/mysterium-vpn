import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/step_controller_hook.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
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
  exposed(accent: Color(0xFFDE3B3D), content: _ExposedStep()),
  protected(accent: Color(0xFF28AA6E), content: _ProtectedStep()),
  comparison(accent: Color(0xFFDA78FA), content: _ComparisonStep());

  const _Step({required this.accent, required this.content});

  final Color accent;
  final Widget content;

  String get title => switch (this) {
    _Step.exposed => S.current.onboardingStep1Title,
    _Step.protected => S.current.onboardingStep2Title,
    _Step.comparison => S.current.onboardingStep3Title,
  };

  String get desc => switch (this) {
    _Step.exposed => S.current.onboardingStep1Desc,
    _Step.protected => S.current.onboardingStep2Desc,
    _Step.comparison => S.current.onboardingStep3Desc,
  };
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
///
/// Resolves with `true` when the user finishes the last step and taps "See
/// Plans" — the caller is expected to invoke the subscribe flow afterward
/// using its own (still-mounted) context. Resolves with `null` for any other
/// close path (X tap, system back).
Future<bool?> showOnboardingDialog(BuildContext context, {int initialStep = 0}) => showDialog<bool>(
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
    // True when the dialog is popped via an in-dialog CTA (X button or last
    // step's "See Plans"). The [PopScope] handler uses it to recognise the
    // remaining pop path (system back / predictive back) and fire the close
    // analytics event for it — without this flag the X path would
    // double-fire (once from [onClose], once from the handler).
    final closedExplicitly = useRef(false);

    void onClose() {
      closedExplicitly.value = true;
      track(AnalyticsEvent.onboardingCloseClick);
      Navigator.of(context).pop();
    }

    void onBack() {
      track(AnalyticsEvent.onboardingBackClick);
      controller.back();
    }

    void onContinue() {
      if (controller.isLast) {
        closedExplicitly.value = true;
        track(AnalyticsEvent.onboardingSeePlansClick);
        // Pop with `true` so the caller can run `handleSubscribe()` on a
        // still-mounted parent context — invoking it here would race with
        // the route disposal and leave the subscribe page unmounted.
        Navigator.of(context).pop(true);
        return;
      }
      track(AnalyticsEvent.onboardingContinueClick);
      controller.next();
    }

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop && !closedExplicitly.value) {
          track(AnalyticsEvent.onboardingCloseClick);
        }
      },
      child: Dialog.fullscreen(
        key: K.onboardingDialog,
        backgroundColor: Theme.of(context).palette.bgSidePanel,
        child: _OnboardingContent(
          step: step,
          onClose: onClose,
          onBack: onBack,
          onContinue: onContinue,
        ),
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
                IconButton(
                  key: K.onboardingCloseButton,
                  onPressed: onClose,
                  icon: const Icon(UntitledUI.x_close, size: 24),
                ),
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
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final isLast = step == _Step.values.last;

    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Padding(
            padding: EdgeInsets.fromLTRB(hPad, topGap, hPad, spacing.xl3 + bottomInset),
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
                      key: K.onboardingContinueButton,
                      isMobile: isMobile,
                      onPressed: onContinue,
                      label: isLast ? S.current.seePlansBtn : S.current.continueBtn,
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
