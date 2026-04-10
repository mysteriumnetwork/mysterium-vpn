import 'package:mysterium_vpn/core/enums/ip_type.dart';
import 'package:mysterium_vpn/models/models.dart';

enum LocationMode {
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
  }) {
    if (isLoading && (location == vpnLocation || location == connectingLocation)) {
      return LocationMode.connecting;
    }
    if (isConnected && location == vpnLocation) {
      return LocationMode.connected;
    }
    if (subscription == null || !subscription.active) {
      return LocationMode.unsubscribed;
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
