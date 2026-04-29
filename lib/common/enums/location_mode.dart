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

  static LocationMode from({
    required VPNLocation location,
    required bool residentialIPsAllowed,
    required Set<VPNLocation> unavailableLocations,
    required Subscription? subscription,
    required bool isConnected,
    required bool isLoading,
    required VPNLocation? vpnLocation,
    required VPNLocation? connectingLocation,
    bool isSubscriptionLoading = false,
  }) {
    if (isLoading && (location == vpnLocation || location == connectingLocation)) {
      return LocationMode.connecting;
    }
    if (isConnected && location == vpnLocation) {
      return LocationMode.connected;
    }
    if (isSubscriptionLoading) {
      return LocationMode.loading;
    }
    if (subscription == null || !subscription.active) {
      return LocationMode.unsubscribed;
    }
    if (isSubscriptionLoading) {
      return LocationMode.loading;
    }
    if (location.ipType == IPType.residential) {
      if (!residentialIPsAllowed || !location.isAvailable) {
        return LocationMode.unsupportedByPlan;
      }
    }
    if (unavailableLocations.contains(location) || !location.isAvailable) {
      return LocationMode.unavailable;
    }
    return LocationMode.available;
  }
}
