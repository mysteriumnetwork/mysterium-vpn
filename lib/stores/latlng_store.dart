import 'package:latlong2/latlong.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/services/data/local/assets_service.dart';

part 'latlng_store.g.dart';

// ignore: library_private_types_in_public_api
class LatLngStore = _LatLngStore with _$LatLngStore;

abstract class _LatLngStore with Store {
  _LatLngStore(this._assetsService);

  final AssetsService _assetsService;

  @readonly
  late ObservableFuture<Map<String, LatLng>> _countryCoordinatesFuture =
      ObservableFuture(_assetsService.getCoordinates());

  @readonly
  late ObservableFuture<Map<String, LatLng>> _cityCoordinatesFuture = ObservableFuture.value({});

  @action
  LatLng? coordinatesFor(String locationId) =>
      _countryCoordinatesFuture.value?[locationId.toUpperCase()] ??
      _cityCoordinatesFuture.value?[locationId];
}
