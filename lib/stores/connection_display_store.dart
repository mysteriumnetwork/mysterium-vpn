import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:vpn_api/vpn_api.dart';

part 'connection_display_store.g.dart';

// ignore: library_private_types_in_public_api
class ConnectionDisplayStore = _ConnectionDisplayStore with _$ConnectionDisplayStore;

abstract class _ConnectionDisplayStore with Store {
  _ConnectionDisplayStore(
    this._vpnStore,
    this._locationsStore,
    this._selectedLocationStore,
    this._unavailableLocationsStore,
  );

  final VpnStore _vpnStore;
  final LocationsStore _locationsStore;
  final SelectedLocationStore _selectedLocationStore;
  final UnavailableLocationsStore _unavailableLocationsStore;

  /// The location to display in the UI
  @computed
  VPNLocation? get displayLocation {
    final selectedLocation = _selectedLocationStore.value;
    final location = _vpnStore.location;
    final connectingLocation = _vpnStore.connectingLocation;
    final potentialLocation = _vpnStore.potentialLocation;

    final result = selectedLocation ?? location ?? connectingLocation ?? potentialLocation;

    if (result == VPNLocation.closest) {
      return null;
    }

    return result;
  }

  /// The parent location (country) of the current display location
  @computed
  VPNLocation? get parentLocation {
    if (displayLocation == null) {
      return null;
    }
    return _locationsStore.findParent(displayLocation!);
  }

  /// The actual target location to connect to.
  /// If selected location is unavailable, returns parent location (country).
  /// If parent is also unavailable, returns null (will use best location).
  @computed
  VPNLocation? get targetLocation {
    if (displayLocation == null) {
      return null;
    }

    return _unavailableLocationsStore.unavailableLocations.contains(displayLocation)
        ? parentLocation
        : displayLocation;
  }

  /// Whether the display location is available for connection
  @computed
  bool get isLocationAvailable => displayLocation != null && displayLocation == targetLocation;

  /// The connection IP from the current VPN connection
  @computed
  String? get connectionIP => _vpnStore.vpnConnection?.connectionIP;

  /// Whether the VPN store is currently loading
  @computed
  bool get isLoading => _vpnStore.isLoading;

  /// Whether currently connected
  @computed
  bool get isConnected => _vpnStore.isConnected;

  /// The user intent for connecting (null for normal connection, bestSpeed for closest server)
  @computed
  UserIntent? get connectionIntent =>
      targetLocation == null && displayLocation != null ? UserIntent.bestSpeed : null;

  /// The current connection rating
  @computed
  RateConnectionRequestModeEnum? get connectionRated => _vpnStore.connectionRated;

  /// Whether the user has selected a location that differs from the currently
  /// connected one — i.e. a "switch" scenario.
  @computed
  bool get hasDifferentSelection {
    final selected = _selectedLocationStore.value;
    final connected = _vpnStore.location;
    if (!_vpnStore.isConnected || selected == null || connected == null) {
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
