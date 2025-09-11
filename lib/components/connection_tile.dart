import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/common/extensions/string.dart';
import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
import 'package:mysterium_vpn/common/hooks/connection_status_color_hook.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/connect_text_button.dart';
import 'package:mysterium_vpn/components/dialogs/rate_connection_dialog.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/flag.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:vpn_api/vpn_api.dart';

class ConnectionTile extends HookConsumerWidget {
  const ConnectionTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locationsStore = ref.watch(locationsStorePOD);
    final vpnStore = ref.watch(vpnStorePOD);
    final analyticsStore = ref.watch(analyticsStorePOD);

    final location = useComputedValue(
      () {
        final selectedLocation = locationsStore.selectedLocation;
        final location = vpnStore.location;
        final connectingLocation = vpnStore.connectingLocation;
        final potentialLocation = vpnStore.potentialLocation;

        return selectedLocation ?? location ?? connectingLocation ?? potentialLocation;
      },
      [vpnStore, locationsStore],
    );

    final isConnected = useIsLocationConnected(location);
    final ipInfo = useComputedValue(() => vpnStore.vpnConnection?.connectionIP);
    final outlineColor = useConnectionStatusColor();

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

    return RawMaterialButton(
      onPressed: null,
      fillColor: theme.palette.connectionTileBackgroundColor,
      elevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      hoverElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: outlineColor),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _ConnectingLocation(location: location)),
                ConnectTextButton(
                  onPressed: onTap,
                  location: location,
                  size: const Size(106, 38),
                ),
              ],
            ),
            if (location.ipType != IPType.closest)
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
            if (location.ipType != IPType.closest) _RateConnection(),
          ],
        ),
      ),
    );
  }
}

class _ConnectingLocation extends StatelessWidget {
  const _ConnectingLocation({required this.location});

  final VPNLocation location;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final countryName = location.getName(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        if (location.ipType == IPType.closest) ...[
          SvgIcon(
            asset: Asset.icons.flashAdaptive(context),
          ).padding(right: 10),
          Expanded(
            child: Column(
              spacing: 18,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                EasyText(
                  LocaleKeys.connectBestServer.tr(),
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  maxLines: 2,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
                EasyText(
                  LocaleKeys.orSelectCountryManually.tr(),
                  fontSize: 12,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ],
            ),
          ),
        ] else ...[
          Flag(countryCode: location.countryCode, size: 30),
          Expanded(
            child: EasyText(
              countryName,
              fontWeight: FontWeight.w500,
              fontSize: 18,
              maxLines: countryName.hasMultipleWords ? 2 : 1,
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
        ],
      ],
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
            fontWeight: FontWeight.w500,
          ),
        ),
        IconButton(
          onPressed: onRefreshPressed,
          icon: SvgIcon(asset: Asset.icons.refresh, height: 12, width: 12),
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
              _ => '',
            },
            fontSize: 12,
            color: theme.colorScheme.onSecondaryContainer,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (ipType == IPType.datacenter)
          SvgIcon(
            asset: Asset.icons.speed,
            width: 12,
            height: 14,
          ),
      ],
    );
  }
}

class _RateConnection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final vpnStore = ref.watch(vpnStorePOD);
    final remoteConfigStore = ref.watch(remoteConfigStorePOD);
    if (!vpnStore.isConnected || !remoteConfigStore.isRateConnectionAvailable) {
      return const SizedBox.shrink();
    }
    return Observer(
      builder: (context) => Column(
        children: [
          Divider(
            height: 0,
            color: switch (theme.brightness) {
              Brightness.light => Palette.lightBlue,
              Brightness.dark => Palette.darkIndigo,
            },
          ).padding(left: 40),
          Row(
            children: [
              Expanded(
                child: EasyText(
                  LocaleKeys.rateConnection.tr(),
                  color: theme.colorScheme.onSecondaryContainer,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              _RateConnectionIconBtn(
                connectionRated: vpnStore.connectionRated,
                rateConnectionMode: RateConnectionRequestModeEnum.like,
              ),
              _RateConnectionIconBtn(
                connectionRated: vpnStore.connectionRated,
                rateConnectionMode: RateConnectionRequestModeEnum.dislike,
              ),
            ],
          ).padding(left: 40),
        ],
      ),
    );
  }
}

class _RateConnectionIconBtn extends StatelessWidget {
  const _RateConnectionIconBtn({
    required this.connectionRated,
    required this.rateConnectionMode,
  });

  final RateConnectionRequestModeEnum rateConnectionMode;
  final RateConnectionRequestModeEnum? connectionRated;

  @override
  Widget build(BuildContext context) {
    final isActive = connectionRated == rateConnectionMode;

    return IconButton(
      onPressed: () => handleRateConnection(context, rateConnectionMode),
      icon: SvgIcon(
        asset: switch (rateConnectionMode) {
          RateConnectionRequestModeEnum.like => Asset.icons.thumbsUp(context),
          RateConnectionRequestModeEnum.dislike => Asset.icons.thumbsDown(context),
        },
        color: isActive ? Palette.purple : null,
      ),
      style: IconButton.styleFrom(
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.all(2),
      ),
    );
  }

  Future<void> handleRateConnection(
    BuildContext context,
    RateConnectionRequestModeEnum rateConnectionMode,
  ) async {
    showRateConnectionDialog(context, rateConnectionMode);
  }
}
