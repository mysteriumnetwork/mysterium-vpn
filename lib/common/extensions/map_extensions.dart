import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

extension MapCameraExtensions on MapCamera {
  Map<String, dynamic> toMap() => {
        'center': center.toShortString(),
        'zoom': zoom.toStringAsFixed(2),
        'bounds': visibleBounds.toShortString(),
      };
}

extension LatLngExtensions on LatLng {
  String toShortString() => '${latitude.toStringAsFixed(5)},${longitude.toStringAsFixed(5)}';
}

extension LatLngBoundsExtension on LatLngBounds {
  String toShortString() => 'NE: ${northEast.toShortString()}, SW: ${southWest.toShortString()}';
}
