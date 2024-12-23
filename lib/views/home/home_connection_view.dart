import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mysterium_vpn/common/enums/banner_type.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/components/banners/data_center_banner.dart';
import 'package:mysterium_vpn/components/connection_bar.dart';
import 'package:mysterium_vpn/components/no_subscription_banner.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/home_connect_button.dart';

class HomeConnectionView extends HookConsumerWidget {
  const HomeConnectionView({
    super.key,
    this.header,
  });

  final Widget? header;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannersStore = ref.watch(bannersStorePOD);
    final banner = useComputedValue(() => bannersStore.banner);

    return Stack(
      children: [
        Positioned.fill(child: Lottie.asset(Assets.backgroundElements)),
        Column(
          children: [
            if (header != null) header!,
            const SizedBox(height: 20),
            const MobileConnectionStatusBar(),
            const Expanded(child: HomeConnectButton()),
            SizedBox(height: banner == null ? 32 : 120),
          ],
        ),
        if (banner != null) _Banner(type: banner),
      ],
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.type});

  final BannerType type;

  @override
  Widget build(BuildContext context) => Positioned(
        left: 0,
        bottom: 72,
        right: 0,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
            child: switch (type) {
              BannerType.subscription => const NoSubscriptionBanner(),
              BannerType.datacenter => const DataCenterBanner(),
            },
          ),
        ),
      );
}
