import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/is_authenticated_hook.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:vpn_api/vpn_api.dart';

typedef ConnectionTileState = ({
  MainIpCardStatus status,
  String connectLabel,
  String disconnectLabel,
  String connectingLabel,
  String noConnectionTitle,
  String noConnectionDescription,
  VoidCallback? onToggle,
  VoidCallback onRefreshIP,
  VoidCallback onDismissPreview,
  VoidCallback onThumbsUp,
  VoidCallback onThumbsDown,
  ConnectionRating connectionRating,
});

ConnectionTileState useConnectionTileState(WidgetRef ref) {
  final context = useContext();
  final connectionDisplayStore = ref.watch(connectionDisplayStorePOD);
  final vpnStore = ref.watch(vpnStorePOD);
  final analyticsStore = ref.watch(analyticsStorePOD);
  final selectedLocationStore = ref.watch(selectedLocationStorePOD);
  final locationsStore = ref.watch(locationsStorePOD);
  final unavailableLocationsStore = ref.watch(unavailableLocationsStorePOD);
  final subscriptionStore = ref.watch(subscriptionStorePOD);
  final ipRefreshExhaustionStore = ref.watch(ipRefreshExhaustionStorePOD);
  final handleToggleConnection = useHandleToggleConnection();
  final handleUpgradePlan = useHandleUpgradePlan();
  final isAuthenticated = useIsAuthenticated();

  final hasDifferentSelection = useComputedValue(
    () => connectionDisplayStore.hasDifferentSelection,
  );
  final selectedLocation = useComputedValue(() => selectedLocationStore.value);
  final connectedLocation = useComputedValue(() => vpnStore.location);
  final connectedIpPoolCount = useComputedValue(() => vpnStore.connectedIpPoolCount);
  final isConnected = useComputedValue(() => vpnStore.isConnected);
  final isLoading = useComputedValue(() => connectionDisplayStore.isLoading);
  final ipInfo = useComputedValue(() => connectionDisplayStore.connectionIP);
  final targetLocation = useComputedValue(() => connectionDisplayStore.targetLocation);
  final intent = useComputedValue(() => connectionDisplayStore.connectionIntent);
  final displayLocation = useComputedValue(() => connectionDisplayStore.displayLocation);
  final parentLocation = useComputedValue(() => connectionDisplayStore.parentLocation);
  final isLocationAvailable = useComputedValue(() => connectionDisplayStore.isLocationAvailable);
  final connectionRated = useComputedValue(() => connectionDisplayStore.connectionRated);
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
    final connectedCountry = connectedParent?.getName(context) ?? connected.getName(context);
    final connectedCity = connectedParent != null ? connected.getName(context) : '';
    final connectedServiceQuality = connected.ipType == IPType.residential
        ? S.current.residential
        : S.current.highSpeed;

    final isSelectedUnavailable = unavailableLocationsStore.unavailableLocations.contains(
      selectedLocation,
    );
    final switchLabel = isSelectedUnavailable
        ? S.current.locationUnavailableAction
        : S.current.switchToLocationBtn(selectedLocation!.getName(context));

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
    final country = parentLocation?.getName(context) ?? displayLocation?.getName(context) ?? '';
    final city = parentLocation != null ? displayLocation?.getName(context) ?? '' : '';
    final ipType = displayLocation?.ipType;
    final ipPoolCount = isConnected ? connectedIpPoolCount : (displayLocation?.nodeCount ?? 0);
    final countryIcon = displayLocation != null
        ? CircleFlag(displayLocation.countryCode, size: 32)
        : const SizedBox(width: 32, height: 32);
    final serviceQuality = ipType == IPType.residential
        ? S.current.residential
        : S.current.highSpeed;

    if (displayLocation == null) {
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
      // Before connecting, show the specific location the user picked (city or
      // state), not its parent country. For country-level picks this is the
      // country itself.
    } else if (isLoading) {
      status = MainIpCardConnecting(
        country: displayLocation.getName(context),
        countryIcon: countryIcon,
        serviceQuality: serviceQuality,
      );
    } else {
      status = MainIpCardLocationSelected(
        country: displayLocation.getName(context),
        countryIcon: countryIcon,
        serviceQuality: serviceQuality,
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

  final onRefreshIP = useCallback(() async {
    analyticsStore.logRefreshIP(connectionDisplayStore.connectionIP);
    selectedLocationStore.value = null;
    await vpnStore.manageConnection(refreshIP: true);
  }, [analyticsStore, connectionDisplayStore, selectedLocationStore, vpnStore]);

  final onDismissPreview = useCallback(() {
    selectedLocationStore.value = null;
  }, [selectedLocationStore]);

  final onThumbsUp = useCallback(
    () => showRateConnectionDialog(context, RateConnectionRequestModeEnum.like),
    [],
  );

  final onThumbsDown = useCallback(
    () => showRateConnectionDialog(context, RateConnectionRequestModeEnum.dislike),
    [],
  );

  useReaction(() => ipRefreshExhaustionStore.exhaustionNotice, (VPNLocation? location) {
    if (location == null) {
      return;
    }
    showSnackbar(
      ipRefreshExhaustedMessage(
        isCountry: location.isCountry,
        locationName: location.getName(context),
      ),
      type: SnackbarType.info,
    );
    ipRefreshExhaustionStore.clearNotice();
  });

  final connectionRating = switch (connectionRated) {
    RateConnectionRequestModeEnum.like => ConnectionRating.thumbsUp,
    RateConnectionRequestModeEnum.dislike => ConnectionRating.thumbsDown,
    _ => ConnectionRating.none,
  };

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
    onRefreshIP: onRefreshIP,
    onDismissPreview: onDismissPreview,
    onThumbsUp: onThumbsUp,
    onThumbsDown: onThumbsDown,
    connectionRating: connectionRating,
  );
}
