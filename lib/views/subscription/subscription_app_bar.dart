import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/components/app_logo.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/stores/auth_store.dart';
import 'package:styled_widget/styled_widget.dart';

class SubscriptionAppBar extends StatelessWidget {
  const SubscriptionAppBar({
    required this.authStore,
    super.key,
  });
  final AuthStore authStore;
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgIconButton(
            onPressed: authStore.logout,
            asset: Assets.navigateBack,
          ),
          const AppLogo(),
          const SizedBox(),
        ],
      ).padding(horizontal: 20, top: 10);
}
