import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/components/app_logo.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/stores/auth_store.dart';
import 'package:styled_widget/styled_widget.dart';

class BaseAppBar extends StatelessWidget {
  const BaseAppBar({
    required this.authStore,
    this.onBackButtonPressed,
    super.key,
  });
  final AuthStore authStore;
  final VoidCallback? onBackButtonPressed;
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgIconButton(
            onPressed: onBackButtonPressed ?? context.beamBack,
            asset: Assets.navigateBack,
          ),
          const AppLogo(),
          const SizedBox(width: 40)
        ],
      ).padding(horizontal: 10, top: 10);
}
