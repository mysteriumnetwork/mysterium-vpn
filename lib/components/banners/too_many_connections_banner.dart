import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
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
      type: AlertModalType.warning,
      title: LocaleKeys.tooManyConnectionsBannerTitle.tr(),
      supportingText: isConnected
          ? LocaleKeys.tooManyConnectionsBannerDescConnected.tr()
          : LocaleKeys.tooManyConnectionsBannerDesc.tr(),
      primaryButton: ButtonPrimary(
        size: ButtonSize.small,
        onPressed: handleDisconnect,
        child: Text(
          isConnected
              ? LocaleKeys.tooManyConnectionsBannerCTADisconnect.tr()
              : LocaleKeys.tooManyConnectionsBannerCTAReconnect.tr(),
        ),
      ),
    );
  }
}
