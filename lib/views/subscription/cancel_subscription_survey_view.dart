import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/ui/ui.dart';
import 'package:mysterium_vpn/common/utils/platform.dart';
import 'package:mysterium_vpn/components/dialogs/dialogs.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/l10n/tr_bridge.dart';
import 'package:mysterium_vpn/providers/service_providers.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/subscription/widgets/cancel_subscription_action_footer.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:reactive_forms/reactive_forms.dart';

part 'widgets/cancel_subscription_form.dart';
part 'widgets/cancel_subscription_reasons_field.dart';

/// Cancellation survey. After continue/skip it should ask the store whether
/// pause is available otherwise it opens the web confirmation prompt.
class CancelSubscriptionSurveyView extends HookConsumerWidget {
  const CancelSubscriptionSurveyView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final remoteConfigStore = ref.watch(remoteConfigStorePOD);
    final cancelSubscriptionStore = ref.read(subscriptionCancellationStorePOD);
    final analyticsStore = ref.read(analyticsStorePOD);
    final logger = ref.read(loggerPOD);

    final reasons = useComputedValue(() {
      final keys = remoteConfigStore.cancelSubscriptionReasonKeys?.shuffled();
      keys?.remove(kCancelReasonOther);
      return {...?keys, kCancelReasonOther};
    });

    final form = _useForm();
    // Null while idle, otherwise which footer button is running (true = skip).
    final pending = useState<bool?>(null);
    final isBusy = pending.value != null;

    void handleDismiss() {
      if (isBusy) {
        return;
      }
      cancelSubscriptionStore.reset();
      Navigator.of(context).pop();
    }

    Future<void> proceed() async {
      final canPause = await cancelSubscriptionStore.canPauseSubscription();
      if (!context.mounted) {
        return;
      }

      final navigator = Navigator.of(context, rootNavigator: true);
      // Not current means the user already left; handing off to the next step
      // would pop whatever they went to.
      if (!popIfCurrent(context)) {
        cancelSubscriptionStore.reset();
        return;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!navigator.mounted) {
          cancelSubscriptionStore.reset();
          return;
        }

        if (canPause) {
          await showSubscriptionPauseDialog(navigator.context);
          return;
        }

        if (cancelSubscriptionStore.isStoreSubscription()) {
          await openCancelSubscriptionLink(
            navigator.context,
            store: cancelSubscriptionStore,
            analyticsStore: analyticsStore,
          );
        } else {
          await showContinueToWebPrompt(
            context: navigator.context,
            onContinuePressed: () => openCancelSubscriptionLink(
              navigator.context,
              store: cancelSubscriptionStore,
              analyticsStore: analyticsStore,
            ),
          );
        }
        cancelSubscriptionStore.reset();
      });
    }

    Future<void> handleSkip() async {
      analyticsStore.logCancellationReasonSkipped().ignore();
      await proceed();
    }

    Future<void> handleSubmit() async {
      final submitted = await cancelSubscriptionStore.setSurvey(
        reasons: form.reasons.value ?? {},
        feedback: form.feedback.value?.trim(),
      );
      if (!submitted) {
        analyticsStore.logCancellationReasonSkipped().ignore();
      }
      if (!context.mounted) {
        return;
      }
      await proceed();
    }

    // First press across both buttons wins; re-enables on failure, since
    // proceed() awaits the subscription fetch and that can throw.
    Future<void> runOnce({required bool secondary}) async {
      if (pending.value != null) {
        return;
      }
      pending.value = secondary;
      try {
        await (secondary ? handleSkip() : handleSubmit());
      } catch (e, stack) {
        logger.warning('Cancellation survey action failed', e, stack);
        if (context.mounted) {
          pending.value = null;
          showSnackbar(S.current.somethingWentWrong);
        }
      }
    }

    final title = '${S.current.cancelSurveyTitle} (${S.current.optional})';

    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return PopScope(
      canPop: !isBusy,
      child: Padding(
        padding: EdgeInsets.only(bottom: keyboardInset),
        child: ModalScaffold(
          showGradient: false,
          onModalClose: handleDismiss,
          appbar: isDesktop()
              ? ModalAppbar(title: title, onModalClose: handleDismiss)
              : Header(
                  backgroundColor: theme.palette.bgPopover,
                  backLabel: S.current.back,
                  showBackButton: true,
                  onBackPressed: handleDismiss,
                ),
          footer: CancelSubscriptionActionFooter(
            primaryButtonLabel: S.current.continueBtn,
            onPrimaryButtonPressed: () => runOnce(secondary: false),
            secondaryButtonLabel: S.current.skipBtn,
            onSecondaryButtonPressed: () => runOnce(secondary: true),
            isProcessing: isBusy,
            processingIsSecondary: pending.value ?? false,
          ),
          body: SingleChildScrollView(
            padding: isDesktop()
                ? EdgeInsets.all(theme.spacing.xl2)
                : EdgeInsets.symmetric(horizontal: theme.spacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isDesktop()) ...[
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: S.current.cancelSurveyTitle,
                          style: theme.textStyles.textLg.semibold.copyWith(
                            fontSize: 24,
                            color: theme.palette.textPrimary,
                          ),
                        ),
                        TextSpan(
                          text: ' (${S.current.optional})',
                          style: theme.textStyles.textMd.medium.copyWith(
                            color: theme.palette.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: theme.spacing.xl2),
                ],
                _Form(form: form, items: reasons),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
