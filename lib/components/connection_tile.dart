import 'package:circle_flags/circle_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
import 'package:mysterium_vpn/common/hooks/connection_status_color_hook.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/connect_text_button.dart';
import 'package:mysterium_vpn/components/dialogs/rate_connection_dialog.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:vpn_api/vpn_api.dart';

class ConnectionTile extends HookConsumerWidget {
  const ConnectionTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationsStore = ref.watch(locationsStorePOD);
    final selectedLocationStore = ref.watch(selectedLocationStorePOD);
    final unavailableLocationsStore = ref.watch(unavailableLocationsStorePOD);
    final vpnStore = ref.watch(vpnStorePOD);
    final analyticsStore = ref.watch(analyticsStorePOD);

    final location = useComputedValue(
      () {
        final selectedLocation = selectedLocationStore.value;
        final location = vpnStore.location;
        final connectingLocation = vpnStore.connectingLocation;
        final potentialLocation = vpnStore.potentialLocation;

        final result = selectedLocation ?? location ?? connectingLocation ?? potentialLocation;
        if (result == VPNLocation.closest) {
          return null;
        }

        return result;
      },
      [vpnStore, locationsStore, selectedLocationStore],
    );

    final parent = useComputedValue(
      () {
        if (location == null) {
          return null;
        }
        return locationsStore.findParent(location);
      },
      [location],
    );

    /// If selected location is unavailable, we show parent location (country) instead.
    /// If parent location is also unavailable (all locations in that country are unavailable),
    /// we show best location (closest).
    final targetLocation = useComputedValue(
      () {
        if (location == null) {
          return null;
        }
        return unavailableLocationsStore.unavailableLocations.contains(location)
            ? parent
            : location;
      },
      [location, parent],
    );

    final isConnected = useIsLocationConnected(location);
    final ipInfo = useComputedValue(() => vpnStore.vpnConnection?.connectionIP);
    final isLocationAvailable = location != null && location == targetLocation;

    final handleToggleConnection = useHandleToggleConnection();
    final onTap = useComputedValue(
      () {
        if (vpnStore.isLoading) {
          return null;
        }

        final intent = targetLocation == null && location != null ? UserIntent.bestSpeed : null;

        return () => handleToggleConnection(location: targetLocation, intent: intent);
      },
      [handleToggleConnection, targetLocation, location],
    );

    Future<void> handleRefreshIP() async {
      analyticsStore.logRefreshIP(ipInfo);
      await vpnStore.startConnectionWithRefreshIP();
    }

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (location == null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _Placeholder(
                title: LocaleKeys.connectBestServer.tr(),
                subtitle: LocaleKeys.orSelectCountryManually.tr(),
                icon: Asset.icons.connectPrompt(context),
              ),
            )
          else if (!isLocationAvailable)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _Placeholder(
                title: LocaleKeys.locationUnavailableTitle.tr(args: [location.getName(context)]),
                subtitle: LocaleKeys.locationUnavailableSubtitle.tr(),
                icon: Asset.icons.fix(context),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _Location(
                location: location,
                parent: parent,
                ip: ipInfo,
                onRefreshIPPressed: handleRefreshIP,
              ),
            ),
          ConnectTextButton(
            onPressed: onTap,
            location: targetLocation,
            size: const Size(double.infinity, 42),
            textConnect:
                targetLocation != location ? LocaleKeys.locationUnavailableAction.tr() : null,
          ),
          if (isConnected ?? false) const SizedBox(height: 16),
          if (isConnected ?? false) _RateConnection(),
        ],
      ),
    );
  }
}

class _Card extends HookWidget {
  const _Card({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = useConnectionStatusColor();

    return Material(
      color: theme.palette.connectionTileBackgroundColor,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: borderColor),
      ),
      clipBehavior: Clip.hardEdge,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final SvgGenImage icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        icon.svg(width: 38, height: 38),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 2,
            children: [
              EasyText(
                title,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              EasyText(
                subtitle,
                fontSize: 12,
                color: theme.palette.subtitleColor,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Location extends HookWidget {
  const _Location({
    required this.location,
    required this.parent,
    required this.ip,
    required this.onRefreshIPPressed,
  });

  final VPNLocation location;
  final VPNLocation? parent;
  final String? ip;
  final VoidCallback onRefreshIPPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ipType = location.ipType;
    final title = parent?.getName(context) ?? location.getName(context);
    final subtitle = parent != null ? location.getName(context) : null;
    final isConnected = useIsLocationConnected(location);

    final extras = [
      if (ip != null) ip!,
      if (ipType == IPType.residential)
        LocaleKeys.residential.tr()
      else if (ipType == IPType.datacenter)
        LocaleKeys.highSpeed.tr(),
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        CircleFlag(location.countryCode, size: 38),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              EasyText(
                title,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: EasyText(subtitle, fontSize: 12, color: theme.palette.subtitleColor),
                ),
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 32),
                child: Row(
                  spacing: 16,
                  children: [
                    Expanded(
                      child: Row(
                        spacing: 8,
                        children: [
                          ...extras
                              .map<Widget>(
                                (it) => Flexible(
                                  child: EasyText(
                                    it,
                                    fontSize: 12,
                                    color: theme.palette.subtitleColor,
                                  ),
                                ),
                              )
                              .separateWith(
                                Container(
                                  color: theme.palette.subtitleColor,
                                  width: 1,
                                  height: 20,
                                ),
                              ),
                        ],
                      ),
                    ),
                    if (ip != null && (isConnected ?? false))
                      SvgIconButton(
                        asset: Asset.icons.refresh,
                        size: 16,
                        color: theme.palette.subtitleColor,
                        visualDensity: VisualDensity.compact,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: onRefreshIPPressed,
                      ),
                  ],
                ),
              ),
            ],
          ),
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
      builder: (context) => Row(
        spacing: 16,
        children: [
          Expanded(
            child: EasyText(
              LocaleKeys.rateConnection.tr(),
              color: theme.palette.subtitleColor,
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
    final theme = Theme.of(context);
    final isActive = connectionRated == rateConnectionMode;

    return SvgIconButton(
      asset: switch (rateConnectionMode) {
        RateConnectionRequestModeEnum.like => Asset.icons.thumbsUp(context),
        RateConnectionRequestModeEnum.dislike => Asset.icons.thumbsDown(context),
      },
      color: isActive ? Palette.purple : theme.palette.darkTextColor,
      visualDensity: VisualDensity.compact,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      size: 24,
      onPressed: () => handleRateConnection(context, rateConnectionMode),
    );
  }

  Future<void> handleRateConnection(
    BuildContext context,
    RateConnectionRequestModeEnum rateConnectionMode,
  ) async {
    showRateConnectionDialog(context, rateConnectionMode);
  }
}
