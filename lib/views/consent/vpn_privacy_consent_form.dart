// ignore_for_file: use_build_context_synchronously

import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/routes.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/header_title.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/views/consent/agreements.dart';
import 'package:styled_widget/styled_widget.dart';

class VpnPrivacyConsentForm extends HookConsumerWidget {
  const VpnPrivacyConsentForm({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final height = getMediaHeight(context);
    return Column(
      children: [
        HeaderTitle(
          text: LocaleKeys.privacyPriority.tr(),
        ),
        EasyText(
          ' ${LocaleKeys.privacyPriorityText.tr()}',
          fontWeight: FontWeight.w700,
          maxLines: 30,
          fontSize: 14,
        ).expanded(),
        const Agreements().padding(bottom: height * 0.02, top: height * 0.02),
        EasyButton(
          useSystemColor: false,
          color: Palette.purple,
          width: 250,
          onPressed: () {
            context.beamToReplacementNamed(Routes.vpnConfigConsent.toRoute);
          },
          child: EasyText(
            LocaleKeys.acceptAndContinue.tr(),
            color: Palette.white,
          ),
        ).padding(bottom: height * 0.03),
      ],
    ).padding(horizontal: 20);
  }
}
