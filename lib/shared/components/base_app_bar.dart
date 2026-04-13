import 'package:flutter/material.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/shared/components/app_logo.dart';
import 'package:mysterium_vpn/shared/components/svg_icon_button.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:styled_widget/styled_widget.dart';

class BaseAppBar extends StatelessWidget {
  const BaseAppBar({this.onBackButtonPressed, this.showBackButton = true, super.key});

  final VoidCallback? onBackButtonPressed;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      if (showBackButton)
        SvgIconButton(
          key: K.backButton,
          onPressed:
              onBackButtonPressed ??
              () {
                Navigator.of(context).maybePop();
              },
          asset: Asset.icons.navigateBack,
        )
      else
        const SizedBox.shrink(),
      const AppLogo(),
      const SizedBox(width: 40),
    ],
  ).padding(horizontal: 10, top: 10);
}
