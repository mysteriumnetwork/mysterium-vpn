part of 'onboarding_dialog.dart';

/// Full-width on mobile, hugs content on desktop.
class _ContinueButton extends StatelessWidget {
  const _ContinueButton({required this.isMobile, required this.onPressed, required this.label});

  final bool isMobile;
  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    final btn = ButtonPrimary(onPressed: onPressed, child: Text(label));
    if (isMobile) {
      return SizedBox(width: double.infinity, child: btn);
    }
    return btn;
  }
}

class _StepCopy extends StatelessWidget {
  const _StepCopy({required this.step, required this.isMobile});

  final _Step step;
  final bool isMobile;

  static const _titleConstraintsMobile = BoxConstraints(maxWidth: _kCopyTitleMaxWidthMobile);
  static const _subtitleConstraintsMobile = BoxConstraints(maxWidth: _kCopySubtitleMaxWidthMobile);
  static const _copyConstraintsDesktop = BoxConstraints(maxWidth: _kCopyMaxWidthDesktop);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    return Column(
      children: [
        ConstrainedBox(
          constraints: isMobile ? _titleConstraintsMobile : _copyConstraintsDesktop,
          child: Text(
            step.title,
            textAlign: TextAlign.center,
            style: theme.textStyles.displayXlg.bold.copyWith(color: palette.textPrimary),
          ),
        ),
        SizedBox(height: theme.spacing.md),
        ConstrainedBox(
          constraints: isMobile ? _subtitleConstraintsMobile : _copyConstraintsDesktop,
          child: Text(
            step.desc,
            textAlign: TextAlign.center,
            style: theme.textStyles.textMd.regular.copyWith(color: palette.textTertiary),
          ),
        ),
      ],
    );
  }
}
