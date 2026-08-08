import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/components/dialogs/dialogs.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/l10n/tr_bridge.dart';
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

    final reasons = useComputedValue(() {
      final keys = remoteConfigStore.cancelSubscriptionReasonKeys?.shuffled();
      keys?.remove(kCancelReasonOther);
      return {...?keys, kCancelReasonOther};
    });

    final form = _useForm();

    void handleDismiss() {
      cancelSubscriptionStore.reset();
      Navigator.of(context).pop();
    }

    Future<void> proceed() async {
      final canPause = await cancelSubscriptionStore.canPauseSubscription();
      if (!context.mounted) {
        return;
      }

      final navigator = Navigator.of(context, rootNavigator: true)..pop();

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

    final title = '${S.current.cancelSurveyTitle} (${S.current.optional})';

    return ModalScaffold(
      showGradient: false,
      onModalClose: handleDismiss,
      appbar: ModalAppbar(title: title, onModalClose: handleDismiss),
      footer: CancelSubscriptionActionFooter(
        primaryButtonLabel: S.current.continueBtn,
        onPrimaryButtonPressed: handleSubmit,
        secondaryButtonLabel: S.current.skipBtn,
        onSecondaryButtonPressed: handleSkip,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(theme.spacing.xl2),
        child: _Form(form: form, items: reasons),
      ),
    );
  }
}
