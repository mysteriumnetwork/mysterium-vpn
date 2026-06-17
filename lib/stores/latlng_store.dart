import 'package:latlong2/latlong.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/services.dart';

part 'latlng_store.g.dart';

// ignore: library_private_types_in_public_api
class LatLngStore = _LatLngStore with _$LatLngStore;

abstract class _LatLngStore with Store {
  _LatLngStore(this._assetsService);

  final AssetsService _assetsService;

  @readonly
  late ObservableFuture<Map<String, LatLng>> _countryCoordinatesFuture = ObservableFuture(
    _assetsService.getCoordinates(),
  );

  @action
  LatLng? coordinatesForCountry(String countryCode) =>
      _countryCoordinatesFuture.value?[countryCode.toUpperCase()];

  @action
  LatLng? coordinatesForCity(VPNLocation location) {
    if (location.isCountry) {
      return null;
    }

    return location.coordinates;
  }
}
