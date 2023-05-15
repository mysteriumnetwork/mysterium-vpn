import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/app_logo.dart';
import 'package:mysterium_vpn/components/app_version.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/loading_barrier.dart';
import 'package:mysterium_vpn/components/login_headlines.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginDesktopViewLeftPanel extends ConsumerWidget {
  const LoginDesktopViewLeftPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final environment = ref.read(environmentPOD);
    final authStore = ref.watch(authStorePOD);

    return Observer(
      builder: (context) => Stack(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppLogo(),
                  SvgIconButton(
                    asset: Assets.messageSvg,
                    onPressed: () => context.beamToNamed(Routes.reportIssue.toRoute),
                  ),
                ],
              ).padding(bottom: 20),
              const LoginHeadlines().expanded(),
              EasyButton(
                height: 60,
                width: 300,
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
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: AppVersion(
                  headerText: LocaleKeys.appVersion.tr(),
                ),
              )
            ],
          ).paddingDirectional(horizontal: 55, vertical: 40),
          if (authStore.authStatus == AuthStatus.authenticating)
            LoadingBarrier(
              color: Theme.of(context).primaryColor,
            )
        ],
      ),
    );
  }
}
