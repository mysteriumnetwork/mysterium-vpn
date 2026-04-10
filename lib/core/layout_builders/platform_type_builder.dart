import 'package:flutter/material.dart';
import 'package:mysterium_vpn/core/layout_builders/platform_layout_builder.dart';

/// Provides a builder function for different platforms
///
/// [android] will be built when platform is android
/// [ios] will be built when platform is ios
/// [macos] will be built when platform is macos
/// [windows] will be built if platform is windows
class PlatformTypeLayoutBuilder extends StatelessWidget {
  const PlatformTypeLayoutBuilder({
    required this.android,
    this.ios,
    this.windows,
    this.macos,
    super.key,
  });

  final WidgetBuilder? android;
  final WidgetBuilder? ios;
  final WidgetBuilder? windows;
  final WidgetBuilder? macos;

  @override
  Widget build(BuildContext context) => PlatformLayoutBuilder(
    builder: (context, platform) {
      // If we're at windows platform
      if (platform == TargetPlatform.windows) {
        if (windows != null) {
          return windows!(context);
        }
      }

      if (platform == TargetPlatform.macOS) {
        if (macos != null) {
          return macos!(context);
        }
      }
      if (platform == TargetPlatform.iOS) {
        if (ios != null) {
          return ios!(context);
        }
      }
      if (platform == TargetPlatform.android) {
        if (android != null) {
          return android!(context);
        }
      }

      // If none of the layouts above are supplied or we're on the mobile layout then we show the mobile layout
      return ios != null
          ? ios!(context)
          : android != null
          ? android!(context)
          : const SizedBox.shrink();
    },
  );
}
