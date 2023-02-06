import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/app_logo.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/login_headlines.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/pages/sign_up_page.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginMobileView extends HookConsumerWidget {
  const LoginMobileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStore = ref.watch(authStorePOD);

    return Column(
      children: [
        const AppLogo().padding(top: 30, bottom: 10),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const Expanded(
                  child: LoginHeadlines(
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      EasyButton(
                        width: getMediaWidth(context) * 0.8,
                        height: 60,
                        text: LocaleKeys.signIn.tr(),
                        onPressed: () {
                          authStore.login();
                        },
                      ).padding(bottom: 20),
                      EasyButton(
                        width: getMediaWidth(context) * 0.8,
                        height: 60,
                        useSystemColor: false,
                        text: LocaleKeys.getStarted.tr(),
                        onPressed: () {
                          if (Platform.isAndroid || Platform.isIOS) {
                            _showSignInView(context);
                          }
                        },
                      ).padding(bottom: 30),
                      TextButton(
                        onPressed: () {},
                        child: EasyText(
                          LocaleKeys.getHelp.tr(),
                          color: Palette.lightBlack,
                          fontSize: 12,
                        ),
                      )
                    ],
                  ).padding(bottom: 20, top: 30),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showSignInView(BuildContext context) {
    showBarModalBottomSheet(
      expand: false,
      context: context,
      backgroundColor: Palette.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => const SignUpPage(),
    );
  }
}
