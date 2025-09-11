import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';

class AssetsService {
  const AssetsService();

  Future<Map<String, LatLng>> getCoordinates() async {
    final raw = await rootBundle.loadString(Asset.data.countriesLatlng);
    final json = jsonDecode(raw) as Map<String, dynamic>;

    return {
      for (final entry in json.entries) entry.key: _parseLatLng(entry.value),
    };
  }
}

LatLng _parseLatLng(value) {
  final json = value as Map;
  return LatLng(
    json['latitude'] as double,
    json['longitude'] as double,
  );
}
