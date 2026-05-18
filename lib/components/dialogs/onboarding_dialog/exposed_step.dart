part of 'onboarding_dialog.dart';

/// Step 1 — three connection rows stacked with slight rotation, conveying the
/// "exposed" pre-VPN state with red status pills/dots.
class _ExposedStep extends StatelessWidget {
  const _ExposedStep();

  static const _kHeight = 248.0;
  static const _kIpCardTop = _kSecondItemTopOffset;
  static const _kLocationCardTop = 129.0;
  static const _kIspCardTop = 191.0;

  @override
  Widget build(BuildContext context) => FittedBox(
    fit: BoxFit.scaleDown,
    alignment: Alignment.topCenter,
    child: SizedBox(
      width: _isCompact(context) ? _kStepMaxWidthMobile : _kStepMaxWidthDesktop,
      height: _kHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: OnboardingItem(
              label: LocaleKeys.connection.tr(),
              borderColor: Palette.error.shade200,
              trailing: _StatusPill(
                label: LocaleKeys.unprotectedLbl.tr(),
                background: Palette.error.shade600,
                borderColor: Palette.error.shade200,
                icon: UntitledUI.alert_circle,
              ),
            ),
          ),
          Positioned(
            left: 8,
            right: -8,
            top: _kIpCardTop,
            child: Transform.rotate(
              angle: _deg(0.22),
              child: OnboardingItem(
                leading: const _LeadingIcon(icon: UntitledUI.globe_05),
                label: LocaleKeys.ipAddressLbl.tr(),
                // RFC 5737 documentation-reserved range — never assigned to
                // a real network, safe to display in illustrative UI.
                value: '203.0.113.42',
                trailing: const _StatusDot(exposed: true),
              ),
            ),
          ),
          Positioned(
            left: -4,
            right: 4,
            top: _kLocationCardTop,
            child: Transform.rotate(
              angle: _deg(-0.14),
              child: OnboardingItem(
                leading: const _LeadingIcon(icon: UntitledUI.marker_pin_01),
                label: LocaleKeys.locationLbl.tr(),
                value: LocaleKeys.madridLbl.tr(),
                trailing: const _StatusDot(exposed: true),
              ),
            ),
          ),
          Positioned(
            left: 5,
            right: -7,
            top: _kIspCardTop,
            child: Transform.rotate(
              angle: _deg(-1.13),
              child: OnboardingItem(
                leading: const _LeadingIcon(icon: UntitledUI.wifi),
                label: _kIspLabel,
                value: LocaleKeys.vodafoneLbl.tr(),
                trailing: const _StatusDot(exposed: true),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
