import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/connect_text_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/flag.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class ConnectionTile extends HookConsumerWidget {
  const ConnectionTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationsStore = ref.watch(locationsStorePOD);
    final vpnStore = ref.watch(vpnStorePOD);

    final location = useComputedValue(
      () => vpnStore.location ?? vpnStore.connectingLocation ?? vpnStore.potentialLocation,
      [vpnStore, locationsStore],
    );

    final isConnected = useIsLocationConnected(location);
    final handleToggleConnection = useHandleToggleConnection();
    final onTap = useComputedValue(
      () => vpnStore.isLoading ? null : () => handleToggleConnection(location: location),
      [handleToggleConnection, location],
    );

    if (location == null) {
      return const SizedBox.shrink();
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Palette.deepPurple,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          width: .5,
          color: switch (isConnected) {
            true => Palette.green,
            _ => Colors.transparent,
          },
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              spacing: 10,
              children: [
                Flag(countryCode: location.code, size: 32),
                Expanded(
                  child: EasyText(
                    location.code.tr(),
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                ConnectTextButton(
                  onPressed: onTap,
                  location: location,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
