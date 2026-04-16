import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/app_version.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/login_headlines.dart';
import 'package:mysterium_vpn/components/unauthenticated_header.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:styled_widget/styled_widget.dart';

class WelcomeDesktopViewLeftPanel extends StatelessWidget {
  const WelcomeDesktopViewLeftPanel({required this.onSignInPressed, super.key});

  final VoidCallback onSignInPressed;

  @override
  Widget build(BuildContext context) =>
      Column(
        children: [
          UnauthenticatedHeader(padding: EdgeInsets.only(bottom: getMediaHeight(context) * 0.02)),
          const LoginHeadlines().expanded(),
          EasyButton(
            height: 60,
            width: 300,
            useSystemColor: false,
            color: Palette.purple,
            text: LocaleKeys.signIn.tr(),
            onPressed: onSignInPressed,
          ),
          const Align(alignment: Alignment.centerLeft, child: AppVersion()),
        ],
      ).paddingDirectional(
        horizontal: getMediaWidth(context) * 0.02,
        vertical: getMediaHeight(context) * 0.05,
      );
}
