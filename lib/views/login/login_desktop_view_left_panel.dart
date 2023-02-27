import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/routes.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/components/app_logo.dart';
import 'package:mysterium_vpn/components/app_version.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/login_headlines.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:styled_widget/styled_widget.dart';

class LoginDesktopViewLeftPanel extends ConsumerWidget {
  const LoginDesktopViewLeftPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStore = ref.read(authStorePOD);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        LayoutBuilder(
          builder: (ctx, con) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              EasyButton(
                width: con.maxWidth * 0.45,
                height: 60,
                text: LocaleKeys.signIn.tr(),
                onPressed: authStore.login,
              ),
              EasyButton(
                height: 60,
                width: con.maxWidth * 0.45,
                useSystemColor: false,
                text: LocaleKeys.getStarted.tr(),
                onPressed: () {},
              ),
            ],
          ).padding(vertical: 10),
        ),
        AppVersion(
          headerText: LocaleKeys.appVersion.tr(),
        )
      ],
    ).paddingDirectional(horizontal: 55, vertical: 40);
  }
}
