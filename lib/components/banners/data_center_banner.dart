import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide Banner;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/components/banners/banner.dart';
import 'package:mysterium_vpn/components/banners/banner_body.dart';
import 'package:mysterium_vpn/components/banners/banner_cta.dart';
import 'package:mysterium_vpn/components/banners/banner_title.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/home_state.dart';

class DataCenterBanner extends HookConsumerWidget {
  const DataCenterBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsStore = ref.watch(analyticsStorePOD);
    final bannersStore = ref.watch(bannersStorePOD);

    Future<void> handlePressed() async {
      analyticsStore.logBannerClick(BannerType.datacenter);

      final homeState = ref.read(homeStateProvider);
      homeState
        ..ipType = IPType.datacenter
        ..show(homeState.typeSwitcherKey);

      bannersStore.setShown(BannerType.datacenter);
    }

    void handleDismiss() {
      analyticsStore.logBannerClose(BannerType.datacenter);
      bannersStore.setShown(BannerType.datacenter);
    }

    return Banner(
      title: BannerTitle(
        icon: const SvgIcon(asset: Assets.speed),
        text: LocaleKeys.dataCenterBannerTitle.tr(),
      ),
      body: BannerBody(text: LocaleKeys.dataCenterBannerDesc.tr()),
      cta: BannerCTA(
        text: LocaleKeys.dataCenterBannerBtn.tr(),
        onPressed: handlePressed,
      ),
      onPressed: handlePressed,
      onDismiss: handleDismiss,
    );
  }
}
