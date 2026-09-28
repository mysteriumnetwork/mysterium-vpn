import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Android 15+ owns bar-icon contrast; re-read per frame so it tracks the theme.
class SystemUiOverlayRegion extends StatelessWidget {
  const SystemUiOverlayRegion({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (theme.platform != TargetPlatform.android) {
      return child;
    }
    final icons = theme.brightness == Brightness.dark ? Brightness.light : Brightness.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: icons,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: icons,
      ),
      child: child,
    );
  }
}
