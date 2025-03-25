import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/connection_tile.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/home_banner.dart';
import 'package:mysterium_vpn/views/home/home_connection_view.dart';

class HomeDesktopRightPanel extends HookConsumerWidget {
  const HomeDesktopRightPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final abTestingStore = ref.watch(abTestingStorePOD);
    final bannerDisplayVariant = useComputedValue(() => abTestingStore.bannerDisplayVariant);

    return DecoratedBox(
      decoration: const BoxDecoration(color: Palette.darkBlue),
      child: Stack(
        children: [
          const HomeConnectionView(),
          Positioned(
            bottom: 48,
            left: 36,
            right: 36,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 432),
                child: const ConnectionTile(),
              ),
            ),
          ),
          switch (bannerDisplayVariant) {
            'B' => const Positioned(
                top: 24,
                left: 0,
                right: 0,
                child: HomeBanner(),
              ),
            'C' => const Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: HomeBanner(),
              ),
            _ => const SizedBox.shrink(),
          },
        ],
      ),
    );
  }
}
