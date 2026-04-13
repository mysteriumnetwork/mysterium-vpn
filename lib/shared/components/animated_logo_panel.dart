import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';

class AnimatedLogoPanel extends HookWidget {
  const AnimatedLogoPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ColoredBox(
      color: theme.palette.backgroundColor,
      child: Stack(
        children: [
          Asset.animations.backgroundElements.lottie(),
          Center(child: Asset.animations.circlesLogo.lottie(repeat: false)),
        ],
      ),
    );
  }
}
