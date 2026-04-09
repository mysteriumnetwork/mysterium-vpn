import 'package:circle_flags/circle_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/components/dialogs/rate_connection_dialog.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart' hide ScreenType;
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
  final subscriptionFeaturesStore = ref.watch(subscriptionFeaturesStorePOD);
  final subscriptionStore = ref.watch(subscriptionStorePOD);
  final handleToggleConnection = useHandleToggleConnection();
  final handleUpgradePlan = useHandleUpgradePlan();

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
  final connectionRated = useComputedValue(() => connectionDisplayStore.connectionRated);
  final vpnStatus = useComputedValue(() => vpnStore.vpnStatus);
  final subscription = useComputedValue(() => subscriptionStore.subscriptionFuture.value);

  // The location the user intends to connect to: selected (switch scenario) or display.
  final intentLocation = hasDifferentSelection ? selectedLocation : displayLocation;
  final needsUpgrade =
      intentLocation != null &&
      LocationMode.from(
            location: intentLocation,
            residentialIPsAllowed: subscriptionFeaturesStore.residentialIPsAllowed,
            unavailableLocations: unavailableLocationsStore.unavailableLocations,
            subscription: subscription,
            isConnected: isConnected,
            isLoading: isLoading,
            vpnLocation: connectedLocation,
            connectingLocation: null,
          ) ==
          LocationMode.unsupportedByPlan;

  final isMobile = ScreenType.of(context) <= ScreenType.mobile;

  final MainIpCardStatus status;
  var noConnectionTitle = LocaleKeys.connectBestServer.tr();
  var noConnectionDescription = LocaleKeys.orSelectCountryManually.tr();
  var connectLabel = LocaleKeys.connect.tr();
  var disconnectLabel = LocaleKeys.disconnect.tr();

  if (hasDifferentSelection) {
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

    if (isMobile) {
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
      final selectedParent = locationsStore.findParent(selectedLocation!);
      final selectedCountry = selectedParent?.getName(context) ?? selectedLocation.getName(context);
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
    final country = parentLocation?.getName(context) ?? displayLocation?.getName(context) ?? '';
    final city = parentLocation != null ? displayLocation?.getName(context) ?? '' : '';
    final ipType = displayLocation?.ipType;
    final ipPoolCount =
        (isConnected ? connectedLocation?.nodeCount : displayLocation?.nodeCount) ?? 0;
    final countryIcon = displayLocation != null
        ? CircleFlag(displayLocation.countryCode, size: 32)
        : const SizedBox(width: 32, height: 32);
    final serviceQuality = ipType == IPType.residential
        ? LocaleKeys.residential.tr()
        : LocaleKeys.highSpeed.tr();

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

    if (displayLocation != null && !isLocationAvailable) {
      noConnectionTitle = LocaleKeys.locationUnavailableTitle.tr(
        args: [displayLocation.getName(context)],
      );
      noConnectionDescription = LocaleKeys.locationUnavailableSubtitle.tr();
      connectLabel = LocaleKeys.locationUnavailableAction.tr();
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
        ? LocaleKeys.disconnecting.tr()
        : LocaleKeys.connecting.tr(),
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
