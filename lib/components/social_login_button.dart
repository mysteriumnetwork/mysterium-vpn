import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart' hide Radius;

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
    final palette = Palette.of(context);
    final textStyles = Theme.of(context).textStyles;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark ? Palette.grayDarkAlpha.shade700 : Palette.white;
    final foregroundColor = isDark ? Palette.white : palette.textSecondary;
    final borderColor = isDark ? Palette.grayDarkAlpha.shade700 : palette.borderPrimary;

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          disabledBackgroundColor: backgroundColor,
          disabledForegroundColor: foregroundColor,
          side: BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          textStyle: textStyles.textMd.semibold,
          minimumSize: const Size(double.infinity, 44),
          overlayColor: Colors.transparent,
        ),
        child: isLoading
            ? const LoadingIndicator()
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgIcon(asset: asset, width: 24, height: 24, color: iconColor),
                  const SizedBox(width: 16),
                  Flexible(child: Text(label)),
                ],
              ),
      ),
    );
  }
}
