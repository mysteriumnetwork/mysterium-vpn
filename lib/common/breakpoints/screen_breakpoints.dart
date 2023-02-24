/// Manually define screen resolution breakpoints
/// Overrides the defaults
library;

class ScreenBreakpoint {
  const ScreenBreakpoint({
    required this.desktop,
    required this.tablet,
    required this.mobile,
    required this.watch,
  });

  final double watch;
  final double mobile;
  final double tablet;
  final double desktop;

  @override
  String toString() => 'Desktop: $desktop, Tablet: $tablet,Mobile: $mobile Watch: $watch';
}
