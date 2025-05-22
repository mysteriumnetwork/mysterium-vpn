import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        backgroundColor: Palette.darkBlue,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgIcon(
                asset: Assets.splashLogo,
              ),
              SizedBox(height: 20),
              LoadingIndicator(
                indicatorColor: Palette.purple,
              ),
            ],
          ),
        ),
      );
}
