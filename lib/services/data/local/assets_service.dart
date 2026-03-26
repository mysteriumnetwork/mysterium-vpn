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
      for (final entry in json.entries)
        entry.key: _parseLatLng(entry.value as Map<String, dynamic>),
    };
  }
}

LatLng _parseLatLng(Map<String, dynamic> value) =>
    LatLng((value['latitude'] as num).toDouble(), (value['longitude'] as num).toDouble());
