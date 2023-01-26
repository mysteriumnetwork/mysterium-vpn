import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/components/app_logo.dart';
import 'package:mysterium_vpn/components/app_version.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/fill_container.dart';
import 'package:mysterium_vpn/components/login_headlines.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:styled_widget/styled_widget.dart';

class LoginDesktopView extends HookConsumerWidget {
  const LoginDesktopView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeStore = ref.read(themeStorePOD);
    final authStore = ref.read(authStorePOD);
    final loco = ref.read(localeStorePOD).loco;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppLogo(),
                  SvgIconButton(
                      asset: Assets.messageSvg,
                      onPressed: () {
                        themeStore.switchTheme();
                      }),
                ],
              ).padding(bottom: 20),
              Expanded(
                child: Center(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Expanded(child: LoginHeadlines()),
                    LayoutBuilder(builder: (ctx, con) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: con.maxWidth * 0.45,
                            height: 40,
                            child: EasyButton(
                              text: loco.sign_in,
                              onPressed: () {
                                authStore.login();
                              },
                            ),
                          ),
                          SizedBox(
                            width: con.maxWidth * 0.45,
                            height: 40,
                            child: EasyButton(
                              useSystemColor: false,
                              text: loco.get_started,
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ).padding(vertical: 10);
                    }),
                    AppVersion(
                      headerText: loco.app_version,
                    )
                  ]),
                ),
              ),
            ],
          ).paddingDirectional(horizontal: 55.0, vertical: 40),
        ),
        const FillContainer(),
      ],
    );
  }
}
