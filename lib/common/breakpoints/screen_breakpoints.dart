/// Manually define screen resolution breakpoints
/// Overrides the defaults

class ScreenBreakpoint {
  final double watch;
  final double mobile;
  final double tablet;
  final double desktop;

  const ScreenBreakpoint({
    required this.desktop,
    required this.tablet,
    required this.mobile,
    required this.watch,
  });

  @override
  String toString() => 'Desktop: $desktop, Tablet: $tablet,Mobile: $mobile Watch: $watch';
}