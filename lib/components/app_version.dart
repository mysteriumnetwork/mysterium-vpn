import 'package:flutter/material.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class AppVersion extends StatelessWidget {
  const AppVersion({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = ScreenType.of(context) >= ScreenType.tablet;

    return Padding(
      padding: isDesktop
          ? EdgeInsetsGeometry.all(theme.spacing.xl3)
          : EdgeInsets.fromLTRB(
              theme.spacing.md,
              theme.spacing.xl2,
              theme.spacing.md,
              theme.spacing.xl2,
            ),
      child: AppBadge(text: 'v.${Env.buildInfo.buildVersion}'),
    );
  }
}
