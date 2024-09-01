import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/app_logo.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/login_headlines.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:styled_widget/styled_widget.dart';

class LoginMobileView extends StatelessWidget {
  const LoginMobileView({
    required this.onSignInPressed,
    super.key,
  });

  final VoidCallback onSignInPressed;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const AppLogo().padding(
            top: getMediaHeight(context) * 0.03,
            bottom: getMediaHeight(context) * 0.02,
          ),
          const Expanded(
            child: LoginHeadlines(),
          ),
          EasyButton(
            width: getMediaWidth(context) * 0.8,
            height: 60,
            useSystemColor: false,
            color: Palette.purple,
            text: LocaleKeys.signIn.tr(),
            onPressed: onSignInPressed,
          ).padding(
            bottom: getMediaHeight(context) * 0.05,
          ),
        ],
      );
}
