import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/hooks/scaffold_brightness_hook.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';

class AppLogo extends HookWidget {
  const AppLogo({
    super.key,
    this.brightness,
  });

  final Brightness? brightness;

  @override
  Widget build(BuildContext context) {
    final scaffoldBrightness = useScaffoldBrightness();
    final brightness = this.brightness ?? scaffoldBrightness;

    return SvgIcon(
      asset: switch (brightness) {
        Brightness.dark => Asset.logo.logoWhite,
        Brightness.light => Asset.logo.logoBlack,
      },
    );
  }
}
