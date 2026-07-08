import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/is_authenticated_hook.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/l10n/arb_locale.dart';
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
  final unavailableLocationsStore = ref.watch(unavailableLocationsStorePOD);
  final remoteConfig = ref.watch(remoteConfigStorePOD);
  final isAuthenticated = useIsAuthenticated();
  final handleUpgradePlan = useHandleUpgradePlan();

  final children = location.children ?? const <VPNLocation>[];
  final showCitiesAndStates = remoteConfig.showCitiesAndStates && children.isNotEmpty;
  final locationHasStates = remoteConfig.countriesWithStates.contains(location.countryCode);
  // getName resolves the name from `activeLocale` (not MobX), so it must key the
  // `items` Computed below — otherwise city names wouldn't re-translate on a
  // locale switch.
  final localeTag = activeLocale.toLanguageTag();

  final subscription = useComputedValue(() => subscriptionStore.subscriptionFuture.value);
  final residentialIPsAllowed = useComputedValue(() => subscriptionStore.residentialIPsAllowed);
  final isSubscriptionLoading = useComputedValue(() => subscriptionStore.isSubscriptionLoading);

  final locationMode = useComputedValue(
    () => LocationMode.from(
      location: location,
      isAuthenticated: isAuthenticated,
      residentialIPsAllowed: residentialIPsAllowed,
      unavailableLocations: unavailableLocationsStore.unavailableLocations,
      subscription: subscription,
      isConnected: vpnStore.isConnected,
      isLoading: vpnStore.isLoading,
      vpnLocation: vpnStore.location,
      connectingLocation: vpnStore.connectingLocation,
      isSubscriptionLoading: isSubscriptionLoading,
    ),
    [
      location,
      location.isAvailable,
      subscription,
      residentialIPsAllowed,
      isSubscriptionLoading,
      isAuthenticated,
    ],
  );

  // When a child city of this country is the active VPN location, surface the
  // country itself as "connected · <city>" — matches the Figma collapsed row.
  final connectedChild = useComputedValue(() {
    final vpnLoc = vpnStore.location;
    if (!vpnStore.isConnected || vpnLoc == null) {
      return null;
    }
    if (vpnLoc.countryCode != location.countryCode || vpnLoc.isCountry) {
      return null;
    }
    return vpnLoc;
  }, [location.countryCode]);

  final countryStatus = connectedChild != null
      ? IpCardStatus.connected
      : switch (locationMode) {
          LocationMode.connecting => IpCardStatus.connecting,
          LocationMode.connected => IpCardStatus.connected,
          LocationMode.loading => IpCardStatus.loading,
          LocationMode.unavailable => IpCardStatus.disabled,
          _ => IpCardStatus.idle,
        };

  final defaultSubtitle = showCitiesAndStates
      ? locationHasStates
            ? S.current.locationItemStatesCount(children.length)
            : S.current.locationItemCityCount(children.length)
      : S.current.locationItemNodeCount(location.nodeCount ?? 0);

  final subtitle = connectedChild != null
      ? '${S.current.connected} · ${connectedChild.getName(context)}'
      : defaultSubtitle;

  final items = useComputedValue(() {
    if (!showCitiesAndStates) {
      return <IpCardItem>[];
    }
    return children.map((child) {
      final childMode = LocationMode.from(
        location: child,
        isAuthenticated: isAuthenticated,
        residentialIPsAllowed: subscriptionStore.residentialIPsAllowed,
        unavailableLocations: unavailableLocationsStore.unavailableLocations,
        subscription: subscription,
        isConnected: vpnStore.isConnected,
        isLoading: vpnStore.isLoading,
        vpnLocation: vpnStore.location,
        connectingLocation: vpnStore.connectingLocation,
        isSubscriptionLoading: subscriptionStore.isSubscriptionLoading,
      );
      final childPlusUpgrade = childMode == LocationMode.unsupportedByPlan;
      final status = switch (childMode) {
        LocationMode.connecting => IpCardStatus.connecting,
        LocationMode.connected => IpCardStatus.selected,
        LocationMode.loading => IpCardStatus.loading,
        LocationMode.unavailable => IpCardStatus.disabled,
        _ => IpCardStatus.idle,
      };
      return IpCardItem(
        name: child.getName(context),
        subtitle: S.current.locationItemNodeCount(child.nodeCount ?? 0),
        status: status,
        plusUpgrade: childPlusUpgrade,
        onTap: switch (childMode) {
          LocationMode.unsupportedByPlan => handleUpgradePlan,
          LocationMode.unavailable || LocationMode.connecting || LocationMode.loading => null,
          _ => vpnStore.isLoading ? null : () => onTap(child),
        },
      );
    }).toList();
    // onTap and locationMode are intentionally excluded from keys: onTap is not
    // a MobX observable, and locationMode would cause unnecessary Computed churn
    // on every parent-mode change (child modes are re-derived independently and
    // tracked by MobX inside the closure).
  }, [children, showCitiesAndStates, subscription, isAuthenticated, localeTag]);

  final needsUpgrade = locationMode == LocationMode.unsupportedByPlan;

  final onConnect = switch (locationMode) {
    LocationMode.unsupportedByPlan => handleUpgradePlan,
    LocationMode.unavailable || LocationMode.connecting || LocationMode.loading => null,
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
