import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/responsive_value_hook.dart';
import 'package:mysterium_vpn/components/banners/too_many_connections_banner.dart';
import 'package:mysterium_vpn/components/banners/unauthenticated_banner.dart';
import 'package:mysterium_vpn/components/banners/version_update_banner.dart';
import 'package:mysterium_vpn/components/subscription_banner.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class HomeBanner extends HookConsumerWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannersStore = ref.watch(bannersStorePOD);
    final banner = useComputedValue(() => bannersStore.mainBanner);
    final maxWidth = useResponsiveValue<double>(double.infinity, desktop: 432);

    if (banner == null) {
      return const SizedBox.shrink();
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: switch (banner) {
              BannerType.subscription => const SubscriptionBanner(),
              BannerType.unauthenticated => const UnauthenticatedBanner(),
              BannerType.tooManyConnections => const TooManyConnectionsBanner(),
              BannerType.appUpdateAvailable => const AppVersionUpdateBanner(),
              _ => const SizedBox.shrink(),
            },
          ),
        ),
      ),
    );
  }
}
