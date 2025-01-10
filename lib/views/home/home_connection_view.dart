import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/components/connection_bar.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/home_banner.dart';
import 'package:mysterium_vpn/views/home/home_connect_button.dart';

class HomeConnectionView extends HookConsumerWidget {
  const HomeConnectionView({
    super.key,
    this.header,
  });

  final Widget? header;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final abTestingStore = ref.watch(abTestingStorePOD);
    final bannersStore = ref.watch(bannersStorePOD);

    final bannerDisplayVariant = useComputedValue(() => abTestingStore.bannerDisplayVariant);
    final hasBanner = useComputedValue(() => bannersStore.banner != null);

    return Stack(
      children: [
        Positioned.fill(child: Lottie.asset(Assets.backgroundElements)),
        Column(
          children: [
            if (header != null) header!,
            const SizedBox(height: 20),
            const MobileConnectionStatusBar(),
            const Expanded(child: HomeConnectButton()),
            SizedBox(height: hasBanner ? 64 : 32),
          ],
        ),
        if (hasBanner && bannerDisplayVariant == 'A')
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: HomeBanner(),
          ),
      ],
    );
  }
}
