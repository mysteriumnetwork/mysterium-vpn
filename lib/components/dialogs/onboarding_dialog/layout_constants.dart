part of 'onboarding_dialog.dart';

const _kCopyTitleMaxWidthMobile = 340.0;
const _kCopySubtitleMaxWidthMobile = 300.0;
const _kCopyMaxWidthDesktop = 576.0;
const _kStepMaxWidthMobile = 327.0;
const _kStepMaxWidthDesktop = 295.0;

// Vertical gap between the header (app logo bar) and the step illustration.
const _kHeaderContentGapMobile = 60.0;
const _kHeaderContentGapDesktop = 48.0;

// Vertical offset of step 1's second row (the IP card) from the top of the
// step illustration. Reused as the alignment baseline for the decorative map
// backdrop so the map starts in line with that row across all steps.
const _kSecondItemTopOffset = 72.0;

// Tech acronym that stays untranslated across all supported languages.
const _kIspLabel = 'ISP';

/// Width below which the dialog uses the compact (phone) layout.
const _kCompactBreakpoint = 600.0;

bool _isCompact(BuildContext context) => MediaQuery.sizeOf(context).width < _kCompactBreakpoint;

double _deg(double degrees) => degrees * pi / 180;
