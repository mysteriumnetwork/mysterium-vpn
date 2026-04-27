import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// A compact [ButtonTertiary] styled for use as a trailing action in
/// [SettingsCard] widgets. Extracts the repeated decoration + size pattern
/// used across all settings pages.
class SettingsActionButton extends StatelessWidget {
  const SettingsActionButton({
    required this.onPressed,
    required this.child,
    this.foregroundColor,
    super.key,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).spacing;
    return ButtonTertiary(
      decoration: ButtonDecoration(
        foregroundColor: foregroundColor,
        minimumSize: Size.zero,
        padding: EdgeInsets.symmetric(horizontal: spacing.xs, vertical: spacing.xxs),
      ),
      size: ButtonSize.small,
      onPressed: onPressed,
      child: child,
    );
  }
}
