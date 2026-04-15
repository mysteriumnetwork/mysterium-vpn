import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Palette.darkBlue,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgIcon(asset: Asset.logo.splashLogo),
          const SizedBox(height: 20),
          const LoadingIndicator(indicatorColor: Palette.purple),
        ],
      ),
    ),
  );
}
