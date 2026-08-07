import 'package:collection/collection.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/stores/stores.dart';

part 'connection_decision_store.g.dart';

// ignore: library_private_types_in_public_api
class ConnectionDecisionStore = _ConnectionDecisionStore with _$ConnectionDecisionStore;

abstract class _ConnectionDecisionStore with Store {
  _ConnectionDecisionStore({
    required LocationsStore locationsStore,
    required RecentLocationsStore recentLocationsStore,
    required UserIntentsStore userIntentsStore,
  }) : _locationsStore = locationsStore,
       _recentLocationsStore = recentLocationsStore,
       _userIntentsStore = userIntentsStore;

  final LocationsStore _locationsStore;
  final RecentLocationsStore _recentLocationsStore;
  final UserIntentsStore _userIntentsStore;

  // ==================== Computed Properties ====================

  @computed
  VPNLocation? get potentialLocation {
    final recent = _recentLocationsStore.future.value?.firstOrNull;
    if (recent != null) {
      return recent;
    }

    final allLocations = [
      ...?_locationsStore.dcLocationsFuture.value?.allLocations,
      ...?_locationsStore.residentialLocationsFuture.value?.allLocations,
    ];

    return allLocations.isNotEmpty ? VPNLocation.closest : null;
  }

  // ==================== Decision Logic ====================

  ConnectionAction determineToggleAction({
    required VpnConnectionStatus currentStatus,
    required VPNLocation? currentLocation,
    required bool isRefreshIP,
    VPNLocation? requestedLocation,
    UserIntent? requestedIntent,
    String? requestedTargetIp,
    String? currentIp,
  }) {
    // If not connected, always connect
    if (currentStatus != VpnConnectionStatus.connected) {
      return ConnectionAction.connect;
    }

    if (isRefreshIP) {
      return ConnectionAction.refreshIP;
    }

    // A targeted (favorite IP) request is decided by the IP, not the
    // location — two favorites can share a city: tapping the connected one
    // toggles a disconnect, any other target switches.
    if (requestedTargetIp != null) {
      return requestedTargetIp == currentIp
          ? ConnectionAction.disconnect
          : ConnectionAction.reconnect;
    }

    // If connected and no location/intent specified, disconnect
    if (requestedLocation == null && requestedIntent == null) {
      return ConnectionAction.disconnect;
    }

    final currentIntent = _userIntentsStore.userIntent;

    // Tapping the connected location, or the country (same IP type) it belongs
    // to, disconnects — regardless of whether the user picked a country or a
    // city. Tapping a different city, or a different IP type, switches instead.
    if (requestedLocation != null &&
        currentLocation != null &&
        (requestedLocation == currentLocation ||
            (requestedLocation.isCountry &&
                requestedLocation.ipType == currentLocation.ipType &&
                requestedLocation.countryCode == currentLocation.countryCode))) {
      return ConnectionAction.disconnect;
    }

    // If same intent requested, disconnect
    if (requestedIntent != null && requestedIntent == currentIntent) {
      return ConnectionAction.disconnect;
    }

    // Different location/intent requested, reconnect
    return ConnectionAction.reconnect;
  }

  VPNLocation? determineConnectingLocation({
    VPNLocation? requestedLocation,
    VPNLocation? currentLocation,
    bool isRefreshIP = false,
    UserIntent? intent,
  }) {
    if (requestedLocation != null) {
      return requestedLocation;
    }
    if (isRefreshIP) {
      return currentLocation;
    }
    if (intent != null) {
      return null;
    }
    return potentialLocation;
  }

  bool shouldResolveClosestLocation(VPNLocation? location) => location?.ipType == IPType.closest;
}
