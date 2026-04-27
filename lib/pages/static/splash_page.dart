import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/utils/design_system_theme.dart';
import 'package:mysterium_vpn/components/colored_scaffold.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn_design/widgets/loading_indicator.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) => Theme(
    data: DesignSystemTheme.of(context),
    child: ColoredScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgIcon(asset: Asset.logo.splashLogo),
            const LoadingIndicator(),
          ],
        ),
      ),
    ),
  );
}
