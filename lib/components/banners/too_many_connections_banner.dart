import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide Banner;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/components/banners/banner.dart';
import 'package:mysterium_vpn/components/banners/banner_body.dart';
import 'package:mysterium_vpn/components/banners/banner_cta.dart';
import 'package:mysterium_vpn/components/banners/banner_title.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class TooManyConnectionsBanner extends HookConsumerWidget {
  const TooManyConnectionsBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnStore = ref.watch(vpnStorePOD);
    final connectionsLimitStore = ref.watch(connectionsLimitStorePOD);

    final handleToggleConnection = useHandleToggleConnection();
    final isConnected = useComputedValue(() => vpnStore.isConnected);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bannerStyle = isDark ? BannerStyle.warningDark : BannerStyle.warningLight;

    Future<void> handleDisconnect() async {
      await handleToggleConnection();
      connectionsLimitStore.connectionLimitReached = false;
    }

    return Banner(
      style: bannerStyle,
      title: BannerTitle(
        text: LocaleKeys.tooManyConnectionsBannerTitle.tr(),
        icon: SvgIcon(
          color: bannerStyle.foregroundColor,
          asset: Asset.icons.infoOutline,
          width: 20,
          height: 20,
        ),
      ),
      body: BannerBody(
        text: isConnected
            ? LocaleKeys.tooManyConnectionsBannerDescConnected.tr()
            : LocaleKeys.tooManyConnectionsBannerDesc.tr(),
      ),
      cta: BannerCTA(
        onPressed: handleDisconnect,
        text: isConnected
            ? LocaleKeys.tooManyConnectionsBannerCTADisconnect.tr()
            : LocaleKeys.tooManyConnectionsBannerCTAReconnect.tr(),
      ),
    );
  }
}
