import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

void showSubscriptionOnboardingDialog({
  required BuildContext context,
  required VoidCallback onStartTour,
  required VoidCallback onCancelTour,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) =>
        _StartSubscriptionOnboardingDialog(onStartTour: onStartTour, onCancelTour: onCancelTour),
  );
}

void showSubscriptionOnboardingCompleteDialog({required BuildContext context}) {
  showDialog(context: context, builder: (context) => const _CompleteSubscriptionOnboardingDialog());
}

class _StartSubscriptionOnboardingDialog extends StatelessWidget {
  const _StartSubscriptionOnboardingDialog({required this.onStartTour, required this.onCancelTour});

  final VoidCallback onStartTour;
  final VoidCallback onCancelTour;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).spacing;
    final textStyles = Theme.of(context).textStyles;
    final palette = Theme.of(context).palette;

    return _SubscriptionOnboardingDialogFrame(
      title: LocaleKeys.subscriptionOnboardingPromptTitle.tr(),
      description: LocaleKeys.subscriptionOnboardingPromptTitle.tr(),
      emblemIcon: UntitledUI.flag_05,
      emblemColor: palette.iconBrandSecondary,
      emblemBackgroundColor: palette.bgSecondarySelected,
      actions: [
        SizedBox(height: spacing.xl2),
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ButtonPrimary(
                    onPressed: () {
                      Navigator.pop(context);
                      onStartTour();
                    },
                    child: Text(
                      LocaleKeys.subscriptionOnboardingStartTourLabel.tr(),
                      style: textStyles.textSm.semibold.copyWith(color: palette.textWhite),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing.s),
            Row(
              children: [
                Expanded(
                  child: ButtonTertiary(
                    decoration: ButtonDecoration(padding: EdgeInsets.all(spacing.none)),
                    onPressed: () {
                      Navigator.pop(context);
                      onCancelTour();
                    },
                    child: Text(
                      LocaleKeys.subscriptionOnboardingCancelTourLabel.tr(),
                      style: textStyles.textSm.semibold.copyWith(color: palette.textSecondary),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _CompleteSubscriptionOnboardingDialog extends StatelessWidget {
  const _CompleteSubscriptionOnboardingDialog();

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).palette;

    return _SubscriptionOnboardingDialogFrame(
      title: LocaleKeys.subscriptionOnboardingSetupCompleteTitle.tr(),
      description: LocaleKeys.subscriptionOnboardingSetupCompleteDescription.tr(),
      emblemIcon: UntitledUI.check,
      emblemColor: palette.iconSuccessPrimary,
      emblemBackgroundColor: palette.bgSuccess,
      actions: const [],
    );
  }
}

class _SubscriptionOnboardingDialogFrame extends StatelessWidget {
  const _SubscriptionOnboardingDialogFrame({
    required this.title,
    required this.description,
    required this.emblemIcon,
    required this.emblemColor,
    required this.emblemBackgroundColor,
    required this.actions,
  });

  final String title;
  final String description;
  final IconData emblemIcon;
  final Color emblemColor;
  final Color emblemBackgroundColor;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).spacing;
    final textStyles = Theme.of(context).textStyles;
    final palette = Theme.of(context).palette;

    return Dialog(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      constraints: const BoxConstraints(minWidth: 343, maxWidth: 343, maxHeight: 236),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: spacing.xl, vertical: spacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ModalHeader(
              title: title,
              titleStyle: textStyles.textMd.semibold.copyWith(color: palette.textPrimary),
              description: description,
              descriptionStyle: textStyles.textXs.regular.copyWith(color: palette.textTertiary),
              emblem: SizedBox(
                width: 32,
                height: 32,
                child: CircleAvatar(
                  backgroundColor: emblemBackgroundColor,
                  child: Padding(
                    padding: EdgeInsets.all(spacing.sm),
                    child: Icon(emblemIcon, size: 20, color: emblemColor),
                  ),
                ),
              ),
              emblemSpacing: spacing.md,
            ),
            ...actions,
          ],
        ),
      ),
    );
  }
}
