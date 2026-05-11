import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/views/home/home_banner.dart';
import 'package:mysterium_vpn/views/home/home_map.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class HomeConnectionView extends HookConsumerWidget {
  const HomeConnectionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenType = ScreenType.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ConnectionStatusBar(),
        const PromoBanner(),
        Expanded(
          child: Stack(
            children: [
              const Positioned.fill(child: HomeMap()),
              Positioned(
                left: 0,
                right: 0,

                top: switch (screenType) {
                  ScreenType.tablet || ScreenType.desktop => 40,
                  _ => 8,
                },
                child: const HomeBanner(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
