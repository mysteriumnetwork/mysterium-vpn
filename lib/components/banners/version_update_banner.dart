import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide Banner;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/banners/banner.dart';
import 'package:mysterium_vpn/components/banners/banner_body.dart';
import 'package:mysterium_vpn/components/banners/banner_cta.dart';
import 'package:mysterium_vpn/components/banners/banner_title.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class AppVersionUpdateBanner extends HookConsumerWidget {
  const AppVersionUpdateBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsStore = ref.watch(analyticsStorePOD);
    final bannersStore = ref.watch(bannersStorePOD);

    Future<void> handlePressed() async {
      analyticsStore.logBannerClick(BannerType.appUpdateAvailable);
      await openAppStorePage();
    }

    void handleDismiss() {
      analyticsStore.logBannerClose(BannerType.appUpdateAvailable);
      bannersStore.setShown(BannerType.appUpdateAvailable);
    }

    return Banner(
      title: BannerTitle(
        iconAsset: Asset.icons.appUpdate,
        text: LocaleKeys.appUpdateAvailableTitle.tr(),
      ),
      body: BannerBody(text: LocaleKeys.appUpdateAvailableDesc.tr()),
      cta: BannerCTA(
        text: LocaleKeys.updateBtn.tr(),
        onPressed: handlePressed,
      ),
      onPressed: handlePressed,
      onDismiss: handleDismiss,
    );
  }
}
