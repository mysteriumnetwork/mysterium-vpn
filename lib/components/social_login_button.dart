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
    final spacing = Theme.of(context).spacing;

    return ButtonSecondary(
      onPressed: onPressed,
      size: ButtonSize.large,
      loading: isLoading ? const ButtonLoading() : null,
      // 16px gap between icon and label per design — button row contributes
      // 8px (Row.spacing) + 2px (child horizontal padding); add 6px to total 16.
      leading: Padding(
        padding: EdgeInsets.only(right: spacing.sm),
        child: SvgIcon(asset: asset, width: spacing.xl2, height: spacing.xl2, color: iconColor),
      ),
      decoration: ButtonDecoration(
        padding: EdgeInsets.symmetric(horizontal: spacing.xl, vertical: spacing.lg),
      ),
      child: Text(label),
    );
  }
}
