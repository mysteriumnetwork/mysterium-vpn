import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersion extends StatelessWidget {
  const AppVersion({super.key});

  @override
  Widget build(BuildContext context) => FutureBuilder<PackageInfo>(
    // ignore: discarded_futures
    future: PackageInfo.fromPlatform(),
    builder: (context, snapshot) {
      final theme = Theme.of(context);
      return snapshot.hasData
          ? Padding(
              padding: EdgeInsets.symmetric(
                horizontal: theme.spacing.xl3,
                vertical: theme.spacing.xl3,
              ),
              child: AppBadge(text: 'v.${snapshot.data?.version}'),
            )
          : const SizedBox.shrink();
    },
  );
}
