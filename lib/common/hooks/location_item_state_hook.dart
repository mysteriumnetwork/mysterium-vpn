import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

typedef LocationItemState = ({
  IpCardStatus countryStatus,
  List<IpCardItem> items,
  String subtitle,
  bool needsUpgrade,
  bool showCitiesAndStates,
  VoidCallback? onConnect,
});

LocationItemState useLocationItemState({
  required VPNLocation location,
  required void Function(VPNLocation) onTap,
  required WidgetRef ref,
}) {
  final context = useContext();
  final vpnStore = ref.watch(vpnStorePOD);
  final subscriptionStore = ref.watch(subscriptionStorePOD);
  final subscriptionFeaturesStore = ref.watch(subscriptionFeaturesStorePOD);
  final unavailableLocationsStore = ref.watch(unavailableLocationsStorePOD);
  final remoteConfig = ref.watch(remoteConfigStorePOD);
  final handleUpgradePlan = useHandleUpgradePlan();

  final children = location.children ?? const <VPNLocation>[];
  final showCitiesAndStates = remoteConfig.showCitiesAndStates && children.isNotEmpty;
  final locationHasStates = remoteConfig.countriesWithStates.contains(location.countryCode);

  final subscription = useComputedValue(() => subscriptionStore.subscriptionFuture.value);

  final locationMode = useComputedValue(
    () => LocationMode.from(
      location: location,
      residentialIPsAllowed: subscriptionFeaturesStore.residentialIPsAllowed,
      unavailableLocations: unavailableLocationsStore.unavailableLocations,
      subscription: subscription,
      isConnected: vpnStore.isConnected,
      isLoading: vpnStore.isLoading,
      vpnLocation: vpnStore.location,
      connectingLocation: vpnStore.connectingLocation,
    ),
    [location, location.isAvailable, subscription],
  );

  final countryStatus = switch (locationMode) {
    LocationMode.connecting => IpCardStatus.connecting,
    LocationMode.connected => IpCardStatus.connected,
    LocationMode.unavailable => IpCardStatus.disabled,
    _ => IpCardStatus.idle,
  };

  final subtitle = showCitiesAndStates
      ? locationHasStates
            ? LocaleKeys.locationItemStatesCount.plural(
                children.length,
                namedArgs: {'statesNum': children.length.toString()},
              )
            : LocaleKeys.locationItemCityCount.plural(children.length)
      : LocaleKeys.locationItemNodeCount.plural(location.nodeCount ?? 0);

  final items = useComputedValue(() {
    if (!showCitiesAndStates) {
      return <IpCardItem>[];
    }
    return children.map((child) {
      final childMode = LocationMode.from(
        location: child,
        residentialIPsAllowed: subscriptionFeaturesStore.residentialIPsAllowed,
        unavailableLocations: unavailableLocationsStore.unavailableLocations,
        subscription: subscription,
        isConnected: vpnStore.isConnected,
        isLoading: vpnStore.isLoading,
        vpnLocation: vpnStore.location,
        connectingLocation: vpnStore.connectingLocation,
      );
      final childPlusUpgrade = childMode == LocationMode.unsupportedByPlan;
      final status = switch (childMode) {
        LocationMode.connecting => IpCardStatus.connecting,
        LocationMode.connected => IpCardStatus.selected,
        LocationMode.unavailable => IpCardStatus.disabled,
        _ => IpCardStatus.idle,
      };
      return IpCardItem(
        name: child.getName(context),
        subtitle: LocaleKeys.locationItemNodeCount.plural(child.nodeCount ?? 0),
        status: status,
        plusUpgrade: childPlusUpgrade,
        onTap: switch (childMode) {
          LocationMode.unsupportedByPlan => handleUpgradePlan,
          LocationMode.unavailable || LocationMode.connecting => null,
          _ => vpnStore.isLoading ? null : () => onTap(child),
        },
      );
    }).toList();
    // onTap and locationMode are intentionally excluded from keys: onTap is not
    // a MobX observable, and locationMode would cause unnecessary Computed churn
    // on every parent-mode change (child modes are re-derived independently and
    // tracked by MobX inside the closure).
  }, [children, showCitiesAndStates, subscription]);

  final needsUpgrade = locationMode == LocationMode.unsupportedByPlan;

  final onConnect = switch (locationMode) {
    LocationMode.unsupportedByPlan => handleUpgradePlan,
    LocationMode.unavailable || LocationMode.connecting => null,
    _ => vpnStore.isLoading ? null : () => onTap(location),
  };

  return (
    countryStatus: countryStatus,
    items: items,
    subtitle: subtitle,
    needsUpgrade: needsUpgrade,
    showCitiesAndStates: showCitiesAndStates,
    onConnect: onConnect,
  );
}
