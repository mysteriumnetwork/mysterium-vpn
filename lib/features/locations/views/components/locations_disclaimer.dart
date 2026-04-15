import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide Banner;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/home/store/banners_store.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class LocationsDisclaimer extends StatelessWidget {
  const LocationsDisclaimer({
    required this.text,
    required this.bannerType,
    this.tooltip,
    this.tooltipMsg,
    super.key,
  });

  factory LocationsDisclaimer.residential() => LocationsDisclaimer(
    text: LocaleKeys.ipTypeResidentialDisclaimer.tr(),
    bannerType: BannerType.residentialIPs,
    tooltip: TooltipIcon.titled(
      title: LocaleKeys.ipTypeResidentialTooltipTitle.tr(),
      body: LocaleKeys.ipTypeResidentialTooltipBody.tr(),
    ),
  );

  factory LocationsDisclaimer.dataCenter() => LocationsDisclaimer(
    text: LocaleKeys.ipTypeDataCenterDisclaimer.tr(),
    bannerType: BannerType.highSpeedIPs,
  );

  final String text;
  final BannerType bannerType;
  final String? tooltipMsg;
  final TooltipIcon? tooltip;

  @override
  Widget build(BuildContext context) {
    final bannersStore = getIt<BannersStore>();
    final analyticsStore = getIt<AnalyticsStore>();
    void handleDismiss() {
      if (bannerType == BannerType.residentialIPs) {
        bannersStore.setShown(BannerType.residentialIPs);
        analyticsStore.logBannerClose(BannerType.residentialIPs);
      } else if (bannerType == BannerType.highSpeedIPs) {
        bannersStore.setShown(BannerType.highSpeedIPs);
        analyticsStore.logBannerClose(BannerType.highSpeedIPs);
      }
    }

    return Observer(
      builder: (context) {
        if (!bannersStore.canShow(bannerType)) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: MinimalAlert(
            message: text,
            tooltip: tooltip,
            tooltipMsg: tooltipMsg,
            onDismiss: handleDismiss,
          ),
        );
      },
    );
  }
}
