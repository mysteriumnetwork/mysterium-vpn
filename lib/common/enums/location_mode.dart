import 'package:mysterium_vpn/common/enums/ip_type.dart';
import 'package:mysterium_vpn/models/models.dart';

enum LocationMode {
  loading,
  connecting,
  connected,
  available,
  unavailable,
  unsubscribed,
  unsupportedByPlan;

  /// Whether the plan itself excludes [location], independent of availability
  /// or connection state.
  ///
  /// Shared by the location lists and by the connect-path guard, so every
  /// surface — lists, map, recents, favourites — gates identically.
  static bool isUnsupportedByPlan({
    required VPNLocation location,
    required bool residentialIPsAllowed,
    required bool cityLevelAllowed,
  }) =>
      (location.ipType == IPType.residential && !residentialIPsAllowed) ||
      (!location.isCountry && !cityLevelAllowed);

  static LocationMode from({
    required VPNLocation location,
    required bool isAuthenticated,
    required bool residentialIPsAllowed,
    required Set<VPNLocation> unavailableLocations,
    required Subscription? subscription,
    required bool isConnected,
    required bool isLoading,
    required VPNLocation? vpnLocation,
    required VPNLocation? connectingLocation,
    required bool cityLevelAllowed,
    bool isSubscriptionLoading = false,
  }) {
    if (isLoading && (location == vpnLocation || location == connectingLocation)) {
      return LocationMode.connecting;
    }
    if (isConnected && location == vpnLocation) {
      return LocationMode.connected;
    }
    if (!isAuthenticated) {
      return LocationMode.unsubscribed;
    }
    if (isSubscriptionLoading) {
      return LocationMode.loading;
    }
    if (subscription == null || !subscription.active) {
      return LocationMode.unsubscribed;
    }
    // Plan-support check has to run before the availability check for
    // residential. On plans that don't include residential IPs the API
    // returns `is_available: false` for every residential location — if we
    // returned `unavailable` for those we'd hide the upgrade affordance.
    // Genuine capacity-side unavailability for a plan that *does* include
    // residential still falls through to the availability check below.
    if (isUnsupportedByPlan(
      location: location,
      residentialIPsAllowed: residentialIPsAllowed,
      cityLevelAllowed: cityLevelAllowed,
    )) {
      return LocationMode.unsupportedByPlan;
    }
    if (unavailableLocations.contains(location) || !location.isAvailable) {
      return LocationMode.unavailable;
    }
    return LocationMode.available;
  }
}
