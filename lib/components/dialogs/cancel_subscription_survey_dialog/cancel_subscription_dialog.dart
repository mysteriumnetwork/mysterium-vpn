import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/extensions/list.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/subscription_cancellation_store.dart';
import 'package:mysterium_vpn_design/styles/design_system.dart';
import 'package:mysterium_vpn_design/utils/screen_type.dart';
import 'package:mysterium_vpn_design/widgets/button.dart';
import 'package:mysterium_vpn_design/widgets/checkbox_item.dart';
import 'package:mysterium_vpn_design/widgets/modals/alert_modal.dart';
import 'package:mysterium_vpn_design/widgets/modals/bottom_sheet_dialog.dart';
import 'package:mysterium_vpn_design/widgets/modals/show_modal.dart';
import 'package:mysterium_vpn_design/widgets/radio_button.dart';
import 'package:reactive_forms/reactive_forms.dart';

part 'form.dart';
part 'radio_option_form.dart';
part 'reasons_field.dart';

Future<void> showCancelSubscriptionFlowDialog(BuildContext context) async =>
    showModal(context, builder: (context) => const _CancelSubscriptionFlowDialog());

class _CancelSubscriptionFlowDialog extends HookConsumerWidget {
  const _CancelSubscriptionFlowDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionCancellationStore = ref.watch(subscriptionCancellationStorePOD);
    final cancellationStep = useComputedValue(
      () => subscriptionCancellationStore.cancellationFlowStep,
    );

    useEffect(() => subscriptionCancellationStore.reset, []);

    return switch (cancellationStep) {
      SubscriptionCancellationFlow.prompt => _Prompt(
        onContinuePressed: () async => subscriptionCancellationStore.moveToNextStep(),
      ),
      SubscriptionCancellationFlow.survey => const _Survey(),
      SubscriptionCancellationFlow.freeze => const _FreezeDuration(),
      SubscriptionCancellationFlow.offer => const Placeholder(),
      SubscriptionCancellationFlow.confirmation => const Placeholder(),
      SubscriptionCancellationFlow.summary => const Placeholder(),
    };
  }
}

class _Prompt extends StatelessWidget {
  const _Prompt({required this.onContinuePressed});

  final VoidCallback onContinuePressed;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 343),
    child: AlertModal(
      title: 'Cancel subscription',
      supportingText: 'Are you sure you want to cancel your subscription?',
      type: AlertModalType.warning,
      screenType: ScreenType.mobile,
      primaryButton: ButtonPrimary(onPressed: onContinuePressed, child: const Text('Continue')),
      secondaryButton: ButtonSecondary(
        onPressed: () async => Navigator.pop(context),
        child: const Text('Keep subscription'),
      ),
    ),
  );
}

class _Survey extends HookConsumerWidget {
  const _Survey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remoteConfigStore = ref.watch(remoteConfigStorePOD);
    final cancelSubscriptionStore = ref.read(subscriptionCancellationStorePOD);

    final reasons = useComputedValue(() {
      final keys = remoteConfigStore.cancelSubscriptionReasonKeys?.shuffled();
      keys?.remove(kCancelReasonOther);
      return {...?keys, kCancelReasonOther};
    });

    final form = _useForm();

    void handleSkip() {
      cancelSubscriptionStore.moveToNextStep();
    }

    void handleSubmit() {
      cancelSubscriptionStore.setSurvey(
        reasons: form.reasons.value ?? {},
        feedback: form.feedback.value?.trim(),
      );
    }

    return Material(
      child: BottomSheetDialog(
        title: LocaleKeys.cancelSurveyTitle.tr(),
        body: _Form(form: form, items: reasons),
        primaryButton: Observer(
          builder: (context) {
            final isProcessing = cancelSubscriptionStore.isProcessing;
            return ButtonPrimary(
              onPressed: isProcessing ? () {} : handleSubmit,
              child: isProcessing
                  ? const CircularProgressIndicator.adaptive()
                  : Text(LocaleKeys.submitBtn.tr()),
            );
          },
        ),
        secondaryButton: ButtonSecondary(
          onPressed: handleSkip,
          child: Text(LocaleKeys.skipBtn.tr()),
        ),
      ),
    );
  }
}

class _FreezeDuration extends HookConsumerWidget {
  const _FreezeDuration();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cancelSubscriptionStore = ref.read(subscriptionCancellationStorePOD);

    void handleSkip() {
      cancelSubscriptionStore.moveToNextStep();
    }

    void handleSubmit() {
      cancelSubscriptionStore.setFreezeDuration(
        reasons: form ?? {},
        feedback: form.feedback.value?.trim(),
      );
    }

    return Material(
      child: BottomSheetDialog(
        title: 'Freeze subscription',
        body: RadioOptionForm(form: form, items: durations),
        primaryButton: Observer(
          builder: (context) {
            final isProcessing = cancelSubscriptionStore.isProcessing;
            return ButtonPrimary(
              onPressed: form.invalid || isProcessing ? null : handleSubmit,
              child: isProcessing
                  ? const CircularProgressIndicator.adaptive()
                  : Text(LocaleKeys.submitBtn.tr()),
            );
          },
        ),
        secondaryButton: ButtonSecondary(
          onPressed: handleSkip,
          child: Text(LocaleKeys.skipBtn.tr()),
        ),
      ),
    );
  }
}
