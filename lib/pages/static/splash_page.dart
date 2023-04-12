import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/colored_scaffold.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) => const ColoredScaffold(
        backgroundColor: Palette.darkBlue,
        body: Center(
          child: SvgIcon(
            asset: Assets.splashLogo,
          ),
        ),
      );
}
