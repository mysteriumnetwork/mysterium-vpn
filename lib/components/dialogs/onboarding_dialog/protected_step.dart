part of 'onboarding_dialog.dart';

/// Step 2 — four connection rows in a clean Column, conveying the "protected"
/// post-VPN state with green status pills/dots.
class _ProtectedStep extends StatelessWidget {
  const _ProtectedStep();

  static const _constraintsMobile = BoxConstraints(maxWidth: _kStepMaxWidthMobile);
  static const _constraintsDesktop = BoxConstraints(maxWidth: _kStepMaxWidthDesktop);

  @override
  Widget build(BuildContext context) {
    final gap = SizedBox(height: Theme.of(context).spacing.ms);
    return ConstrainedBox(
      constraints: _isCompact(context) ? _constraintsMobile : _constraintsDesktop,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OnboardingItem(
            label: S.current.connection,
            borderColor: Palette.success.shade200,
            trailing: _StatusPill(
              label: S.current.protectedLbl,
              background: Palette.success.shade600,
              borderColor: Palette.success.shade200,
              icon: UntitledUI.shield_01,
            ),
          ),
          gap,
          OnboardingItem(
            leading: const _LeadingIcon(icon: UntitledUI.globe_05),
            label: S.current.ipAddressLbl,
            value: '••.•••.••.•••',
            trailing: const _StatusDot(exposed: false),
          ),
          gap,
          OnboardingItem(
            leading: const _LeadingIcon(icon: UntitledUI.marker_pin_01),
            label: S.current.locationLbl,
            value: S.current.berlinLbl,
            trailing: const _StatusDot(exposed: false),
          ),
          gap,
          OnboardingItem(
            leading: const _LeadingIcon(icon: UntitledUI.wifi),
            label: _kIspLabel,
            value: S.current.hiddenLbl,
            trailing: const _StatusDot(exposed: false),
          ),
        ],
      ),
    );
  }
}
