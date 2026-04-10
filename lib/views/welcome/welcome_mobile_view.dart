import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/login_headlines.dart';
import 'package:mysterium_vpn/components/unauthenticated_header.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:styled_widget/styled_widget.dart';

class WelcomeMobileView extends StatelessWidget {
  const WelcomeMobileView({required this.onSignInPressed, super.key});

  final VoidCallback onSignInPressed;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      UnauthenticatedHeader(
        padding: EdgeInsets.symmetric(vertical: getMediaHeight(context) * 0.03, horizontal: 30),
      ),
      const Expanded(child: LoginHeadlines()),
      EasyButton(
        width: getMediaWidth(context) * 0.8,
        height: 60,
        useSystemColor: false,
        color: Palette.purple,
        text: LocaleKeys.signIn.tr(),
        onPressed: onSignInPressed,
      ).padding(bottom: getMediaHeight(context) * 0.05),
    ],
  );
}
