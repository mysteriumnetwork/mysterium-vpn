import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide Banner;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/banners/banner.dart';
import 'package:mysterium_vpn/components/banners/banner_body.dart';
import 'package:mysterium_vpn/components/banners/banner_cta.dart';
import 'package:mysterium_vpn/components/banners/banner_title.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class TooManyConnectionsBanner extends HookConsumerWidget {
  const TooManyConnectionsBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnStore = ref.watch(vpnStorePOD);
    final isConnected = useComputedValue(() => vpnStore.isConnected);

    Future<void> handleDisconnect() async {
      await vpnStore.disconnectWireguard();
      vpnStore.connectionLimitReached = false;
    }

    return Banner(
      color: Palette.darkOliveBrown,
      borderColor: Palette.yellow,
      title: BannerTitle(
        text: LocaleKeys.tooManyConnectionsBannerTitle.tr(),
        icon: const Icon(Icons.info_outline_rounded),
      ),
      body: BannerBody(
        text: isConnected
            ? LocaleKeys.tooManyConnectionsBannerDescConnected.tr()
            : LocaleKeys.tooManyConnectionsBannerDesc.tr(),
      ),
      cta: BannerCTA(
        color: Palette.yellow,
        onPressed: handleDisconnect,
        text: isConnected
            ? LocaleKeys.tooManyConnectionsBannerCTADisconnect.tr()
            : LocaleKeys.tooManyConnectionsBannerCTAReconnect.tr(),
      ),
    );
  }
}
