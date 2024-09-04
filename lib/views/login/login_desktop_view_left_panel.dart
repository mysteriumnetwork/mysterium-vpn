import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/app_logo.dart';
import 'package:mysterium_vpn/components/app_version.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/login_headlines.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:styled_widget/styled_widget.dart';

class LoginDesktopViewLeftPanel extends StatelessWidget {
  const LoginDesktopViewLeftPanel({
    required this.onSignInPressed,
    required this.onReportPressed,
    super.key,
  });

  final VoidCallback onSignInPressed;
  final VoidCallback onReportPressed;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppLogo(),
              SvgIconButton(
                asset: Assets.messageSvg,
                onPressed: onReportPressed,
              ),
            ],
          ).padding(bottom: getMediaHeight(context) * 0.02),
          const LoginHeadlines().expanded(),
          EasyButton(
            height: 60,
            width: 300,
            useSystemColor: false,
            color: Palette.purple,
            text: LocaleKeys.signIn.tr(),
            onPressed: onSignInPressed,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: AppVersion(
              headerText: LocaleKeys.appVersion.tr(),
            ),
          ),
        ],
      ).paddingDirectional(horizontal: 55, vertical: getMediaHeight(context) * 0.05);
}
