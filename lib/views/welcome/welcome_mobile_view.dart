import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/login_headlines.dart';
import 'package:mysterium_vpn/components/unauthenticated_header.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:styled_widget/styled_widget.dart';

class WelcomeMobileView extends StatelessWidget {
  const WelcomeMobileView({required this.onSignInPressed, super.key});

  final VoidCallback onSignInPressed;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      const UnauthenticatedHeader(),
      const Expanded(child: LoginHeadlines()),
      ButtonPrimary(
        onPressed: onSignInPressed,
        child: Text(LocaleKeys.signIn.tr()),
      ).padding(bottom: getMediaHeight(context) * 0.05),
    ],
  );
}
