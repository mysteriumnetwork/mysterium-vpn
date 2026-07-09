import 'package:flutter/material.dart' hide Banner;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class LocationsDisclaimer extends ConsumerWidget {
  const LocationsDisclaimer({
    required this.text,
    required this.bannerType,
    required this.title,
    required this.leadingIcon,
    this.tooltipTitle,
    this.tooltipBody,
    super.key,
  });

  factory LocationsDisclaimer.residential() => LocationsDisclaimer(
    title: S.current.ipTypeResidential,
    text: S.current.ipTypeResidentialDisclaimer,
    bannerType: BannerType.residentialIPs,
    leadingIcon: UntitledUI.home_03,
    tooltipTitle: S.current.ipTypeResidentialTooltipTitle,
    tooltipBody: S.current.ipTypeResidentialTooltipBody,
  );

  factory LocationsDisclaimer.dataCenter() => LocationsDisclaimer(
    title: S.current.ipTypeDataCenter,
    text: S.current.ipTypeDataCenterDisclaimer,
    bannerType: BannerType.highSpeedIPs,
    leadingIcon: UntitledUI.zap_fast,
  );

  final String text;
  final String title;
  final IconData leadingIcon;
  final BannerType bannerType;
  final String? tooltipTitle;
  final String? tooltipBody;

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

    final theme = Theme.of(context);

    return Observer(
      builder: (context) {
        if (!bannersStore.canShow(bannerType)) {
          return const SizedBox.shrink();
        }
        final titleAction = tooltipTitle == null
            ? null
            : TooltipIcon.titled(
                title: tooltipTitle!,
                body: tooltipBody ?? '',
                icon: UntitledUI.info_circle,
                color: theme.palette.textTertiary,
                onTriggered: () =>
                    analyticsStore.logEvent(AnalyticsEvent.residentialInfoTooltipShown),
              );
        return Padding(
          padding: EdgeInsets.only(bottom: theme.spacing.s),
          child: MinimalAlert(
            title: title,
            leadingIcon: leadingIcon,
            message: text,
            titleAction: titleAction,
            onDismiss: handleDismiss,
          ),
        );
      },
    );
  }
}
