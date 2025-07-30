import 'package:latlong2/latlong.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/services/data/local/assets_service.dart';
import 'package:mysterium_vpn/services/data/network/nominatim_service.dart';
import 'package:talker/talker.dart';

part 'latlng_store.g.dart';

// ignore: library_private_types_in_public_api
class LatLngStore = _LatLngStore with _$LatLngStore;

abstract class _LatLngStore with Store {
  _LatLngStore(
    this._assetsService,
    this._nominatimService,
    this._logger,
  );

  final AssetsService _assetsService;
  final NominatimService _nominatimService;
  final Talker _logger;

  DateTime? _lastFetchAt;

  @readonly
  late ObservableFuture<Map<String, LatLng>> _countryCoordinatesFuture =
      ObservableFuture(_assetsService.getCoordinates());

  @readonly
  late ObservableFuture<Map<String, LatLng>> _cityCoordinatesFuture =
      ObservableFuture.value(_nominatimService.findCachedCoordinates());

  @action
  LatLng? coordinatesFor(String locationId) =>
      _countryCoordinatesFuture.value?[locationId.toUpperCase()] ??
      _cityCoordinatesFuture.value?[locationId];

  @action
  Future<void> refreshIfNeeded(Iterable<String> locations) async {
    if (locations.isEmpty) {
      return;
    }
    await Future.wait([_countryCoordinatesFuture, _cityCoordinatesFuture]);

    final queryable = locations.where((it) => coordinatesFor(it) == null).toSet();

    for (final location in queryable) {
      final sinceLastFetch = _lastFetchAt?.difference(DateTime.now()).abs();
      if (sinceLastFetch != null && sinceLastFetch < const Duration(seconds: 1)) {
        await Future.delayed(const Duration(seconds: 1) - sinceLastFetch);
      }

      _cityCoordinatesFuture = _cityCoordinatesFuture.replace(_fetchLocationCoordinates(location));
      await _cityCoordinatesFuture;
    }
  }

  Future<Map<String, LatLng>> _fetchLocationCoordinates(String location) async {
    final current = _cityCoordinatesFuture.value ?? <String, LatLng>{};
    try {
      final result = await _nominatimService.findCoordinatesFor(location);
      _lastFetchAt = DateTime.now();
      if (result == null) {
        return current;
      }
      return {
        ...current,
        location: result,
      };
    } catch (e, stack) {
      _logger.handle(e, stack);
    }

    return current;
  }
}
