import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class TooManyConnectionsBanner extends HookConsumerWidget {
  const TooManyConnectionsBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnStore = ref.watch(vpnStorePOD);
    final connectionsLimitStore = ref.watch(connectionsLimitStorePOD);

    final handleToggleConnection = useHandleToggleConnection();
    final isConnected = useComputedValue(() => vpnStore.isConnected);

    Future<void> handleDisconnect() async {
      await handleToggleConnection();
      connectionsLimitStore.connectionLimitReached = false;
    }

    return AlertModal(
      type: AlertModalType.error,
      title: S.current.tooManyConnectionsBannerTitle,
      supportingText: isConnected
          ? S.current.tooManyConnectionsBannerDescConnected
          : S.current.tooManyConnectionsBannerDesc,
      primaryButton: ButtonSecondary(
        size: ButtonSize.small,
        onPressed: handleDisconnect,
        child: Text(
          isConnected
              ? S.current.tooManyConnectionsBannerCTADisconnect
              : S.current.tooManyConnectionsBannerCTAReconnect,
        ),
      ),
    );
  }
}
