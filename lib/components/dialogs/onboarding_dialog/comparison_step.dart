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

  // The comparison composition's POSITIONING is LTR (data centre on the
  // left, Mysterium on the right) regardless of locale, but each card's
  // text content still follows the ambient direction so Arabic/Hebrew copy
  // renders with the correct paragraph direction. The outer Directionality
  // pins the Stack layout to LTR; an inner Directionality on each card
  // restores the inherited direction for the text glyphs.
  @override
  Widget build(BuildContext context) {
    final compact = _isCompact(context);
    final overlap = compact ? _kHorizontalOverlapMobile : _kHorizontalOverlapDesktop;
    final frontDrop = compact ? _kFrontDropMobile : _kFrontDropDesktop;
    final layoutWidth = _kBackWidth + _kFrontWidth - overlap;
    final ambientDirection = Directionality.of(context);
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
                child: Directionality(
                  textDirection: ambientDirection,
                  child: OnboardingComparisonCard(
                    variant: OnboardingComparisonCardVariant.dataCentre,
                    pillLabel: S.current.dataCentreComparisonCardLbl,
                    title: S.current.dataCentreComparisonCardTitle,
                    items: [
                      S.current.dataCentreComparisonCardItem1,
                      S.current.dataCentreComparisonCardItem2,
                      S.current.dataCentreComparisonCardItem3,
                    ],
                    image: Asset.images.serversOnboarding(context).provider(),
                    width: _kBackWidth,
                    pillMaxWidth: 120,
                    contentTrailingPadding: overlap + _kContentGapBeforeFront,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Directionality(
                  textDirection: ambientDirection,
                  child: OnboardingComparisonCard(
                    variant: OnboardingComparisonCardVariant.residential,
                    pillLabel: S.current.residentialCentreComparisonCardLbl,
                    title: 'Mysterium VPN',
                    items: [
                      S.current.residentialCentreComparisonCardItem1,
                      S.current.residentialCentreComparisonCardItem2,
                      S.current.residentialCentreComparisonCardItem3,
                    ],
                    image: Asset.images.houseOnboarding(context).provider(),
                    width: _kFrontWidth,
                    pillMaxWidth: 120,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
