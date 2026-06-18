import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/connection_tile_state_hook.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/arrowed_progress_card.dart';
import 'package:mysterium_vpn/views/home/home_state.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:showcaseview/showcaseview.dart';

class ConnectionTile extends HookConsumerWidget {
  const ConnectionTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (
      :status,
      :connectLabel,
      :disconnectLabel,
      :connectingLabel,
      :noConnectionTitle,
      :noConnectionDescription,
      :onToggle,
      :onRefreshIP,
      :onDismissPreview,
      :onThumbsUp,
      :onThumbsDown,
      :connectionRating,
    ) = useConnectionTileState(
      ref,
    );

    Widget buttonWrapper({required BuildContext context, required Widget child}) =>
        ArrowedProgressCard(
          step: SubscriptionOnboardingStep.connectButton,
          globalKey: ref
              .read(homeStateProvider)
              .subscriptionOnboardingKeys[SubscriptionOnboardingStep.connectButton.platformIndex],
          tooltipPosition: TooltipPosition.top,
          child: Padding(padding: const EdgeInsets.all(8), child: child),
        );

    return Column(
      children: [
        MainIpCard(
          status: status,
          serviceQualityKey: ref.watch(homeStateProvider).connectedCardKey,
          connectLabel: connectLabel,
          disconnectLabel: disconnectLabel,
          connectingLabel: connectingLabel,
          noConnectionTitle: noConnectionTitle,
          noConnectionDescription: noConnectionDescription,
          connectionRatingLabel: LocaleKeys.rateConnection.tr(),
          showConnectionRating: false,
          onConnect: onToggle,
          onDisconnect: onToggle,
          onRefreshIp: onRefreshIP,
          onThumbsUp: onThumbsUp,
          onThumbsDown: onThumbsDown,
          onDismissPreview: onDismissPreview,
          onSwitchCountry: onToggle,
          refreshIpTooltip: LocaleKeys.refreshIP.tr(),
          connectionRating: connectionRating,
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
