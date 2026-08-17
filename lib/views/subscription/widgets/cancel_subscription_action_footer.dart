import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/utils/platform.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class CancelSubscriptionActionFooter extends StatelessWidget {
  const CancelSubscriptionActionFooter({
    required this.primaryButtonLabel,
    required this.onPrimaryButtonPressed,
    this.primaryButtonEnabled = true,
    this.secondaryButtonLabel,
    this.onSecondaryButtonPressed,
    this.isProcessing = false,
    super.key,
  });

  final String primaryButtonLabel;
  final String? secondaryButtonLabel;
  final VoidCallback onPrimaryButtonPressed;
  final VoidCallback? onSecondaryButtonPressed;
  final bool isProcessing;
  final bool primaryButtonEnabled;

  bool get hasSecondaryButton => secondaryButtonLabel != null && onSecondaryButtonPressed != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    debugPrint('MAZLOG primaryButtonEnabled: $primaryButtonEnabled');
    final primaryButton = IgnorePointer(
      ignoring: !primaryButtonEnabled || isProcessing,
      child: ButtonPrimary(
        loading: isProcessing ? const ButtonLoading() : null,
        onPressed: isProcessing || !primaryButtonEnabled ? () {} : onPrimaryButtonPressed,
        decoration: ButtonDecoration(
          decorationColor: primaryButtonEnabled ? null : theme.palette.bgDisabled,
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
            child: Text(
              secondaryButtonLabel!,
              style: theme.textStyles.textMd.semibold.copyWith(color: theme.palette.textSecondary),
            ),
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
