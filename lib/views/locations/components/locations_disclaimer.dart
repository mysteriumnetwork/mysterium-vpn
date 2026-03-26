import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide Banner;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/components/banners/banner.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class LocationsDisclaimer extends HookConsumerWidget {
  const LocationsDisclaimer({required this.text, required this.bannerType, super.key});

  factory LocationsDisclaimer.residential() => LocationsDisclaimer(
    text: LocaleKeys.ipTypeResidentialDisclaimer.tr(),
    bannerType: BannerType.residentialIPs,
  );

  factory LocationsDisclaimer.dataCenter() => LocationsDisclaimer(
    text: LocaleKeys.ipTypeDataCenterDisclaimer.tr(),
    bannerType: BannerType.highSpeedIPs,
  );

  final String text;
  final BannerType bannerType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
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

    return Observer(
      builder: (context) {
        if (!bannersStore.canShow(bannerType)) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Banner(
            style: BannerStyle.info.copyWith(
              backgroundColor: theme.colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onDismiss: handleDismiss,
            title: SizedBox(
              width: double.infinity,
              child: EasyText(text, fontSize: 12, maxLines: 2, textAlign: TextAlign.left),
            ),
            mainBanner: false,
          ),
        );
      },
    );
  }
}
