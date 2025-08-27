import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';
import 'package:mysterium_vpn/common/styles/style.dart';

class AnimatedLogoPanel extends HookWidget {
  const AnimatedLogoPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ColoredBox(
      color: theme.palette.backgroundColor,
      child: Stack(
        children: [
          Lottie.asset(Assets.backgroundElements),
          Center(child: Lottie.asset(Assets.circlesLogo, repeat: false)),
        ],
      ),
    );
  }
}
