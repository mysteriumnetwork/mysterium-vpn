import 'package:json_annotation/json_annotation.dart';
import 'package:latlong2/latlong.dart';

class LatLngConverter extends JsonConverter<LatLng, Map<String, dynamic>> {
  const LatLngConverter();

  @override
  LatLng fromJson(Map<String, dynamic> json) =>
      LatLng((json['latitude'] as num).toDouble(), (json['longitude'] as num).toDouble());

  @override
  Map<String, dynamic> toJson(LatLng latLng) => {
    'latitude': latLng.latitude,
    'longitude': latLng.longitude,
  };
}
