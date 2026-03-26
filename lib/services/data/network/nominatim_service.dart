import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:mysterium_vpn/services/services.dart';

class NominatimService {
  const NominatimService(this._db, this._dio);

  final LocalDBService _db;
  final Dio _dio;

  Map<String, LatLng> findCachedCoordinates() => _db.getAllCoordinates();

  Future<LatLng?> findCoordinatesFor(String query) async {
    final cached = _db.getCoordinates(query);
    if (cached != null) {
      return cached;
    }

    final result = await _fetchCoordinatesFor(query);
    if (result == null) {
      return null;
    }

    await _db.putCoordinates(query, result);
    return result;
  }

  Future<LatLng?> _fetchCoordinatesFor(String query) async {
    final response = await _dio.get(
      'search',
      queryParameters: {'q': query, 'format': 'jsonv2', 'addressdetails': 0, 'limit': 1},
    );

    final payload = response.data;

    if (payload is! List || payload.isEmpty) {
      return null;
    }

    final first = payload.first;
    if (first is! Map<String, dynamic>) {
      return null;
    }

    final lat = first['lat'] as String?;
    final lon = first['lon'] as String?;

    if (lat == null || lon == null) {
      return null;
    }

    final latValue = double.tryParse(lat);
    final lonValue = double.tryParse(lon);

    if (latValue == null || lonValue == null) {
      return null;
    }

    return LatLng(latValue, lonValue);
  }
}
