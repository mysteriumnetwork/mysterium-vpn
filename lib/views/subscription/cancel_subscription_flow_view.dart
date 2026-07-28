import 'package:beamer/beamer.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/utils/platform.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/l10n/tr_bridge.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/subscription_cancellation_store.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:url_launcher/url_launcher_string.dart';

part 'widgets/cancel_subscription_form.dart';
part 'widgets/cancel_subscription_reasons_field.dart';

/// Handles the cancellation flow in multiple steps. Is displayed in a modal dialog
/// on desktop and as a page (CancelSubscriptionPage) on mobile
class CancelSubscriptionFlowView extends HookConsumerWidget {
  const CancelSubscriptionFlowView({super.key, this.resetOnDispose = true});

  final bool resetOnDispose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionCancellationStore = ref.watch(subscriptionCancellationStorePOD);
    final cancellationStep = useComputedValue(
      () => subscriptionCancellationStore.cancellationFlowStep,
    );

    useEffect(() {
      if (!resetOnDispose) {
        return null;
      }
      return subscriptionCancellationStore.reset;
    }, [resetOnDispose]);

    return switch (cancellationStep) {
      SubscriptionCancellationFlow.survey => const _Survey(),
      SubscriptionCancellationFlow.freeze => const _PauseDuration(),
      SubscriptionCancellationFlow.transferToWebFlow => _ContinueToWebPrompt(
        onContinuePressed: () {
          launchUrlString(subscriptionCancellationStore.linkToCancelSubscription);
          _closeCancelSubscriptionFlow(context);
        },
      ),
      SubscriptionCancellationFlow.cancellationSummary => const _Confirmation(),
    };
  }
}

void _closeCancelSubscriptionFlow(BuildContext context) {
  final beamer = Beamer.of(context);
  final onCancelRoute = beamer.configuration.uri.path.contains(Routes.cancelSubscription.path);
  if (onCancelRoute) {
    if (beamer.canBeamBack) {
      beamer.beamBack();
    } else {
      beamer.beamToNamed(Routes.main.path);
    }
    return;
  }
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  }
}

class _ContinueToWebPrompt extends StatelessWidget {
  const _ContinueToWebPrompt({required this.onContinuePressed});

  final VoidCallback onContinuePressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 343),
      child: AlertModal(
        icon: UntitledUI.link_external_02,
        title: S.current.continueCancellationOnWebTitle,
        supportingText: S.current.continueCancellationOnWebDesc,
        type: AlertModalType.warning,
        screenType: ScreenType.mobile,
        primaryButton: ButtonPrimary(
          onPressed: onContinuePressed,
          child: Text(S.current.continueToWebBtn),
        ),
        secondaryButton: ButtonTertiary(
          onPressed: () => _closeCancelSubscriptionFlow(context),
          child: Text(
            S.current.stayOnAppBtn,
            style: theme.textStyles.textMd.semibold.copyWith(color: theme.palette.textSecondary),
          ),
        ),
      ),
    );
  }
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

    return Scaffold(
      appBar: isDesktop()
          ? _createAppBar(
              context: context,
              title: '${S.current.cancelSurveyTitle} (${S.current.optional})',
              onClose: () => _closeCancelSubscriptionFlow(context),
            )
          : null,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            if (!isDesktop())
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Header(
                      showBackButton: true,
                      backgroundColor: theme.palette.bgPopover,
                      backLabel: S.current.back,
                      onBackPressed: () => _closeCancelSubscriptionFlow(context),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: theme.spacing.md),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: S.current.cancelSurveyTitle,
                              style: theme.textStyles.textLg.semibold.copyWith(fontSize: 24),
                            ),
                            TextSpan(
                              text: ' (${S.current.optional})',
                              style: theme.textStyles.textMd.medium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(theme.spacing.xl2),
                child: _Form(form: form, items: reasons),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: _ActionFooter(
                  primaryButtonLabel: S.current.continueBtn,
                  onPrimaryButtonPressed: handleSubmit,
                  secondaryButtonLabel: S.current.skipBtn,
                  onSecondaryButtonPressed: handleSkip,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PauseDuration extends HookConsumerWidget {
  const _PauseDuration();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cancelSubscriptionStore = ref.read(subscriptionCancellationStorePOD);
    final selectedPauseDuration = useState<int?>(null);

    void handleSkip() {
      cancelSubscriptionStore.moveToNextStep();
    }

    void handleSubmit() {
      cancelSubscriptionStore.setPauseDuration(selectedPauseDuration.value!);
    }

    return Scaffold(
      appBar: isDesktop()
          ? _createAppBar(
              context: context,
              title: S.current.notReadyToCancelTitle,
              onClose: () => _closeCancelSubscriptionFlow(context),
            )
          : null,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            if (!isDesktop())
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Header(
                      showBackButton: true,
                      backgroundColor: theme.palette.bgPopover,
                      backLabel: S.current.back,
                      onBackPressed: () => _closeCancelSubscriptionFlow(context),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: theme.spacing.md),
                      child: Text(
                        S.current.notReadyToCancelTitle,
                        style: theme.textStyles.textLg.semibold.copyWith(fontSize: 24),
                      ),
                    ),
                  ],
                ),
              ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: theme.spacing.xl2),
                  RadioGroup(
                    groupValue: selectedPauseDuration.value,
                    onChanged: (value) => {selectedPauseDuration.value = value},
                    child: Column(
                      children: cancelSubscriptionStore.freezeDurations
                          .map(
                            (duration) => RadioListTile(
                              value: duration,
                              title: Text(S.current.pauseForMonths(duration)),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop() ? theme.spacing.xl2 : theme.spacing.md,
                      vertical: theme.spacing.md,
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.palette.bgPrimary,
                        borderRadius: BorderRadius.circular(theme.spacing.md),
                        border: Border.all(color: theme.palette.borderPrimary),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              theme.spacing.ms,
                              theme.spacing.ms,
                              theme.spacing.s,
                              theme.spacing.ms,
                            ),
                            child: CircleAvatar(
                              radius: theme.spacing.ms,
                              backgroundColor: theme.palette.bgSecondary,
                              child: Icon(
                                UntitledUI.info_circle,
                                size: theme.spacing.md,
                                color: theme.palette.iconTertiary,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: theme.spacing.md),
                            child: Text(
                              S.current.pauseSubscriptionInfoDesc,
                              style: theme.textStyles.textXs.medium.copyWith(
                                color: theme.palette.textTertiary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Observer(
                  builder: (context) => _ActionFooter(
                    primaryButtonLabel: S.current.pauseSubscriptionBtn,
                    isProcessing: cancelSubscriptionStore.isProcessing,
                    onPrimaryButtonPressed: handleSubmit,
                    secondaryButtonLabel: S.current.continueToCancelBtn,
                    onSecondaryButtonPressed: handleSkip,
                    primaryButtonEnabled: selectedPauseDuration.value != null,
                  ),
                ),
              ),
            ),
          ],
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
      appbar: _createAppBar(
        context: context,
        title: S.current.confirmCancellationTitle,
        onClose: () => _closeCancelSubscriptionFlow(context),
      ),
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

AppBar _createAppBar({
  required BuildContext context,
  required VoidCallback onClose,
  String? title,
}) {
  final theme = Theme.of(context);
  return AppBar(
    title: title != null ? Text(title) : null,
    elevation: 0,
    backgroundColor: theme.palette.bgPopover,
    leading: const SizedBox.shrink(),
    actions: [
      Padding(
        padding: EdgeInsets.only(right: theme.spacing.xl2),
        child: IconButton(onPressed: onClose, icon: const Icon(UntitledUI.x_close)),
      ),
    ],
  );
}

class _ActionFooter extends StatelessWidget {
  const _ActionFooter({
    required this.primaryButtonLabel,
    required this.onPrimaryButtonPressed,
    this.primaryButtonEnabled = true,
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
  final bool primaryButtonEnabled;

  bool get hasSecondaryButton => secondaryButtonLabel != null && onSecondaryButtonPressed != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final primaryButton = IgnorePointer(
      ignoring: !primaryButtonEnabled || isProcessing,
      child: ButtonPrimary(
        loading: isProcessing ? const ButtonLoading() : null,
        onPressed: isProcessing ? () {} : onPrimaryButtonPressed,
        decoration: ButtonDecoration(
          decorationColor: primaryButtonEnabled
              ? primaryButtonColor
              : theme.palette.bgSecondaryDisabled,
          foregroundColor: primaryButtonEnabled
              ? theme.palette.textWhite
              : theme.palette.textDisabled,
        ),
        child: Text(
          primaryButtonLabel,
          style: theme.textStyles.textMd.semibold.copyWith(
            color: primaryButtonEnabled ? theme.palette.textWhite : theme.palette.textDisabled,
          ),
        ),
      ),
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
      child: isDesktop()
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (secondaryButton != null) Expanded(child: secondaryButton),
                if (hasSecondaryButton) Expanded(child: primaryButton) else primaryButton,
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                primaryButton,
                if (secondaryButton != null) ...[
                  SizedBox(height: theme.spacing.s),
                  secondaryButton,
                ],
              ],
            ),
    );
  }
}
