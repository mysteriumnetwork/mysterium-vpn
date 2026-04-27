import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/features/home/views/home_banner.dart';
import 'package:mysterium_vpn/features/home/views/home_map.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class HomeConnectionView extends StatelessWidget {
  const HomeConnectionView({super.key});

  @override
  Widget build(BuildContext context) {
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
                  ScreenType.mobile => 10.0,
                  ScreenType.tablet => 40.0,
                  ScreenType.desktop => 40.0,
                  _ => null,
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
