import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/breakpoints/screen_size_breakpoints.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/layout_builders/responsive_layout_builder.dart';

/// Each builder will get built based on the current device width.
/// [screenSizeBreakpoint] define your own custom device resolutions
/// [extraLarge] will be built if width is greater than 2160 on Desktops, 1280 on Tablets, and 650 on Mobiles
/// [large] will be built when width is greater than 1440 on Desktops, 1024 on Tablets, and 414 on Mobiles
/// [normal] will be built when width is greater than 1080 on Desktops, 768 on Tablets, and 375 on Mobiles
/// [small] will be built if width is less than 720 on Desktops, 650 on Tablets, and 320 on Mobiles
class ScreenSizeLayoutBuilder extends StatelessWidget {
  const ScreenSizeLayoutBuilder({
    required this.normal,
    this.screenSizeBreakpoint,
    this.extraLarge,
    this.large,
    this.small,
    super.key,
  });
  final ScreenSizeBreakpoint? screenSizeBreakpoint;

  final WidgetBuilder? extraLarge;
  final WidgetBuilder? large;
  final WidgetBuilder normal;
  final WidgetBuilder? small;

  @override
  Widget build(BuildContext context) => ResponsiveLayoutBuilder(
    screenSizeBreakpoints: screenSizeBreakpoint,
    builder: (context, screenSizeConfiguration) {
      // If we're at extra large size
      if (screenSizeConfiguration.sizeType == SizeType.extraLarge) {
        // If we have supplied the extra large layout then display that
        if (extraLarge != null) {
          return extraLarge!(context);
        }
        // If no extra large layout is supplied we want to check if we have the size below it and display that
        if (large != null) {
          return large!(context);
        }
      }

      if (screenSizeConfiguration.sizeType == SizeType.large) {
        // If we have supplied the large layout then display that
        if (large != null) {
          return large!(context);
        }
        // If no large layout is supplied we want to check if we have the size below it and display that
        return normal(context);
      }

      if (screenSizeConfiguration.sizeType == SizeType.small) {
        // If we have supplied the small layout then display that
        if (small != null) {
          return small!(context);
        }
      }

      // If none of the layouts above are supplied or we're on the small size layout then we show the small layout
      return normal(context);
    },
  );
}
