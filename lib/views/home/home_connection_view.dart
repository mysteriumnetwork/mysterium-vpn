import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mysterium_vpn/common/enums/screen_type.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/responsive_value_hook.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/components/connection_status_bar.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/home_banner.dart';
import 'package:mysterium_vpn/views/home/home_connect_button.dart';

class HomeConnectionView extends HookConsumerWidget {
  const HomeConnectionView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannersStore = ref.watch(bannersStorePOD);

    final hasBanner = useComputedValue(() => bannersStore.mainBanner != null);

    final screenType = useScreenType();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ConnectionStatusBar(),
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(child: Lottie.asset(Assets.backgroundElements)),
              Column(
                children: [
                  const Expanded(child: Center(child: Center(child: HomeConnectButton()))),
                  SizedBox(height: hasBanner ? 72 : 32),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: switch (screenType) {
                  ScreenType.tablet => 182,
                  ScreenType.desktop => 172,
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
