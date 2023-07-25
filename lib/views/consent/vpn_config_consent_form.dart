// ignore_for_file: use_build_context_synchronously

import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/header_title.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/consent/agreements.dart';
import 'package:styled_widget/styled_widget.dart';

class VpnConfigConsentForm extends HookConsumerWidget {
  const VpnConfigConsentForm({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final vpnStore = ref.watch(vpnStorePOD);
    final height = getMediaHeight(context);
    final isMounted = useIsMounted();

    return Column(
      children: [
        HeaderTitle(
          text: LocaleKeys.weNeedPermission.tr(),
        ).padding(bottom: height * 0.01),
        Column(
          children: [
            const SvgIcon(
              asset: Assets.settingsImg,
            ).padding(bottom: height * 0.02),
            EasyText(
              LocaleKeys.installVpnProfile.tr(),
              fontSize: 16,
              fontWeight: FontWeight.w700,
              maxLines: 3,
              textAlign: TextAlign.center,
            ).padding(bottom: height * 0.03),
            EasyText(
              LocaleKeys.anonimityIsSafe.tr(),
              fontSize: 16,
              maxLines: 3,
              textAlign: TextAlign.center,
            ).padding(bottom: height * 0.03),
          ],
        ).scrollable().expanded(),
        const Agreements().padding(vertical: height * 0.02),
        EasyButton(
          useSystemColor: false,
          color: Palette.purple,
          width: 250,
          onPressed: () async {
            await vpnStore.setVpnConfigConsent(value: true);
            if (isMounted()) {
              ref.read(subscriptionStorePOD).fetchSubscription();
              context.beamBack();
            }
          },
          child: EasyText(
            LocaleKeys.acceptAndContinue.tr(),
            color: Palette.white,
          ),
        ).padding(bottom: height * 0.045),
      ],
    ).padding(horizontal: 20);
  }
}
