import 'dart:async';

import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

const _contentMaxWidth = 457.0;

Future<void> showConnectionDetailsDialog(BuildContext context) async => showModal(
  context,
  desktopConstraints: const BoxConstraints(maxWidth: 637, maxHeight: 640),
  builder: (ctx) => const ModalMessengerScope(child: _ConnectionDetailsPage()),
);

class _ConnectionDetailsPage extends HookConsumerWidget {
  const _ConnectionDetailsPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnStore = ref.watch(vpnStorePOD);
    final connectionDisplayStore = ref.watch(connectionDisplayStorePOD);
    final protocolStore = ref.watch(vpnProtocolStorePOD);
    final analyticsStore = ref.watch(analyticsStorePOD);
    final selectedLocationStore = ref.watch(selectedLocationStorePOD);
    final ipRefreshExhaustionStore = ref.watch(ipRefreshExhaustionStorePOD);

    final vpnStatus = useComputedValue(() => vpnStore.vpnStatus);
    final isFetchingConfig = useComputedValue(() => vpnStore.isFetchingConfig);
    final isLoading = useComputedValue(() => connectionDisplayStore.isLoading);
    final connectionIP = useComputedValue(() => connectionDisplayStore.connectionIP);
    // The dialog describes the CURRENT connection — a pending selection of a
    // different country/city must not change what is shown here.
    final currentLocation = useComputedValue(
      () => connectionDisplayStore.connectedOrDisplayLocation,
    );
    final parentLocation = useComputedValue(() => connectionDisplayStore.connectedParentLocation);
    // connectedIpPoolCount tracks the REQUESTED location (e.g. the country),
    // so it stays stable through a refresh — mid-refresh the connecting
    // location is the specific city, whose pool must not flash here. Only
    // when nothing is requested/connected (settled disconnect) fall back to
    // the location Connect would re-join.
    final ipPoolCount = useComputedValue(() {
      final connectedPool = vpnStore.connectedIpPoolCount;
      return connectedPool > 0
          ? connectedPool
          : connectionDisplayStore.connectedOrDisplayLocation?.nodeCount ?? 0;
    });
    final connectedAt = useComputedValue(() => vpnStore.connectedAt);
    final protocol = useComputedValue(() => protocolStore.protocol);
    final handleToggleConnection = useHandleToggleConnection();

    final isRefreshing = useState(false);
    final spinController = useAnimationController(duration: const Duration(milliseconds: 900));

    final onRefreshIp = useCallback(() async {
      if (isRefreshing.value) {
        return;
      }
      isRefreshing.value = true;
      spinController.repeat();
      try {
        analyticsStore.logRefreshIP(connectionDisplayStore.connectionIP);
        selectedLocationStore.value = null;
        await vpnStore.manageConnection(refreshIP: true);
      } finally {
        if (context.mounted) {
          isRefreshing.value = false;
          spinController.reset();
        }
      }
    }, [analyticsStore, connectionDisplayStore, selectedLocationStore, vpnStore]);

    useReaction(() => ipRefreshExhaustionStore.exhaustionNotice, (VPNLocation? location) {
      if (location == null) {
        return;
      }
      showSnackbar(
        ipRefreshExhaustedMessage(
          isCountry: location.isCountry,
          locationName: location.getName(context),
        ),
        type: SnackbarType.info,
      );
      ipRefreshExhaustionStore.clearNotice();
    });

    final theme = Theme.of(context);
    final palette = theme.palette;
    final isDesktop = ScreenType.of(context) >= ScreenType.tablet;
    final isConnected = vpnStatus == VpnConnectionStatus.connected && !isFetchingConfig;
    // A failed refresh lands here: not refreshing anymore, tunnel down.
    final isDisconnected =
        vpnStatus == VpnConnectionStatus.disconnected && !isRefreshing.value && !isLoading;
    final canRefresh = ipPoolCount > 1 && isConnected && !isRefreshing.value;
    // QA-only counters, test builds only.
    final showTunnelStats = Env.flavor.isDev && isConnected;
    final refreshActive = canRefresh || isRefreshing.value;
    final refreshTextColor = refreshActive ? palette.textBrandPrimary : palette.textDisabled;
    final refreshIconColor = refreshActive ? palette.iconBrandPrimary : palette.textDisabled;

    final onConnect = useCallback(
      () => handleToggleConnection(
        location: connectionDisplayStore.targetLocation,
        intent: connectionDisplayStore.connectionIntent,
      ),
      [handleToggleConnection, connectionDisplayStore],
    );

    final barStatus = vpnStatus.toBarStatus(isFetchingConfig: isFetchingConfig);
    final (:country, :city) = locationDisplayNames(
      context,
      location: currentLocation,
      parent: parentLocation,
    );
    final serviceQuality = (currentLocation?.ipType ?? IPType.datacenter).localizedLabel;

    Widget poolAction({
      required VoidCallback? onPressed,
      required Color color,
      required String label,
      Widget? leading,
    }) => ButtonTertiary(
      onPressed: onPressed,
      size: ButtonSize.small,
      decoration: ButtonDecoration(
        foregroundColor: color,
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
      ),
      leading: leading,
      child: Text(label),
    );

    return ModalScaffold(
      showGradient: false,
      backgroundColor: palette.bgSidePanel,
      appbar: ModalAppbar(title: isDesktop ? S.current.connectionDetails : S.current.vpnDetails),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(theme.spacing.md),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _contentMaxWidth),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: theme.spacing.xl2,
              children: [
                LocationStatusCard(
                  country: country,
                  city: city,
                  countryIcon: currentLocation != null
                      ? CircleFlag(currentLocation.countryCode, size: 36)
                      : const SizedBox(width: 36, height: 36),
                  status: barStatus,
                  statusLabel: barStatus.localizedLabel,
                ),
                _Section(
                  title: S.current.ipDetails,
                  children: [
                    DetailCard(
                      title: S.current.myIp,
                      value: isDisconnected ? null : S.current.hiddenLbl,
                      valueMuted: true,
                      valueIcon: isDisconnected
                          ? null
                          : Icon(UntitledUI.eye_off, size: 24, color: palette.iconSecondary),
                      position: SettingsCardPosition.top,
                    ),
                    DetailCard(
                      title: S.current.vpnIp,
                      value: connectionIP ?? (isDisconnected ? null : '...'),
                      position: SettingsCardPosition.middle,
                    ),
                    DetailCard(
                      title: S.current.ipType,
                      value: serviceQuality,
                      position: SettingsCardPosition.bottom,
                    ),
                  ],
                ),
                _Section(
                  title: S.current.connectionDetails,
                  children: [
                    _ConnectedSinceCard(connectedAt: connectedAt),
                    DetailCard(
                      title: S.current.protocol,
                      value: protocol.label,
                      position: SettingsCardPosition.middle,
                    ),
                    DetailCard(
                      title: S.current.ipPool,
                      value: '$ipPoolCount',
                      position: showTunnelStats
                          ? SettingsCardPosition.middle
                          : SettingsCardPosition.bottom,
                      trailing: isDisconnected
                          ? poolAction(
                              onPressed: onConnect,
                              color: palette.textBrandPrimary,
                              label: S.current.connect,
                            )
                          : poolAction(
                              onPressed: canRefresh ? onRefreshIp : null,
                              color: refreshTextColor,
                              label: S.current.refresh,
                              leading: RotationTransition(
                                turns: spinController,
                                child: Icon(
                                  UntitledUI.refresh_cw_02,
                                  size: 20,
                                  color: refreshIconColor,
                                ),
                              ),
                            ),
                    ),
                    if (showTunnelStats) const _TunnelStatsCards(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Owns the 1s tick for the QA counters so only these rows rebuild as they update.
class _TunnelStatsCards extends HookConsumerWidget {
  const _TunnelStatsCards();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(networkStatisticsStorePOD);
    final rate = useComputedValue(
      () => tunnelRateLabel(downloadMbps: store.downloadSpeed, uploadMbps: store.uploadSpeed),
      [store],
    );
    final total = useComputedValue(
      () => tunnelTotalLabel(
        totalDownloadMb: store.totalDownloadInMB,
        totalUploadMb: store.totalUploadInMB,
      ),
      [store],
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DetailCard(title: 'Current rate', value: rate, position: SettingsCardPosition.middle),
        DetailCard(title: 'Total transferred', value: total, position: SettingsCardPosition.bottom),
      ],
    );
  }
}

/// Owns the 1s tick so only this row rebuilds while the duration counts up.
class _ConnectedSinceCard extends HookWidget {
  const _ConnectedSinceCard({required this.connectedAt});

  final DateTime? connectedAt;

  @override
  Widget build(BuildContext context) {
    final now = useState(DateTime.now());
    useEffect(() {
      if (connectedAt == null) {
        return null;
      }
      now.value = DateTime.now();
      final timer = Timer.periodic(const Duration(seconds: 1), (_) => now.value = DateTime.now());
      return timer.cancel;
    }, [connectedAt]);

    // Clamp: the device clock can move backwards while connected (or a
    // persisted connectedAt can be in the future), yielding a negative diff.
    var elapsed = connectedAt == null ? Duration.zero : now.value.difference(connectedAt!);
    if (elapsed.isNegative) {
      elapsed = Duration.zero;
    }
    return DetailCard(
      title: S.current.connectedSince,
      value: elapsed.toHoursMinutesSeconds(),
      position: SettingsCardPosition.top,
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: theme.spacing.s,
      children: [
        Text(
          title,
          style: theme.textStyles.textMd.regular.copyWith(color: theme.palette.textTertiary),
        ),
        Column(mainAxisSize: MainAxisSize.min, children: children),
      ],
    );
  }
}
