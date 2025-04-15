import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/banner_type.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/components/banners/data_center_banner.dart';
import 'package:mysterium_vpn/components/banners/unauthenticated_banner.dart';
import 'package:mysterium_vpn/components/no_subscription_banner.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class HomeBanner extends HookConsumerWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannersStore = ref.watch(bannersStorePOD);
    final banner = useComputedValue(() => bannersStore.mainBanner);

    if (banner == null) {
      return const SizedBox.shrink();
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: switch (banner) {
          BannerType.subscription => const NoSubscriptionBanner(),
          BannerType.datacenter => const DataCenterBanner(),
          BannerType.unauthenticated => const UnauthenticatedBanner(),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }
}
