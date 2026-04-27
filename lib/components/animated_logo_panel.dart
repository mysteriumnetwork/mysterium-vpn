import 'package:flutter/material.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn_design/styles/styles.dart';

class AnimatedLogoPanel extends StatelessWidget {
  const AnimatedLogoPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ColoredBox(
      color: theme.palette.bgPrimary,
      child: Stack(
        children: [
          Asset.animations.backgroundElements.lottie(),
          Center(child: Asset.animations.circlesLogo.lottie(repeat: false)),
        ],
      ),
    );
  }
}
