import 'package:latlong2/latlong.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/services/data/local/assets_service.dart';
import 'package:mysterium_vpn/stores/remote_config/remote_config_store.dart';

part 'latlng_store.g.dart';

// ignore: library_private_types_in_public_api
class LatLngStore = _LatLngStore with _$LatLngStore;

abstract class _LatLngStore with Store {
  _LatLngStore(
    this._assetsService,
    this._remoteConfigStore,
  );

  final AssetsService _assetsService;
  final RemoteConfigStore _remoteConfigStore;

  @readonly
  late ObservableFuture<Map<String, LatLng>> _countryCoordinatesFuture =
      ObservableFuture(_assetsService.getCoordinates());

  @action
  LatLng? coordinatesForCountry(String countryCode) =>
      _countryCoordinatesFuture.value?[countryCode.toUpperCase()];

  @action
  LatLng? coordinatesFor(VPNLocation location) {
    final supportsCities = _remoteConfigStore.showCitiesAndStates &&
        _remoteConfigStore.countriesWithCitiesOnMap.contains(location.countryCode.toUpperCase()) &&
        (location.children?.isNotEmpty ?? false);

    // we don't want to show "country coordinates" if it already has its cities on the map
    if (location.isCountry && !supportsCities) {
      return coordinatesForCountry(location.countryCode);
    }

    // if location is a city, we return its coordinates (if available)
    if (supportsCities) {
      return location.coordinates;
    }

    return null;
  }
}
