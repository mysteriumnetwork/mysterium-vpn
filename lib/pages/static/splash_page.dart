import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/colored_scaffold.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredScaffold(
      backgroundColor: Palette.black,
      body: Center(child: Lottie.asset(Assets.splashLogo)),
    );
  }
}
