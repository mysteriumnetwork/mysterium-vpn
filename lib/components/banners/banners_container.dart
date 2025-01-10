import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/banner_type.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/components/banners/data_center_banner.dart';
import 'package:mysterium_vpn/components/no_subscription_banner.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class BannersContainer extends HookConsumerWidget {
  const BannersContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(bannersStorePOD);
    final banner = useComputedValue(() => store.banners.firstOrNull);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 24, right: 24),
        child: switch (banner) {
          BannerType.subscription => const NoSubscriptionBanner(),
          BannerType.datacenter => const DataCenterBanner(),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }
}
