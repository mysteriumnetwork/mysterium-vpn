import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/app_logo.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/login_headlines.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:styled_widget/styled_widget.dart';

class LoginMobileView extends HookConsumerWidget {
  const LoginMobileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loco = ref.watch(localeStorePOD).loco;
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
                      SizedBox(
                        width: getMediaWidth(context) * 0.8,
                        height: 40,
                        child: EasyButton(
                          text: loco.sign_in,
                          onPressed: () {
                            authStore.login();
                          },
                        ),
                      ).padding(bottom: 20),
                      SizedBox(
                        width: getMediaWidth(context) * 0.8,
                        height: 40,
                        child: EasyButton(
                          useSystemColor: false,
                          text: loco.get_started,
                          onPressed: () {},
                        ),
                      ).padding(bottom: 30),
                      TextButton(
                        onPressed: () {},
                        child: EasyText(
                          loco.get_help,
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
}
