import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
import 'package:mysterium_vpn/common/hooks/connection_tile_state_hook.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/dialogs/connection_details_dialog.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/views/home/arrowed_progress_card.dart';
import 'package:mysterium_vpn/views/home/home_state.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:showcaseview/showcaseview.dart';

class ConnectionTile extends HookConsumerWidget {
  const ConnectionTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIpsStore = ref.watch(favoriteIpsStorePOD);
    final connectionDisplayStore = ref.watch(connectionDisplayStorePOD);
    final (
      :status,
      :connectLabel,
      :disconnectLabel,
      :connectingLabel,
      :noConnectionTitle,
      :noConnectionDescription,
      :onToggle,
      :onDismissPreview,
    ) = useConnectionTileState(
      ref,
    );

    // Keyed on the stores: they are recreated on logout, and the hook would
    // otherwise keep observing the disposed instances.
    final keys = [favoriteIpsStore, connectionDisplayStore];
    final connectionIP = useComputedValue(() => connectionDisplayStore.connectionIP, keys);
    final favoritesEnabled = useComputedValue(() => favoriteIpsStore.isEnabled, keys);
    final isFavorite = useComputedValue(() {
      final ip = connectionDisplayStore.connectionIP;
      return ip != null && favoriteIpsStore.isFavorite(ip);
    }, keys);

    // Limit notice is emitted by the store; the view translates and shows it.
    useReaction(() => favoriteIpsStore.notice, (FavoriteIpsNotice? notice) {
      if (notice == null) {
        return;
      }
      showFavoriteIpLimitSnackbar(onManage: ref.read(homeTabsStorePOD).openFavoriteLocations);
      favoriteIpsStore.clearNotice();
    }, keys: keys);

    Future<void> handleFavorite() async {
      final ip = connectionDisplayStore.connectionIP;
      final location = connectionDisplayStore.connectedOrDisplayLocation;
      if (ip == null || location == null) {
        return;
      }

      if (favoriteIpsStore.isFavorite(ip)) {
        await removeFavoriteIpWithUndo(favoriteIpsStore, ip);
        return;
      }

      // At the limit, add() emits FavoriteIpsNotice.limitReached — surfaced
      // by the notice reaction above.
      final (:country, :city) = locationDisplayNames(
        context,
        location: location,
        parent: connectionDisplayStore.connectedParentLocation,
      );
      final added = await favoriteIpsStore.add(
        FavoriteIp(
          ip: ip,
          countryCode: location.countryCode,
          // A translations-less location resolves its name to the raw code —
          // store '' instead so display falls back to the code translation.
          countryName: country.toLowerCase() == location.countryCode.toLowerCase() ? '' : country,
          city: city,
          // Remember what was picked (city vs whole country) so a later
          // connect targets the same scope.
          locationId: location.id,
          ipType: location.ipType,
          savedAt: DateTime.now(),
        ),
      );
      if (added) {
        showSnackbar(S.current.favoriteIpAddedToast, type: SnackbarType.info);
      }
    }

    Widget buttonWrapper({required BuildContext context, required Widget child}) =>
        ArrowedProgressCard(
          key: K.connectButton,
          step: SubscriptionOnboardingStep.connectButton,
          globalKey: ref
              .read(homeStateProvider)
              .subscriptionOnboardingKeys[SubscriptionOnboardingStep.connectButton.platformIndex],
          tooltipPosition: TooltipPosition.top,
          showcasePadding: const EdgeInsets.all(8),
          child: child,
        );

    return Column(
      children: [
        MainIpCard(
          status: status,
          connectedInfoKey: ref.watch(homeStateProvider).connectedCardKey,
          connectLabel: connectLabel,
          disconnectLabel: disconnectLabel,
          connectingLabel: connectingLabel,
          noConnectionTitle: noConnectionTitle,
          noConnectionDescription: noConnectionDescription,
          onConnect: onToggle,
          onDisconnect: onToggle,
          onDetails: () => showConnectionDetailsDialog(context),
          onFavorite: favoritesEnabled && connectionIP != null ? handleFavorite : null,
          isFavorite: isFavorite,
          // Icon-only buttons: the label has to carry the whole action.
          favoriteSemanticLabel: isFavorite
              ? S.current.favoriteIpRemoveAction
              : S.current.favoriteIpAddAction,
          detailsSemanticLabel: S.current.connectionDetails,
          dismissPreviewSemanticLabel: S.current.dismissNewIpPreview,
          onDismissPreview: onDismissPreview,
          onSwitchCountry: onToggle,
          buttonWrapper: buttonWrapper,
        ),
        if (Env.flavor.isDev) const _DevProtocolLabel(),
      ],
    );
  }
}

class _DevProtocolLabel extends HookConsumerWidget {
  const _DevProtocolLabel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnProtocol = ref.watch(vpnProtocolStorePOD);
    final vpnStore = ref.watch(vpnStorePOD);
    final isConnected = useComputedValue(() => vpnStore.isConnected);
    // Watched only while connected: reading the provider starts its poll loop.
    final statistics = isConnected ? ref.watch(networkStatisticsStorePOD) : null;
    final palette = Theme.of(context).palette;

    return Align(
      // scaleDown keeps the readout on a single line on narrow screens without
      // ellipsizing away the trailing counters.
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Observer(
          builder: (context) => Text(
            tunnelStatsLabel(
              protocol: vpnProtocol.protocol.name,
              now: DateTime.now(),
              stats: statistics == null
                  ? null
                  : (
                      downloadMbps: statistics.downloadSpeed,
                      uploadMbps: statistics.uploadSpeed,
                      totalDownloadMb: statistics.totalDownloadInMB,
                      totalUploadMb: statistics.totalUploadInMB,
                      latestHandshake: statistics.latestHandshake,
                    ),
            ),
            maxLines: 1,
            style: TextStyle(
              fontSize: 8,
              color: palette.textSecondary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
