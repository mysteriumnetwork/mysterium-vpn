import 'package:flutter/material.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class AppVersion extends StatelessWidget {
  const AppVersion({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.xl3,
        vertical: theme.spacing.xl3,
      ),
      child: AppBadge(text: 'v.${Env.buildInfo.buildVersion}'),
    );
  }
}
