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

    builder: (context) => _Dialog(onStartTour: onStartTour, onCancelTour: onCancelTour),
  );
}

class _Dialog extends StatelessWidget {
  const _Dialog({required this.onStartTour, required this.onCancelTour});

  final VoidCallback onStartTour;
  final VoidCallback onCancelTour;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).spacing;
    final textStyles = Theme.of(context).textStyles;
    final palette = Theme.of(context).palette;

    return Dialog(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      constraints: const BoxConstraints(maxWidth: 350),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: spacing.xl, vertical: spacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ModalHeader(
              title: LocaleKeys.subscriptionOnboardingPromptTitle.tr(),
              titleStyle: textStyles.textMd.semibold.copyWith(color: palette.textPrimary),
              description: LocaleKeys.subscriptionOnboardingPromptDescription.tr(),
              descriptionStyle: textStyles.textXs.regular.copyWith(color: palette.textTertiary),
              emblem: SizedBox(
                width: 32,
                height: 32,
                child: CircleAvatar(
                  backgroundColor: palette.bgSecondarySelected,
                  child: Padding(
                    padding: EdgeInsets.all(spacing.sm),
                    child: Icon(Icons.flag_outlined, size: 20, color: palette.iconBrandSecondary),
                  ),
                ),
              ),
              emblemSpacing: spacing.md,
            ),
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
        ),
      ),
    );
  }
}
