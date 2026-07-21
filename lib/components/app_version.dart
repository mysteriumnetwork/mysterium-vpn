import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class AppVersion extends HookConsumerWidget {
  const AppVersion({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remoteConfig = ref.watch(remoteConfigStorePOD);
    final apiStore = ref.watch(apiStorePOD);
    useAutorun(apiStore.initStore);

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
      child: Observer(
        builder: (_) {
          var version = Env.buildInfo.buildVersion;
          if (apiStore.lastHealthcheck?.version != null) {
            version = '$version ${apiStore.lastHealthcheck?.version}';
          }
          return Row(
            children: [
              AppBadge(text: 'v.${Env.buildInfo.buildVersion}'),
              if (remoteConfig.showApiVersion && apiStore.lastHealthcheck != null)
                AppBadge(text: '${apiStore.lastHealthcheck?.version}'),
            ],
          );
        },
      ),
    );
  }
}
