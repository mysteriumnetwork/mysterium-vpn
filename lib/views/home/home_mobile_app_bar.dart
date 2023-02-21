import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/enums/routes.dart';
import 'package:mysterium_vpn/common/extensions/enum.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/components/app_logo.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';

class HomeMobileAppBar extends StatelessWidget {
  const HomeMobileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SvgIconButton(
          onPressed: () {
            context.beamToNamed(Routes.reportIssue.toRoute);
          },
          asset: Assets.report,
        ),
        const AppLogo(),
        SvgIconButton(
          onPressed: () {
            context.beamToNamed(Routes.settings.toRoute);
          },
          asset: Assets.settings,
        )
      ],
    );
  }
}
