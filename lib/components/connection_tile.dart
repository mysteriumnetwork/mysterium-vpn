import 'package:circle_flags/circle_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/components/dialogs/rate_connection_dialog.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart' hide ScreenType;
import 'package:styled_widget/styled_widget.dart';
import 'package:vpn_api/vpn_api.dart';

class ConnectionTile extends HookConsumerWidget {
  const ConnectionTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionDisplayStore = ref.watch(connectionDisplayStorePOD);
    final vpnStore = ref.watch(vpnStorePOD);
    final analyticsStore = ref.watch(analyticsStorePOD);
    final vpnProtocol = ref.watch(vpnProtocolStorePOD);
    final selectedLocationStore = ref.watch(selectedLocationStorePOD);
    final locationsStore = ref.watch(locationsStorePOD);
    final unavailableLocationsStore = ref.watch(unavailableLocationsStorePOD);

    final handleToggleConnection = useHandleToggleConnection();

    Future<void> handleRefreshIP() async {
      analyticsStore.logRefreshIP(connectionDisplayStore.connectionIP);
      selectedLocationStore.value = null;
      await vpnStore.manageConnection(refreshIP: true);
    }

    return Observer(
      builder: (context) {
        final selectedLocation = selectedLocationStore.value;
        final connectedLocation = vpnStore.location;
        final isConnected = vpnStore.isConnected;
        final isLoading = connectionDisplayStore.isLoading;
        final ipInfo = connectionDisplayStore.connectionIP;
        final targetLocation = connectionDisplayStore.targetLocation;
        final intent = connectionDisplayStore.connectionIntent;

        final hasDifferentSelection = _isDifferentFromConnected(
          selected: selectedLocation,
          connected: connectedLocation,
          isConnected: isConnected,
        );

        final MainIpCardStatus status;
        var noConnectionTitle = LocaleKeys.connectBestServer.tr();
        var noConnectionDescription = LocaleKeys.orSelectCountryManually.tr();
        var connectLabel = LocaleKeys.connect.tr();
        var disconnectLabel = LocaleKeys.disconnect.tr();

        if (hasDifferentSelection) {
          // Connected and a different location is selected.
          final connected = connectedLocation!;
          final connectedParent = locationsStore.findParent(connected);
          final connectedCountry = connectedParent?.getName(context) ?? connected.getName(context);
          final connectedCity = connectedParent != null ? connected.getName(context) : '';
          final connectedServiceQuality = connected.ipType == IPType.residential
              ? LocaleKeys.residential.tr()
              : LocaleKeys.highSpeed.tr();
          final connectedIpPoolCount = connected.nodeCount ?? 0;

          final isSelectedUnavailable = unavailableLocationsStore.unavailableLocations.contains(
            selectedLocation,
          );
          final switchLabel = isSelectedUnavailable
              ? LocaleKeys.locationUnavailableAction.tr()
              : LocaleKeys.switchToLocationBtn.tr(
                  namedArgs: {'switchLocation': selectedLocation!.getName(context)},
                );

          final isMobile = ScreenType.of(context) <= ScreenType.mobile;

          if (isMobile) {
            // Mobile: preview bar (selected) above the connected card.
            status = MainIpCardNewIpPreview(
              country: connectedCountry,
              countryIcon: CircleFlag(connected.countryCode, size: 32),
              city: connectedCity,
              ipAddress: ipInfo ?? '',
              serviceQuality: connectedServiceQuality,
              ipPoolCount: connectedIpPoolCount,
              previewCountry: selectedLocation!.getName(context),
              previewCountryIcon: CircleFlag(selectedLocation.countryCode, size: 32),
              switchLabel: switchLabel,
            );
          } else {
            // Desktop/Tablet: connected card showing the selected country's
            // identity with the current connection's IP / refresh / pool data.
            // disconnectLabel is overridden to the switch label so the button
            // reads "Switch to Poland" with the same ButtonSecondary style.
            final selectedParent = locationsStore.findParent(selectedLocation!);
            final selectedCountry =
                selectedParent?.getName(context) ?? selectedLocation.getName(context);
            final selectedCity = selectedParent != null ? selectedLocation.getName(context) : '';

            status = MainIpCardConnected(
              country: selectedCountry,
              countryIcon: CircleFlag(selectedLocation.countryCode, size: 32),
              city: selectedCity,
              ipAddress: ipInfo ?? '',
              serviceQuality: connectedServiceQuality,
              ipPoolCount: connectedIpPoolCount,
            );
            disconnectLabel = switchLabel;
          }
        } else {
          final location = connectionDisplayStore.displayLocation;
          final parent = connectionDisplayStore.parentLocation;
          final isLocationAvailable = connectionDisplayStore.isLocationAvailable;

          final country = parent?.getName(context) ?? location?.getName(context) ?? '';
          final city = parent != null ? location?.getName(context) ?? '' : '';
          final ipType = location?.ipType;
          final ipPoolCount =
              (isConnected ? connectedLocation?.nodeCount : location?.nodeCount) ?? 0;
          final countryIcon = location != null
              ? CircleFlag(location.countryCode, size: 32)
              : const SizedBox(width: 32, height: 32);
          final serviceQuality = ipType == IPType.residential
              ? LocaleKeys.residential.tr()
              : LocaleKeys.highSpeed.tr();

          if (location == null) {
            status = const MainIpCardNotConnected();
          } else if (!isLocationAvailable) {
            status = const MainIpCardNotConnected();
          } else if (isConnected) {
            status = MainIpCardConnected(
              country: country,
              countryIcon: countryIcon,
              city: city,
              ipAddress: ipInfo ?? '',
              serviceQuality: serviceQuality,
              ipPoolCount: ipPoolCount,
            );
          } else if (isLoading) {
            status = MainIpCardConnecting(
              country: country,
              countryIcon: countryIcon,
              serviceQuality: serviceQuality,
            );
          } else {
            status = MainIpCardLocationSelected(
              country: country,
              countryIcon: countryIcon,
              serviceQuality: serviceQuality,
            );
          }

          if (location != null && !isLocationAvailable) {
            noConnectionTitle = LocaleKeys.locationUnavailableTitle.tr(
              args: [location.getName(context)],
            );
            noConnectionDescription = LocaleKeys.locationUnavailableSubtitle.tr();
            connectLabel = LocaleKeys.locationUnavailableAction.tr();
          }
        }

        final onToggle = isLoading
            ? null
            : () => handleToggleConnection(location: targetLocation, intent: intent);

        return Column(
          children: [
            MainIpCard(
              status: status,
              connectLabel: connectLabel,
              disconnectLabel: disconnectLabel,
              connectingLabel: vpnStore.vpnStatus == VpnConnectionStatus.disconnecting
                  ? LocaleKeys.disconnecting.tr()
                  : LocaleKeys.connecting.tr(),
              noConnectionTitle: noConnectionTitle,
              noConnectionDescription: noConnectionDescription,
              connectionRatingLabel: LocaleKeys.rateConnection.tr(),
              onConnect: onToggle,
              onDisconnect: onToggle,
              onRefreshIp: handleRefreshIP,
              onThumbsUp: () =>
                  showRateConnectionDialog(context, RateConnectionRequestModeEnum.like),
              onThumbsDown: () =>
                  showRateConnectionDialog(context, RateConnectionRequestModeEnum.dislike),
              onDismissPreview: () => selectedLocationStore.value = null,
              onSwitchCountry: onToggle,
              refreshIpTooltip: LocaleKeys.refreshIP.tr(),
              connectionRating: switch (connectionDisplayStore.connectionRated) {
                RateConnectionRequestModeEnum.like => ConnectionRating.thumbsUp,
                RateConnectionRequestModeEnum.dislike => ConnectionRating.thumbsDown,
                _ => ConnectionRating.none,
              },
            ),
            if (Env.flavor.isDev)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Protocol: ${vpnProtocol.protocol.name}',
                  style: const TextStyle(
                    fontSize: 8,
                    color: Palette.warning,
                    fontWeight: FontWeight.w800,
                  ),
                ).padding(left: 12),
              ),
          ],
        );
      },
    );
  }

  /// Returns true when the user has selected a location that differs from
  /// the currently connected one (i.e. a "switch" scenario).
  static bool _isDifferentFromConnected({
    required VPNLocation? selected,
    required VPNLocation? connected,
    required bool isConnected,
  }) {
    if (!isConnected || selected == null || connected == null) {
      return false;
    }
    if (connected == VPNLocation.closest) {
      return false;
    }
    if (selected.id == connected.id) {
      return false;
    }
    if (selected.isCountry && selected.countryCode == connected.countryCode) {
      return false;
    }
    return true;
  }
}
