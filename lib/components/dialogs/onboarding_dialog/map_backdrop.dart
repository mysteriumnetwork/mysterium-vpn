part of 'onboarding_dialog.dart';

/// Decorative world-map illustration painted behind every step, tinted with
/// the current step's accent color.
class _MapBackdrop extends StatelessWidget {
  const _MapBackdrop({required this.step});

  final _Step step;

  // Map's natural aspect ratio (591×281 SVG).
  static const _mapAspectRatio = 591 / 281;

  // Map render height per breakpoint. Mobile is slightly larger than natural
  // so the map reads at the right scale on phones; desktop uses natural 281.
  static const _mobileMapHeight = 320.0;
  static const _desktopMapHeight = 281.0;

  // Desktop offset (unchanged from the original design — mobile uses the
  // body's header-gap + second-item baseline instead).
  static const _desktopMapInset = 21.0;

  @override
  Widget build(BuildContext context) {
    final isMobile = _isCompact(context);
    final mapHeight = isMobile ? _mobileMapHeight : _desktopMapHeight;
    final mapWidth = mapHeight * _mapAspectRatio;
    final mapTop =
        MediaQuery.paddingOf(context).top +
        Header.height +
        (isMobile
            ? _kHeaderContentGapMobile + _kSecondItemTopOffset
            : Theme.of(context).spacing.md + _desktopMapInset);

    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: mapTop,
            left: 0,
            right: 0,
            height: mapHeight,
            child: OverflowBox(
              maxWidth: double.infinity,
              child: SizedBox(
                width: mapWidth,
                height: mapHeight,
                child: Stack(
                  children: [
                    Positioned.fill(child: Asset.images.onboardingMap(context).svg()),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            transform: const _GradientStretch(scaleX: 1.8),
                            colors: [
                              step.accent.withValues(alpha: 0.22),
                              step.accent.withValues(alpha: 0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Horizontal stretch around the gradient's bounding rect centre — turns
/// a circular [RadialGradient] into a horizontally-elongated ellipse.
class _GradientStretch extends GradientTransform {
  const _GradientStretch({required this.scaleX});

  final double scaleX;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    final cx = bounds.center.dx;
    final cy = bounds.center.dy;
    return Matrix4.identity()
      ..translateByDouble(cx, cy, 0, 1)
      ..scaleByDouble(scaleX, 1, 1, 1)
      ..translateByDouble(-cx, -cy, 0, 1);
  }
}
