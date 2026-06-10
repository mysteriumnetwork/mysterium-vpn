import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide Banner;
import 'package:flutter_hooks/flutter_hooks.dart';
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
    required this.title,
    required this.leadingIcon,
    this.tooltipTitle,
    this.tooltipBody,
    super.key,
  });

  factory LocationsDisclaimer.residential() => LocationsDisclaimer(
    title: LocaleKeys.ipTypeResidential.tr(),
    text: LocaleKeys.ipTypeResidentialDisclaimer.tr(),
    bannerType: BannerType.residentialIPs,
    leadingIcon: UntitledUI.home_03,
    tooltipTitle: LocaleKeys.ipTypeResidentialTooltipTitle.tr(),
    tooltipBody: LocaleKeys.ipTypeResidentialTooltipBody.tr(),
  );

  factory LocationsDisclaimer.dataCenter() => LocationsDisclaimer(
    title: LocaleKeys.ipTypeDataCenter.tr(),
    text: LocaleKeys.ipTypeDataCenterDisclaimer.tr(),
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
    final anchorKey = useMemoized(GlobalKey.new);

    void openTooltip() {
      analyticsStore.logEvent(AnalyticsEvent.residentialInfoTooltipShown);
      showInfoPopover(
        context: context,
        anchorKey: anchorKey,
        title: tooltipTitle!,
        body: tooltipBody ?? '',
        actionLabel: LocaleKeys.residentialEducationGotIt.tr(),
        onDismiss: () => analyticsStore.logEvent(AnalyticsEvent.residentialInfoTooltipDismissed),
      );
    }

    final titleAction = tooltipTitle == null
        ? null
        : GestureDetector(
            key: anchorKey,
            behavior: HitTestBehavior.opaque,
            onTap: openTooltip,
            child: Icon(UntitledUI.info_circle, size: 16, color: theme.palette.textTertiary),
          );

    return Observer(
      builder: (context) {
        if (!bannersStore.canShow(bannerType)) {
          return const SizedBox.shrink();
        }
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
