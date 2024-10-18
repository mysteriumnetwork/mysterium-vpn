import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/components/app_logo.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:styled_widget/styled_widget.dart';

class BaseAppBar extends StatelessWidget {
  const BaseAppBar({
    this.onBackButtonPressed,
    this.showBackButton = true,
    super.key,
  });
  final VoidCallback? onBackButtonPressed;
  final bool showBackButton;
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (showBackButton)
            SvgIconButton(
              onPressed: onBackButtonPressed ??
                  () {
                    Navigator.of(context).maybePop();
                  },
              asset: Assets.navigateBack,
            )
          else
            const SizedBox.shrink(),
          const AppLogo(),
          const SizedBox(width: 40),
        ],
      ).padding(horizontal: 10, top: 10);
}
