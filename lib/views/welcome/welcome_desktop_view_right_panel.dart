import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';

class WelcomeDesktopViewRightPanel extends HookWidget {
  const WelcomeDesktopViewRightPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController();
    return Container(
      height: double.infinity,
      color: Palette.darkBlue,
      child: Stack(
        children: [
          Lottie.asset(Assets.backgroundElements),
          Center(
            child: Lottie.asset(
              Assets.circlesLogo,
              controller: controller,
              onLoaded: (comp) {
                controller
                  ..duration = comp.duration
                  ..forward();
              },
            ),
          ),
        ],
      ),
    );
  }
}
