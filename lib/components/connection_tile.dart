import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/string.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/connect_text_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/flag.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:styled_widget/styled_widget.dart';

class ConnectionTile extends HookConsumerWidget {
  const ConnectionTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locationsStore = ref.watch(locationsStorePOD);
    final vpnStore = ref.watch(vpnStorePOD);
    final analyticsStore = ref.watch(analyticsStorePOD);

    final location = useComputedValue(
      () =>
          locationsStore.selectedLocation ??
          vpnStore.location ??
          vpnStore.connectingLocation ??
          vpnStore.potentialLocation,
      [vpnStore, locationsStore],
    );

    final isConnected = useIsLocationConnected(location);
    final ipInfo = useComputedValue(() => vpnStore.vpnConnection?.connectionIP);

    final handleToggleConnection = useHandleToggleConnection();
    final onTap = useComputedValue(
      () => vpnStore.isLoading ? null : () => handleToggleConnection(location: location),
      [handleToggleConnection, location],
    );

    Future<void> handleRefreshIP() async {
      analyticsStore.logRefreshIP(ipInfo);
      await vpnStore.startConnectionWithRefreshIP();
    }

    if (location == null) {
      return const SizedBox.shrink();
    }

    final countryName = location.code.tr();

    return RawMaterialButton(
      onPressed: onTap,
      fillColor: theme.colorScheme.secondaryContainer,
      elevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      hoverElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          width: .5,
          color: switch (isConnected) {
            true => Palette.forestGreen,
            false => Palette.crimsonRed,
            _ => Colors.transparent,
          },
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          spacing: 12,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              spacing: 5,
              children: [
                Flag(countryCode: location.code, size: 30).padding(right: 5),
                Expanded(
                  child: EasyText(
                    countryName,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    maxLines: countryName.hasMultipleWords ? 2 : 1,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
                ConnectTextButton(
                  onPressed: onTap,
                  location: location,
                ),
              ],
            ),
            Row(
              spacing: 12,
              children: [
                if (ipInfo != null && (isConnected ?? false))
                  _IPIndicator(
                    ip: ipInfo,
                    onRefreshPressed: handleRefreshIP,
                  ),
                Expanded(child: _IPTypeIndicator(ipType: location.ipType)),
              ],
            ).padding(left: 40),
          ],
        ),
      ),
    );
  }
}

class _IPIndicator extends HookWidget {
  const _IPIndicator({
    required this.ip,
    required this.onRefreshPressed,
  });

  final String ip;
  final VoidCallback onRefreshPressed;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 12,
      children: [
        Flexible(
          child: EasyText(
            ip,
            fontSize: 12,
            color: theme.colorScheme.onSecondaryContainer,
          ),
        ),
        IconButton(
          onPressed: onRefreshPressed,
          icon: const SvgIcon(asset: Assets.refreshConn, height: 12, width: 12),
          style: IconButton.styleFrom(
            backgroundColor: Palette.blue,
            foregroundColor: Palette.white,
            visualDensity: VisualDensity.compact,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            padding: const EdgeInsets.all(6),
            minimumSize: const Size.square(25),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.onSecondaryContainer),
          child: const SizedBox(height: 20, width: 1),
        ),
      ],
    );
  }
}

class _IPTypeIndicator extends HookWidget {
  const _IPTypeIndicator({required this.ipType});
  final IPType ipType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 6,
      children: [
        Flexible(
          child: EasyText(
            switch (ipType) {
              IPType.datacenter => LocaleKeys.ipTypeDataCenter.tr(),
              IPType.residential => LocaleKeys.ipTypeResidential.tr(),
            },
            fontSize: 12,
            color: theme.colorScheme.onSecondaryContainer,
          ),
        ),
        if (ipType == IPType.datacenter)
          const SvgIcon(
            asset: Assets.speed,
            width: 12,
            height: 14,
          ),
      ],
    );
  }
}
