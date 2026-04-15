import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/home/store/banners_store.dart';
import 'package:mysterium_vpn/service_locator.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final bannersStore = getIt<BannersStore>();
    final screenType = getScreenType(MediaQuery.sizeOf(context));
    final maxWidth = screenType >= ScreenType.desktop ? 432.0 : double.infinity;

    return Observer(
      builder: (_) {
        final banner = bannersStore.mainBanner;

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
      },
    );
  }
}
