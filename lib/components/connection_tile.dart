import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/connection_tile_state_hook.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/dialogs/connection_details_dialog.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/arrowed_progress_card.dart';
import 'package:mysterium_vpn/views/home/home_state.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:showcaseview/showcaseview.dart';

class ConnectionTile extends HookConsumerWidget {
  const ConnectionTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remoteConfig = ref.watch(remoteConfigStorePOD);
    final favoriteLocationsEnabled = useComputedValue(() => remoteConfig.favoriteLocationsEnabled);
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
          // Favorites are not implemented yet — behind the favoriteLocationsEnabled
          // flag the heart is an inert placeholder with an untranslated
          // tester-facing tooltip until the feature ships.
          onFavorite: favoriteLocationsEnabled ? () {} : null,
          favoriteTooltip: 'Favorites coming soon',
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
    final palette = Theme.of(context).palette;
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Protocol: ${vpnProtocol.protocol.name}',
        style: TextStyle(fontSize: 8, color: palette.textSecondary, fontWeight: FontWeight.w800),
      ),
    );
  }
}
