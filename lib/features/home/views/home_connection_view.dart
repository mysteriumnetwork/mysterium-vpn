import 'package:flutter/material.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/home/views/home_banner.dart';
import 'package:mysterium_vpn/features/home/views/home_map.dart';
import 'package:mysterium_vpn/shared/components/banners/promotional_banner.dart';
import 'package:mysterium_vpn/shared/components/connection_status_bar.dart';

class HomeConnectionView extends StatelessWidget {
  const HomeConnectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenType = getScreenType(MediaQuery.sizeOf(context));

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
