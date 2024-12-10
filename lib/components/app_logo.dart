import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.brightness,
  });

  final Brightness? brightness;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = this.brightness ?? theme.brightness;

    return SvgIcon(
      asset: switch (brightness) {
        Brightness.dark => Assets.logoWhiteSvg,
        Brightness.light => Assets.logoBlackSvg,
      },
    );
  }
}
