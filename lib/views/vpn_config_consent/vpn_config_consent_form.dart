// ignore_for_file: use_build_context_synchronously

import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/routes.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/header_title.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final subscriptionStore = ref.watch(subscriptionStorePOD);
    final environment = ref.watch(environmentPOD);

    return Column(
      children: [
        HeaderTitle(
          text: LocaleKeys.weNeedPermission.tr(),
        ).padding(bottom: height * 0.02),
        const SvgIcon(
          asset: Assets.settingsImg,
        ).padding(bottom: height * 0.03),
        EasyText(
          LocaleKeys.installVpnProfile.tr(),
          fontSize: 16,
          fontWeight: FontWeight.w700,
          maxLines: 3,
          textAlign: TextAlign.center,
        ).padding(bottom: height * 0.05),
        EasyText(
          LocaleKeys.anonimityIsSafe.tr(),
          fontSize: 16,
          maxLines: 3,
          textAlign: TextAlign.center,
        ).padding(bottom: height * 0.05),
        RichText(
          maxLines: 2,
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            children: [
              TextSpan(text: LocaleKeys.readOur.tr()),
              TextSpan(
                text: LocaleKeys.privacyPolicy.tr(),
                style: const TextStyle(
                  color: Palette.pink,
                  decoration: TextDecoration.underline,
                ),
                mouseCursor: MaterialStateMouseCursor.clickable,
                recognizer: TapGestureRecognizer()
                  ..onTap = () => launchUrl(Uri.parse(privacyPolicyUrl)),
              ),
              TextSpan(text: LocaleKeys.moreInfo.tr()),
            ],
          ),
        ).padding(bottom: height * 0.05),
        Observer(
          builder: (context) => EasyButton(
            useSystemColor: false,
            color: Palette.purple,
            width: 250,
            onPressed: () async {
              await vpnStore.setVpnConfigConsent(value: true);
              if (isMounted()) {
                subscriptionStore.isSubscribed == false
                    ? !isMobilePaymentGateway(subscriptionStore.subscription?.gateway)
                        ? launchUrl(Uri.parse(environment.values.billingPage))
                        : context.beamToNamed(Routes.subscription.toRoute)
                    : context.beamBack();
              }
            },
            child: EasyText(
              LocaleKeys.acceptAndContinue.tr(),
              color: Palette.white,
            ),
          ).padding(bottom: height * 0.01),
        ),
      ],
    ).scrollable().padding(horizontal: 20);
  }
}
