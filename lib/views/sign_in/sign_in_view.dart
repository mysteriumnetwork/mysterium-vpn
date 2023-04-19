import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/loading_barrier.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/sign_in/sign_in_form.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class SignInView extends ConsumerWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStore = ref.watch(authStorePOD);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        bottom: false,
        child: Observer(
          builder: (context) => Stack(
            children: [
              Column(
                children: [
                  EasyText(
                    LocaleKeys.signIn.tr(),
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ).padding(top: 10, bottom: 30),
                  const SignInForm().padding(bottom: 30),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      children: [
                        TextSpan(text: '${LocaleKeys.signInDisclaimer.tr()} '),
                        TextSpan(
                          text: LocaleKeys.termsAndConditions.tr(),
                          style: const TextStyle(
                            color: Palette.pink,
                            decoration: TextDecoration.underline,
                          ),
                          mouseCursor: MaterialStateMouseCursor.clickable,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => launchUrl(Uri.parse(termsOfServiceUrl)),
                        ),
                        TextSpan(text: '${LocaleKeys.and.tr()} '),
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
                      ],
                    ),
                  ),
                ],
              ).scrollable().paddingDirectional(all: 20),
              if (authStore.authStatus == AuthStatus.authenticating)
                LoadingBarrier(color: Theme.of(context).primaryColor),
            ],
          ),
        ),
      ),
    );
  }
}
