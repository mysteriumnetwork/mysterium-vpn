import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

Future<void> showSubscriptionOnboardingDialog({
  required BuildContext context,
  required VoidCallback onStartTour,
  required VoidCallback onCancelTour,
}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      elevation: 0,
      child: _StartSubscriptionOnboardingDialog(
        onStartTour: onStartTour,
        onCancelTour: onCancelTour,
      ),
    ),
  );
}

Future<void> showSubscriptionOnboardingCompleteDialog({required BuildContext context}) async {
  await showDialog<void>(
    context: context,
    builder: (context) => Dialog(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: const _CompleteSubscriptionOnboardingDialog(),
    ),
  );
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

    return AppDialog(
      width: 343,
      title: S.current.subscriptionOnboardingPromptTitle,
      description: S.current.subscriptionOnboardingPromptDescription,
      emblem: _DialogEmblem(
        icon: UntitledUI.flag_05,
        iconColor: palette.iconBrandSecondary,
        backgroundColor: palette.bgSecondarySelected,
      ),
      emblemSpacing: spacing.md,
      titleStyle: textStyles.textMd.semibold.copyWith(color: palette.textPrimary),
      descriptionStyle: textStyles.textXs.regular.copyWith(color: palette.textTertiary),
      primaryButton: ButtonPrimary(
        onPressed: () {
          Navigator.pop(context);
          onStartTour();
        },
        child: Text(
          S.current.subscriptionOnboardingStartTourLabel,
          style: textStyles.textSm.semibold.copyWith(color: palette.textWhite),
        ),
      ),
      secondaryButton: ButtonTertiary(
        decoration: ButtonDecoration(padding: EdgeInsets.all(spacing.none)),
        onPressed: () {
          Navigator.pop(context);
          onCancelTour();
        },
        child: Text(
          S.current.subscriptionOnboardingCancelTourLabel,
          style: textStyles.textSm.semibold.copyWith(color: palette.textSecondary),
        ),
      ),
    );
  }
}

class _CompleteSubscriptionOnboardingDialog extends StatefulWidget {
  const _CompleteSubscriptionOnboardingDialog();

  @override
  State<_CompleteSubscriptionOnboardingDialog> createState() =>
      _CompleteSubscriptionOnboardingDialogState();
}

class _CompleteSubscriptionOnboardingDialogState
    extends State<_CompleteSubscriptionOnboardingDialog> {
  Timer? _autoCloseTimer;

  @override
  void initState() {
    super.initState();
    _autoCloseTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _autoCloseTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).spacing;
    final textStyles = Theme.of(context).textStyles;
    final palette = Theme.of(context).palette;

    return AppDialog(
      width: 343,
      title: S.current.subscriptionOnboardingSetupCompleteTitle,
      description: S.current.subscriptionOnboardingSetupCompleteDescription,
      emblem: _DialogEmblem(
        icon: UntitledUI.check,
        iconColor: palette.iconSuccessPrimary,
        backgroundColor: palette.bgSuccess,
      ),
      emblemSpacing: spacing.md,
      titleStyle: textStyles.textMd.semibold.copyWith(color: palette.textPrimary),
      descriptionStyle: textStyles.textXs.regular.copyWith(color: palette.textTertiary),
    );
  }
}

class _DialogEmblem extends StatelessWidget {
  const _DialogEmblem({required this.icon, required this.iconColor, required this.backgroundColor});

  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).spacing;

    return SizedBox(
      width: 32,
      height: 32,
      child: CircleAvatar(
        backgroundColor: backgroundColor,
        child: Padding(
          padding: EdgeInsets.all(spacing.sm),
          child: Icon(icon, size: 20, color: iconColor),
        ),
      ),
    );
  }
}
