import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/ui/ui.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:url_launcher/url_launcher_string.dart';

Future<void> showDeviceLimitDialog(BuildContext context) async {
  final analyticsStore = ProviderScope.containerOf(context, listen: false).read(analyticsStorePOD);
  analyticsStore.logDeviceLimitDialogShown().ignore();
  // Tracked here, not on the Close button, so barrier taps and system Back
  // count too. The dashboard button leaves the dialog open, so a dismissal
  // after it isn't an abandonment.
  var openedDashboard = false;
  await showModal(
    context,
    builder: (_) => _DialogContent(onDashboardOpened: () => openedDashboard = true),
  );
  if (!openedDashboard) {
    analyticsStore.logDeviceLimitDismissed().ignore();
  }
}

class _DialogContent extends HookConsumerWidget {
  const _DialogContent({required this.onDashboardOpened});

  final VoidCallback onDashboardOpened;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionStore = ref.watch(authSessionStorePOD);
    final analyticsStore = ref.watch(analyticsStorePOD);

    void handleOpenDashboard() {
      analyticsStore.logDeviceLimitDashboardClicked().ignore();
      onDashboardOpened();
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
        child: Text(S.current.deviceLimitReachedOpenDashboard, textAlign: TextAlign.center),
      ),
      secondaryButton: ButtonSecondary(
        onPressed: () => Navigator.of(context).pop(),
        child: Text(S.current.closeBtn, textAlign: TextAlign.center),
      ),
    );
  }
}
