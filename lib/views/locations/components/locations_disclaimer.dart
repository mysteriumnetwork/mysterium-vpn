import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide Banner;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class LocationsDisclaimer extends HookConsumerWidget {
  const LocationsDisclaimer({
    required this.text,
    required this.bannerType,
    this.tooltip,
    this.tooltipMsg,
    this.tooltipTitle,
    this.tooltipBody,
    super.key,
  });

  factory LocationsDisclaimer.residential() => LocationsDisclaimer(
    text: LocaleKeys.ipTypeResidentialDisclaimer.tr(),
    bannerType: BannerType.residentialIPs,
    tooltipTitle: LocaleKeys.ipTypeResidentialTooltipTitle.tr(),
    tooltipBody: LocaleKeys.ipTypeResidentialTooltipBody.tr(),
  );

  factory LocationsDisclaimer.dataCenter() => LocationsDisclaimer(
    text: LocaleKeys.ipTypeDataCenterDisclaimer.tr(),
    bannerType: BannerType.highSpeedIPs,
  );

  final String text;
  final BannerType bannerType;
  final String? tooltipMsg;
  final String? tooltipTitle;
  final String? tooltipBody;
  final TooltipIcon? tooltip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannersStore = ref.watch(bannersStorePOD);
    final analyticsStore = ref.watch(analyticsStorePOD);
    void handleDismiss() {
      if (bannerType == BannerType.residentialIPs) {
        bannersStore.setShown(BannerType.residentialIPs);
        analyticsStore.logBannerClose(BannerType.residentialIPs);
      } else if (bannerType == BannerType.highSpeedIPs) {
        bannersStore.setShown(BannerType.highSpeedIPs);
        analyticsStore.logBannerClose(BannerType.highSpeedIPs);
      }
    }

    final spacing = Theme.of(context).spacing;
    return Observer(
      builder: (context) {
        if (!bannersStore.canShow(bannerType)) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: EdgeInsets.only(bottom: spacing.s),
          child: MinimalAlert(
            message: text,
            tooltip: tooltip,
            tooltipMsg: tooltipMsg,
            tooltipTitle: tooltipTitle,
            tooltipBody: tooltipBody,
            onDismiss: handleDismiss,
          ),
        );
      },
    );
  }
}
