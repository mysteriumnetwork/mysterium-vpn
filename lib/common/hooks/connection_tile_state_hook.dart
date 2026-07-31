import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/is_authenticated_hook.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

typedef ConnectionTileState = ({
  MainIpCardStatus status,
  String connectLabel,
  String disconnectLabel,
  String connectingLabel,
  String noConnectionTitle,
  String noConnectionDescription,
  VoidCallback? onToggle,
  VoidCallback onDismissPreview,
});

ConnectionTileState useConnectionTileState(WidgetRef ref) {
  final context = useContext();
  final connectionDisplayStore = ref.watch(connectionDisplayStorePOD);
  final vpnStore = ref.watch(vpnStorePOD);
  final selectedLocationStore = ref.watch(selectedLocationStorePOD);
  final locationsStore = ref.watch(locationsStorePOD);
  final unavailableLocationsStore = ref.watch(unavailableLocationsStorePOD);
  final subscriptionStore = ref.watch(subscriptionStorePOD);
  final handleToggleConnection = useHandleToggleConnection();
  final handleUpgradePlan = useHandleUpgradePlan();
  final isAuthenticated = useIsAuthenticated();

  final hasDifferentSelection = useComputedValue(
    () => connectionDisplayStore.hasDifferentSelection,
  );
  final selectedLocation = useComputedValue(() => selectedLocationStore.value);
  final connectedLocation = useComputedValue(() => vpnStore.location);
  final isConnected = useComputedValue(() => vpnStore.isConnected);
  final isLoading = useComputedValue(() => connectionDisplayStore.isLoading);
  final ipInfo = useComputedValue(() => connectionDisplayStore.connectionIP);
  final targetLocation = useComputedValue(() => connectionDisplayStore.targetLocation);
  final intent = useComputedValue(() => connectionDisplayStore.connectionIntent);
  final displayLocation = useComputedValue(() => connectionDisplayStore.displayLocation);
  final parentLocation = useComputedValue(() => connectionDisplayStore.parentLocation);
  final isLocationAvailable = useComputedValue(() => connectionDisplayStore.isLocationAvailable);
  final vpnStatus = useComputedValue(() => vpnStore.vpnStatus);
  final needsUpgrade = useComputedValue(() {
    // Read directly from MobX stores so the Computed tracks these dependencies.
    // Capturing intermediate hook variables would be stale (closure is fixed at initHook).
    final hasDiff = connectionDisplayStore.hasDifferentSelection;
    final selected = selectedLocationStore.value;
    final display = connectionDisplayStore.displayLocation;
    final intentLocation = hasDiff ? selected : display;
    return intentLocation != null &&
        LocationMode.from(
              location: intentLocation,
              isAuthenticated: isAuthenticated,
              residentialIPsAllowed: subscriptionStore.residentialIPsAllowed,
              unavailableLocations: unavailableLocationsStore.unavailableLocations,
              subscription: subscriptionStore.subscriptionFuture.value,
              isConnected: vpnStore.isConnected,
              isLoading: connectionDisplayStore.isLoading,
              vpnLocation: vpnStore.location,
              connectingLocation: null,
              isSubscriptionLoading: subscriptionStore.isSubscriptionLoading,
            ) ==
            LocationMode.unsupportedByPlan;
  });

  final MainIpCardStatus status;
  var noConnectionTitle = S.current.connectBestServer;
  var noConnectionDescription = S.current.orSelectCountryManually;
  final upgradeLabel = needsUpgrade ? S.current.subscriptionUpgrade : null;
  var connectLabel = upgradeLabel ?? S.current.connect;
  final disconnectLabel = upgradeLabel ?? S.current.disconnect;

  if (hasDifferentSelection) {
    final connected = connectedLocation!;
    final connectedParent = locationsStore.findParent(connected);
    final (country: connectedCountry, city: connectedCity) = locationDisplayNames(
      context,
      location: connected,
      parent: connectedParent,
    );

    final isSelectedUnavailable = unavailableLocationsStore.unavailableLocations.contains(
      selectedLocation,
    );
    final switchLabel = isSelectedUnavailable
        ? S.current.locationUnavailableAction
        : S.current.switchToLocationBtn(selectedLocation!.getName(context));

    status = MainIpCardNewIpPreview(
      country: connectedCountry,
      countryIcon: CircleFlag(connected.countryCode, size: 40),
      city: connectedCity,
      ipAddress: ipInfo ?? '',
      previewCountry: selectedLocation!.getName(context),
      previewCountryIcon: CircleFlag(selectedLocation.countryCode, size: 32),
      switchLabel: switchLabel,
    );
  } else {
    final (:country, :city) = locationDisplayNames(
      context,
      location: displayLocation,
      parent: parentLocation,
    );

    if (displayLocation == null) {
      status = const MainIpCardNotConnected();
    } else if (!isLocationAvailable) {
      status = const MainIpCardNotConnected();
    } else if (isConnected) {
      status = MainIpCardConnected(
        country: country,
        countryIcon: CircleFlag(displayLocation.countryCode, size: 40),
        city: city,
        ipAddress: ipInfo ?? '',
      );
      // Before connecting, show the specific location the user picked (city or
      // state), not its parent country. For country-level picks this is the
      // country itself.
    } else if (isLoading) {
      status = MainIpCardConnecting(
        country: displayLocation.getName(context),
        countryIcon: CircleFlag(displayLocation.countryCode, size: 32),
        serviceQuality: displayLocation.ipType.localizedLabel,
      );
    } else {
      status = MainIpCardLocationSelected(
        country: displayLocation.getName(context),
        countryIcon: CircleFlag(displayLocation.countryCode, size: 32),
        serviceQuality: displayLocation.ipType.localizedLabel,
      );
    }

    if (displayLocation != null && !isLocationAvailable) {
      noConnectionTitle = S.current.locationUnavailableTitle(displayLocation.getName(context));
      noConnectionDescription = S.current.locationUnavailableSubtitle;
      connectLabel = S.current.locationUnavailableAction;
    }
  }

  final onToggle = isLoading
      ? null
      : needsUpgrade
      ? handleUpgradePlan
      : () => handleToggleConnection(location: targetLocation, intent: intent);

  final onDismissPreview = useCallback(() {
    selectedLocationStore.value = null;
  }, [selectedLocationStore]);

  return (
    status: status,
    connectLabel: connectLabel,
    disconnectLabel: disconnectLabel,
    connectingLabel: vpnStatus == VpnConnectionStatus.disconnecting
        ? S.current.disconnecting
        : S.current.connecting,
    noConnectionTitle: noConnectionTitle,
    noConnectionDescription: noConnectionDescription,
    onToggle: onToggle,
    onDismissPreview: onDismissPreview,
  );
}
