import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:url_launcher/url_launcher_string.dart';

Future<void> showDeviceLimitDialog(BuildContext context) async {
  await showModal(context, builder: (_) => const _DialogContent());
}

class _DialogContent extends HookConsumerWidget {
  const _DialogContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionStore = ref.watch(authSessionStorePOD);

    void handleOpenDashboard() {
      final uri = Uri.parse(Env.manageDevicesPage);
      final accessToken = sessionStore.accessToken;
      final queryParameters = (accessToken?.isNotEmpty ?? false)
          ? {...uri.queryParameters, 'access_token': accessToken}
          : null;
      final targetUri = Uri(
        scheme: uri.scheme,
        host: uri.host,
        path: uri.path,
        queryParameters: queryParameters,
      );
      openUrlLink(
        targetUri,
        source: RedirectSource.manageDevices,
        mode: LaunchMode.externalApplication,
      );
    }

    return PromptDialog(
      image: Asset.images.devicesLimit.svg(),
      title: S.current.deviceLimitReachedTitle,
      subtitle: S.current.deviceLimitReachedDesc,
      primaryButton: ButtonPrimary(
        onPressed: handleOpenDashboard,
        child: Text(S.current.deviceLimitReachedOpenDashboard),
      ),
      secondaryButton: ButtonSecondary(
        onPressed: () => Navigator.of(context).pop(),
        child: Text(S.current.closeBtn),
      ),
    );
  }
}
