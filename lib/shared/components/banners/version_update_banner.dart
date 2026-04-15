import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide Banner;
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/home/store/banners_store.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn/shared/components/banners/banner.dart';
import 'package:mysterium_vpn/shared/components/banners/banner_body.dart';
import 'package:mysterium_vpn/shared/components/banners/banner_cta.dart';
import 'package:mysterium_vpn/shared/components/banners/banner_title.dart';

class AppVersionUpdateBanner extends StatelessWidget {
  const AppVersionUpdateBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final analyticsStore = getIt<AnalyticsStore>();
    final bannersStore = getIt<BannersStore>();

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
      cta: BannerCTA(text: LocaleKeys.updateBtn.tr(), onPressed: handlePressed),
      onPressed: handlePressed,
      onDismiss: handleDismiss,
    );
  }
}
