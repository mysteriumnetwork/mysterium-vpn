import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/home/store/banners_store.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

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

    return AlertModal(
      type: AlertModalType.info,
      title: LocaleKeys.appUpdateAvailableTitle.tr(),
      supportingText: LocaleKeys.appUpdateAvailableDesc.tr(),
      onClose: handleDismiss,
      primaryButton: ButtonPrimary(
        size: ButtonSize.small,
        onPressed: handlePressed,
        child: Text(LocaleKeys.updateBtn.tr()),
      ),
    );
  }
}
