import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Empty-state shown inside the locations list when the search query returns
/// nothing. Renders concentric "radar" rings centered on the search glyph,
/// the explanatory copy, and a [ButtonSecondary] to clear the query.
///
/// The widget adapts to the viewport's remaining height: when there isn't
/// room for the full design-spec top padding, it shrinks (down to a small
/// floor) so the icon stays visible without forcing a scroll.
///
/// Callers pass [availableHeight] (typically a sliver's `remainingPaintExtent`
/// resolved via [SliverLayoutBuilder]) so the top padding can clamp to the
/// real layout space. We avoid [LayoutBuilder] here because it doesn't
/// support intrinsic dimensions, which makes it incompatible with
/// `SliverFillRemaining(hasScrollBody: false)`.
class LocationsEmptySearchResult extends StatelessWidget {
  const LocationsEmptySearchResult({required this.onClear, this.availableHeight, super.key});

  final VoidCallback onClear;

  /// Vertical space the widget is allowed to consume. When `null` the widget
  /// uses its design-spec desired padding (caller is responsible for not
  /// overflowing the surrounding viewport).
  final double? availableHeight;

  static const _iconSize = 48.0;
  static const _ringsDiameter = 480.0;
  static const _ringsRadius = _ringsDiameter / 2;
  static const _iconHalf = _iconSize / 2;

  /// Distance the rings' geometric center sits above the column's top
  /// (= icon-half), used to position the rings on the icon center.
  static const _ringsTopExtent = _ringsRadius - _iconHalf;

  /// Inner Stack height: enough so the bottom of the outermost ring
  /// (`icon_half + rings_radius`) is visible inside the widget.
  static const _stackHeight = _iconHalf + _ringsRadius;

  /// Visible top padding above the icon — wider on desktop per the Figma.
  static const _columnTopPaddingMobile = 100.0;
  static const _columnTopPaddingDesktop = 130.0;

  /// Theme-specific ring colors (not in the palette — design spec only).
  static const _ringColorDark = Color(0xFF31224D);
  static const _ringColorLight = Color(0xFFF1F0F6);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = ScreenType.of(context) >= ScreenType.tablet;
    final desiredTopPadding = isDesktop ? _columnTopPaddingDesktop : _columnTopPaddingMobile;
    final ringColor = theme.brightness == Brightness.dark ? _ringColorDark : _ringColorLight;
    final palette = theme.palette;
    final bottomPadding = theme.spacing.xl3;
    final minTopPadding = theme.spacing.md;

    // Shrink the top gap when the surrounding sliver can't give us the full
    // `desiredTopPadding + _stackHeight + bottomPadding`; floor at
    // [minTopPadding] so the icon never collides with the tabs bar.
    final available = availableHeight ?? desiredTopPadding + _stackHeight + bottomPadding;
    final columnTopPadding = (available - _stackHeight - bottomPadding).clamp(
      minTopPadding,
      desiredTopPadding,
    );

    return Padding(
      padding: EdgeInsets.only(top: columnTopPadding, bottom: bottomPadding),
      child: SizedBox(
        height: _stackHeight,
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -_ringsTopExtent,
              left: 0,
              right: 0,
              height: _ringsDiameter,
              child: IgnorePointer(
                child: OverflowBox(
                  minWidth: _ringsDiameter,
                  maxWidth: _ringsDiameter,
                  minHeight: _ringsDiameter,
                  maxHeight: _ringsDiameter,
                  child: _RadarRings(color: ringColor),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: _iconSize,
                  height: _iconSize,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: palette.bgPrimary,
                      borderRadius: const BorderRadius.all(Radius.kXs),
                      border: Border.all(color: palette.borderSecondary),
                    ),
                    child: Icon(UntitledUI.search_sm, size: 24, color: palette.iconPrimary),
                  ),
                ),
                SizedBox(height: theme.spacing.md),
                Text(
                  LocaleKeys.noLocationsFound.tr(),
                  textAlign: TextAlign.center,
                  style: theme.textStyles.textMd.semibold.copyWith(color: palette.textPrimary),
                ),
                SizedBox(height: theme.spacing.xs),
                Text(
                  LocaleKeys.tryAnotherLocation.tr(),
                  textAlign: TextAlign.center,
                  style: theme.textStyles.textSm.regular.copyWith(color: palette.textTertiary),
                ),
                SizedBox(height: theme.spacing.xl),
                ButtonSecondary(
                  size: ButtonSize.small,
                  onPressed: onClear,
                  child: Text(LocaleKeys.clearSearchBtn.tr()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RadarRings extends StatelessWidget {
  const _RadarRings({required this.color});

  final Color color;

  /// Diameters of the seven concentric rings, in logical pixels (step 64 px).
  static const _diameters = [96.0, 160.0, 224.0, 288.0, 352.0, 416.0, 480.0];

  @override
  Widget build(BuildContext context) => ShaderMask(
    blendMode: BlendMode.dstIn,
    shaderCallback: (bounds) => const RadialGradient(
      stops: [0.2, 1.0],
      colors: [Colors.white, Colors.transparent],
    ).createShader(bounds),
    child: SizedBox.square(
      dimension: LocationsEmptySearchResult._ringsDiameter,
      child: CustomPaint(painter: _RadarRingsPainter(color: color)),
    ),
  );
}

class _RadarRingsPainter extends CustomPainter {
  const _RadarRingsPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final center = Offset(size.width / 2, size.height / 2);
    for (final d in _RadarRings._diameters) {
      canvas.drawCircle(center, d / 2, paint);
    }
  }

  @override
  bool shouldRepaint(_RadarRingsPainter oldDelegate) => oldDelegate.color != color;
}
