import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/l10n/tr_bridge.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/subscription_cancellation_store.dart';
import 'package:mysterium_vpn_design/icons/untitled_ui.dart';
import 'package:mysterium_vpn_design/styles/design_system.dart';
import 'package:mysterium_vpn_design/utils/screen_type.dart';
import 'package:mysterium_vpn_design/widgets/button.dart';
import 'package:mysterium_vpn_design/widgets/checkbox_item.dart';
import 'package:mysterium_vpn_design/widgets/decorated_icon.dart';
import 'package:mysterium_vpn_design/widgets/modals/alert_modal.dart';
import 'package:mysterium_vpn_design/widgets/modals/modal_header.dart';
import 'package:mysterium_vpn_design/widgets/modals/modal_padding.dart';
import 'package:mysterium_vpn_design/widgets/modals/modal_scaffold.dart';
import 'package:mysterium_vpn_design/widgets/modals/show_modal.dart';
import 'package:mysterium_vpn_design/widgets/plan_card.dart';
import 'package:mysterium_vpn_design/widgets/plan_card/plan_data.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:styled_widget/styled_widget.dart';

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
      SubscriptionCancellationFlow.offer => const _Offer(),
      SubscriptionCancellationFlow.confirmation => const _Confirmation(),
      SubscriptionCancellationFlow.summary => const _Summary(),
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
      title: S.current.cancelSubscriptionTitle,
      supportingText: S.current.cancelSubscriptionPromptDesc,
      type: AlertModalType.warning,
      screenType: ScreenType.mobile,
      primaryButton: ButtonPrimary(
        onPressed: onContinuePressed,
        child: Text(S.current.continueBtn),
      ),
      secondaryButton: ButtonSecondary(
        onPressed: () async => Navigator.pop(context),
        child: Text(S.current.keepSubscriptionBtn),
      ),
    ),
  );
}

class _Survey extends HookConsumerWidget {
  const _Survey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
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

    return ModalScaffold(
      appbar: _createAppBar(context: context, title: S.current.cancelSurveyTitle),
      showGradient: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(theme.spacing.xl2),
          child: _Form(form: form, items: reasons),
        ),
      ),
      footer: _ActionFooter(
        primaryButtonLabel: S.current.continueBtn,
        onPrimaryButtonPressed: handleSubmit,
        secondaryButtonLabel: S.current.skipBtn,
        onSecondaryButtonPressed: handleSkip,
      ),
    );
  }
}

class _FreezeDuration extends HookConsumerWidget {
  const _FreezeDuration();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cancelSubscriptionStore = ref.read(subscriptionCancellationStorePOD);
    final form = _useRadioForm();
    final showError = useState(false);

    void handleSkip() {
      cancelSubscriptionStore.moveToNextStep();
    }

    void handleSubmit() {
      if (form.invalid) {
        showError.value = true;
        return;
      }
      showError.value = false;
      cancelSubscriptionStore.setFreezeDuration(form.freezeDuration.value!);
    }

    return ModalScaffold(
      showGradient: false,
      appbar: _createAppBar(context: context, title: S.current.notReadyToCancelTitle),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: theme.spacing.xl2),
            _RadioOptionForm(
              form: form,
              freezeDurations: cancelSubscriptionStore.freezeDurations,
              showError: showError.value,
            ),
          ],
        ),
      ),
      footer: Observer(
        builder: (context) => _ActionFooter(
          primaryButtonLabel: S.current.pauseSubscriptionBtn,
          isProcessing: cancelSubscriptionStore.isProcessing,
          onPrimaryButtonPressed: handleSubmit,
          secondaryButtonLabel: S.current.continueToCancelBtn,
          onSecondaryButtonPressed: handleSkip,
        ),
      ),
    );
  }
}

class _Offer extends HookConsumerWidget {
  const _Offer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cancelSubscriptionStore = ref.read(subscriptionCancellationStorePOD);
    final screenType = ScreenType.of(context);

    // final data = usePlanData(product: value, isOffer: true);
    final data = PlanData(
      name: 'Maz Product',
      fullPriceLabel: r'$10 / month',
      fullPrice: r'$100 / year',
      periodLabel: '10',
      perMonth: r'$10 / month',
      isOffer: true,
      bestValueBadge: S.current.subscriptionPlanBestValue,
      promoBadge: S.current.subscriptionPlanSavePercent(10),
    );

    return ModalScaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: ModalPadding.insets(context),
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (screenType >= ScreenType.tablet) SizedBox(height: theme.spacing.xl2),
                    Padding(
                      padding: EdgeInsets.only(
                        left: theme.spacing.md,
                        right: theme.spacing.md,
                        top: theme.spacing.xl3,
                      ),
                      child: ModalHeader(
                        emblem: const DecoratedIcon(
                          icon: UntitledUI.stars_02,
                          decoration: IconDecoration(padding: EdgeInsets.all(14), iconSize: 20),
                        ),
                        title: true
                            ? S.current.subscriptionUpgradeModalTitle(['Maz Product'])
                            : S.current.getSubscriptionModalTitle(['10']),
                        description: true
                            ? S.current.subscriptionUpgradeModalDescription
                            : S.current.getSubscriptionModalDesc,
                      ),
                    ),
                    SizedBox(height: theme.spacing.xl),
                    Center(
                      child: LayoutBuilder(
                        builder: (context, constraints) => Container(
                          width: min(constraints.maxWidth, 393),
                          padding: EdgeInsets.symmetric(horizontal: theme.spacing.md),
                          child: PlanCard.features(
                            mode: PlanCardMode.highlight,
                            data: data,
                            features: const ['Feature 1', 'Feature 2', 'Feature 3'],
                            viewMoreLabel: S.current.viewAllFeaturesBtn,
                            viewLessLabel: S.current.viewLessBtn,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      footer: Observer(
        builder: (context) => _ActionFooter(
          isProcessing: cancelSubscriptionStore.isProcessing,
          primaryButtonLabel: S.current.acceptOfferBtn,
          onPrimaryButtonPressed: cancelSubscriptionStore.cancelSubscription,
          secondaryButtonLabel: S.current.continueToCancelBtn,
          onSecondaryButtonPressed: cancelSubscriptionStore.moveToNextStep,
        ),
      ),
    );
  }
}

class _Confirmation extends HookConsumerWidget {
  const _Confirmation();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionStore = ref.watch(subscriptionStorePOD);
    final cancelSubscriptionStore = ref.read(subscriptionCancellationStorePOD);
    final theme = Theme.of(context);
    final subscriptionFuture = subscriptionStore.subscriptionFuture;

    final retryWidget = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(S.current.somethingWentWrong),
        ButtonPrimary(
          onPressed: subscriptionStore.refreshSubscription,
          child: Text(S.current.retryBtn),
        ),
      ],
    );

    return ModalScaffold(
      showGradient: false,
      appbar: _createAppBar(context: context, title: S.current.confirmCancellationTitle),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: theme.spacing.xl7, vertical: theme.spacing.xl2),
          child: Column(
            children: [
              AlertModal(
                title: S.current.cancelSubscriptionWarningDesc,
                type: AlertModalType.warning,
              ),
              SizedBox(height: theme.spacing.xl),
              Observer(
                builder: (context) => switch (subscriptionFuture.status) {
                  FutureStatus.pending => const Center(child: CircularProgressIndicator.adaptive()),
                  FutureStatus.fulfilled => Column(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.palette.bgPrimary),
                          borderRadius: BorderRadius.circular(theme.spacing.xl2),
                          color: theme.palette.bgPrimary,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: theme.spacing.ms),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final subscription = subscriptionFuture.value;
                                  if (subscription == null) {
                                    return retryWidget;
                                  }
                                  final data = [
                                    (
                                      S.current.cancellationDateLbl,
                                      DateTime.now().formatWithMonthDayYear(),
                                    ),
                                    (
                                      S.current.accessAvailableUntilLbl,
                                      subscription.activeUntil?.formatWithMonthDayYear(),
                                    ),
                                    (S.current.nextBillingDateLbl, S.current.noneLbl),
                                  ];
                                  final item = data[index];
                                  return ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: theme.spacing.md,
                                      vertical: theme.spacing.none,
                                    ),
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item.$1,
                                          style: theme.textStyles.textSm.regular.copyWith(
                                            color: theme.palette.textTertiary,
                                          ),
                                        ),
                                        Text(
                                          item.$2 ?? '',
                                          style: theme.textStyles.textSm.medium.copyWith(
                                            color: theme.palette.textPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    Divider(color: theme.palette.borderQuaternary),
                                itemCount: 3,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: theme.spacing.ms),
                      Text(
                        S.current.reactivateSubscriptionAnytimeDesc,
                        style: theme.textStyles.textSm.regular.copyWith(
                          color: theme.palette.textTertiary,
                        ),
                      ),
                    ],
                  ),
                  FutureStatus.rejected => retryWidget,
                },
              ),
            ],
          ),
        ),
      ),
      footer: Observer(
        builder: (context) => _ActionFooter(
          isProcessing: cancelSubscriptionStore.isProcessing,
          primaryButtonLabel: S.current.confirmCancellationTitle,
          onPrimaryButtonPressed: cancelSubscriptionStore.cancelSubscription,
          primaryButtonColor: theme.palette.iconErrorPrimary,
          secondaryButtonLabel: S.current.back,
          onSecondaryButtonPressed: cancelSubscriptionStore.moveToNextStep,
        ),
      ),
    );
  }
}

class _Summary extends ConsumerWidget {
  const _Summary();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ModalScaffold(
      showGradient: false,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(UntitledUI.check_circle, size: 40, color: theme.palette.iconSuccessPrimary),
            Text(S.current.subscriptionCancelledTitle, style: theme.textStyles.textLg.semibold),
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: theme.palette.borderPrimary),
                borderRadius: BorderRadius.circular(theme.spacing.xl2),
                color: theme.palette.bgPrimary,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: theme.spacing.xl2,
                  vertical: theme.spacing.xl,
                ),
                child: Padding(
                  padding: EdgeInsets.all(theme.spacing.xl2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        S.current.accessAvailableUntilLbl,
                        style: theme.textStyles.textLg.semibold,
                      ),
                      Text('May 25, 2027', style: theme.textStyles.textLg.semibold),
                    ],
                  ),
                ),
              ),
            ),
            Text(
              S.current.reactivateSubscriptionAnytimeDesc,
              style: theme.textStyles.textSm.regular.copyWith(color: theme.palette.textTertiary),
            ),
          ],
        ),
      ),
      footer: _ActionFooter(
        primaryButtonLabel: S.current.doneBtn,
        onPrimaryButtonPressed: () => Navigator.pop(context),
      ),
    );
  }
}

AppBar _createAppBar({required BuildContext context, String? title}) {
  final theme = Theme.of(context);
  return AppBar(
    title: title != null ? Text(title) : null,
    elevation: 0,
    backgroundColor: theme.palette.bgPopover,
    leading: const SizedBox.shrink(),
    actions: [
      Padding(
        padding: EdgeInsets.only(right: theme.spacing.xl2),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(UntitledUI.x_close),
        ),
      ),
    ],
  );
}

class _ActionFooter extends StatelessWidget {
  const _ActionFooter({
    required this.primaryButtonLabel,
    required this.onPrimaryButtonPressed,
    this.secondaryButtonLabel,
    this.onSecondaryButtonPressed,
    this.primaryButtonColor,
    this.isProcessing = false,
  });

  final String primaryButtonLabel;
  final String? secondaryButtonLabel;
  final VoidCallback onPrimaryButtonPressed;
  final VoidCallback? onSecondaryButtonPressed;
  final Color? primaryButtonColor;
  final bool isProcessing;

  bool get hasSecondaryButton => secondaryButtonLabel != null && onSecondaryButtonPressed != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final primaryButton = ButtonPrimary(
      onPressed: isProcessing ? () {} : onPrimaryButtonPressed,
      decoration: primaryButtonColor != null
          ? ButtonDecoration(decorationColor: primaryButtonColor)
          : const ButtonDecoration(),
      child: isProcessing
          ? const CircularProgressIndicator.adaptive()
          : Text(primaryButtonLabel, style: theme.textStyles.textMd.semibold),
    );

    final secondaryButton = hasSecondaryButton
        ? ButtonTertiary(
            onPressed: isProcessing ? null : onSecondaryButtonPressed,
            child: Text(secondaryButtonLabel!, style: theme.textStyles.textMd.semibold),
          )
        : null;

    return Padding(
      padding: EdgeInsets.only(
        top: theme.spacing.xl2,
        bottom: theme.spacing.xl4,
        left: theme.spacing.xl2,
        right: theme.spacing.xl2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ?secondaryButton?.expanded(),
          if (hasSecondaryButton) primaryButton.expanded() else primaryButton,
        ],
      ),
    );
  }
}
