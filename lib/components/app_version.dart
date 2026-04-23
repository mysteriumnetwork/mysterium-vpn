import 'package:flutter/material.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class AppVersion extends StatelessWidget {
  const AppVersion({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        theme.spacing.xl3,
        theme.spacing.xl,
        theme.spacing.xl3,
        theme.spacing.xl2,
      ),
      child: AppBadge(text: 'v.${Env.buildInfo.buildVersion}'),
    );
  }
}
