import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:styled_widget/styled_widget.dart';

class WelcomeDesktopViewLeftPanel extends StatelessWidget {
  const WelcomeDesktopViewLeftPanel({required this.onSignInPressed, super.key});

  final VoidCallback onSignInPressed;

  @override
  Widget build(BuildContext context) =>
      Column(
        children: [
          const UnauthenticatedHeader(),
          const LoginHeadlines().expanded(),
          ButtonPrimary(onPressed: onSignInPressed, child: Text(LocaleKeys.loginSignupLabel.tr())),
        ],
      ).paddingDirectional(
        horizontal: getMediaWidth(context) * 0.02,
        vertical: getMediaHeight(context) * 0.05,
      );
}
