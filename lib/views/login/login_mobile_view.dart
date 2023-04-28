import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/auth_status.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/app_logo.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/loading_barrier.dart';
import 'package:mysterium_vpn/components/login_headlines.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginMobileView extends ConsumerWidget {
  const LoginMobileView({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final environment = ref.read(environmentPOD);
    final authStore = ref.watch(authStorePOD);
    return Observer(
      builder: (context) => Stack(
        children: [
          Column(
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
                          alignment: CrossAxisAlignment.center,
                        ),
                      ),
                      EasyButton(
                        width: getMediaWidth(context) * 0.8,
                        height: 60,
                        useSystemColor: false,
                        color: Palette.purple,
                        text: LocaleKeys.signIn.tr(),
                        onPressed: () {
                          if (isMobile()) {
                            showAuthView(context);
                          } else {
                            launchUrl(Uri.parse(environment.values.webAppUrl));
                          }
                        },
                      ).padding(bottom: 60),
                      Visibility(
                        visible: false,
                        child: TextButton(
                          onPressed: () {},
                          child: EasyText(
                            LocaleKeys.getHelp.tr(),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (authStore.authStatus == AuthStatus.authenticating)
            const LoadingBarrier(
              color: Palette.darkBlue,
            )
        ],
      ),
    );
  }
}
