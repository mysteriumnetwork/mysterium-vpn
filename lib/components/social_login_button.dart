import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    required this.label,
    required this.asset,
    required this.isLoading,
    required this.onPressed,
    this.iconColor,
    super.key,
  });

  final String label;
  final SvgGenImage asset;
  final bool isLoading;
  final VoidCallback? onPressed;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = Palette.of(context);
    final spacing = theme.spacing;
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark ? Palette.grayDarkAlpha.shade700 : Palette.white;
    final foregroundColor = isDark ? Palette.white : palette.textSecondary;
    final borderColor = isDark ? Palette.grayDarkAlpha.shade700 : palette.borderPrimary;

    return ButtonSecondary(
      onPressed: onPressed,
      size: ButtonSize.large,
      loading: isLoading ? const ButtonLoading() : null,
      leading: SvgIcon(asset: asset, width: spacing.xl2, height: spacing.xl2, color: iconColor),
      decoration: ButtonDecoration(
        padding: EdgeInsets.symmetric(horizontal: spacing.xl, vertical: spacing.lg),
        decorationColor: backgroundColor,
        foregroundColor: foregroundColor,
        borderColor: borderColor,
      ),
      child: Text(label),
    );
  }
}
