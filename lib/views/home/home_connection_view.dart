import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/responsive_value_hook.dart';
import 'package:mysterium_vpn/components/connection_status_bar.dart';
import 'package:mysterium_vpn/views/home/home_banner.dart';
import 'package:mysterium_vpn/views/home/home_map.dart';
import 'package:mysterium_vpn/components/banners/in_app_message_banner.dart';

class HomeConnectionView extends HookConsumerWidget {
  const HomeConnectionView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenType = useScreenType();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ConnectionStatusBar(),
        const InAppMessageBanner(),
        Expanded(
          child: Stack(
            children: [
              const Positioned.fill(child: HomeMap()),
              Positioned(
                left: 0,
                right: 0,
                bottom: switch (screenType) {
                  ScreenType.tablet => 222,
                  ScreenType.desktop => 212,
                  _ => null,
                },
                top: screenType == ScreenType.mobile ? 10 : null,
                child: const HomeBanner(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
