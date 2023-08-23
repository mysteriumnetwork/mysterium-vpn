import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/components/app_logo.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:styled_widget/styled_widget.dart';

class BaseAppBar extends StatelessWidget {
  const BaseAppBar({
    this.onBackButtonPressed,
    super.key,
  });
  final VoidCallback? onBackButtonPressed;
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgIconButton(
            onPressed: onBackButtonPressed ??
                () {
                  Beamer.of(context).popRoute();
                },
            asset: Assets.navigateBack,
          ),
          const AppLogo(),
          const SizedBox(width: 40),
        ],
      ).padding(horizontal: 10, top: 10);
}
