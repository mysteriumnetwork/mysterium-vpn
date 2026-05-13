part of 'onboarding_dialog.dart';

/// Step 3 — two overlapping comparison cards: a generic "data centre IPs"
/// VPN on the left, Mysterium (residential IPs) overlapping on the right.
class _ComparisonStep extends StatelessWidget {
  const _ComparisonStep();

  // Card widths are shared across breakpoints. Overlap and vertical drop
  // differ — figma node 9386:589435 for desktop, 9386:611545 for mobile.
  static const _kBackWidth = 188.0;
  static const _kFrontWidth = 194.0;
  static const _kHorizontalOverlapDesktop = 55.0;
  static const _kHorizontalOverlapMobile = 38.0;
  static const _kFrontDropDesktop = 55.0;
  static const _kFrontDropMobile = 31.0;
  // Visual gap between back-card content and the front card's left border.
  static const _kContentGapBeforeFront = 4.0;

  // Force LTR for the comparison composition: the data centre card sits to
  // the left and Mysterium to the right regardless of locale. Only the text
  // glyphs inside each card follow their natural direction.
  @override
  Widget build(BuildContext context) {
    final compact = _isCompact(context);
    final overlap = compact ? _kHorizontalOverlapMobile : _kHorizontalOverlapDesktop;
    final frontDrop = compact ? _kFrontDropMobile : _kFrontDropDesktop;
    final layoutWidth = _kBackWidth + _kFrontWidth - overlap;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: layoutWidth,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Back card drives Stack height. Its bottom-padding makes the
              // Stack taller so the front card (bottom-aligned) sits the
              // configured drop below the back card's bottom.
              Padding(
                padding: EdgeInsets.only(bottom: frontDrop),
                child: OnboardingComparisonCard(
                  variant: OnboardingComparisonCardVariant.dataCentre,
                  pillLabel: LocaleKeys.dataCentreComparisonCardLbl.tr(),
                  title: LocaleKeys.dataCentreComparisonCardTitle.tr(),
                  items: [
                    LocaleKeys.dataCentreComparisonCardItem1.tr(),
                    LocaleKeys.dataCentreComparisonCardItem2.tr(),
                    LocaleKeys.dataCentreComparisonCardItem3.tr(),
                  ],
                  image: Asset.images.serversOnboarding(context).provider(),
                  width: _kBackWidth,
                  pillMaxWidth: 120,
                  contentTrailingPadding: overlap + _kContentGapBeforeFront,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: OnboardingComparisonCard(
                  variant: OnboardingComparisonCardVariant.residential,
                  pillLabel: LocaleKeys.residentialCentreComparisonCardLbl.tr(),
                  title: 'Mysterium VPN',
                  items: [
                    LocaleKeys.residentialCentreComparisonCardItem1.tr(),
                    LocaleKeys.residentialCentreComparisonCardItem2.tr(),
                    LocaleKeys.residentialCentreComparisonCardItem3.tr(),
                  ],
                  image: Asset.images.houseOnboarding(context).provider(),
                  width: _kFrontWidth,
                  pillMaxWidth: 120,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
