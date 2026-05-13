part of 'onboarding_dialog.dart';

/// Small bordered icon container used as the leading element on connection
/// rows in steps 1 and 2.
class _LeadingIcon extends StatelessWidget {
  const _LeadingIcon({required this.icon});

  final IconData icon;

  // Dark-mode bg has no design-system equivalent — figma uses #232529.
  static const _bgDark = Color(0xFF232529);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: isDark ? _bgDark : palette.bgSecondary,
        borderRadius: const BorderRadius.all(Radius.kS),
        border: Border.all(color: palette.borderInfoCard),
      ),
      child: Icon(icon, size: 14, color: palette.iconSecondary),
    );
  }
}

/// Round colored status indicator used as the trailing element on connection
/// rows: red eye when [exposed] is true, green check otherwise.
class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.exposed});

  final bool exposed;

  @override
  Widget build(BuildContext context) {
    final color = exposed ? Palette.error.shade600 : Palette.success.shade600;
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.55),
            blurRadius: 6,
            spreadRadius: -1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(exposed ? UntitledUI.eye : UntitledUI.check, size: 12, color: Palette.white),
    );
  }
}

/// Pill badge used in the top "Connection" row of steps 1 and 2 — variant
/// colors and icon are supplied by the caller.
class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.background,
    required this.borderColor,
    required this.icon,
  });

  final String label;
  final Color background;
  final Color borderColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.spacing;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: spacing.ms, vertical: spacing.xs),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: borderColor),
        borderRadius: const BorderRadius.all(Radius.kFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Palette.white),
          SizedBox(width: spacing.sm),
          Text(
            label,
            style: theme.textStyles.textXs.bold.copyWith(
              color: Palette.white,
              letterSpacing: 0.525,
            ),
          ),
        ],
      ),
    );
  }
}
