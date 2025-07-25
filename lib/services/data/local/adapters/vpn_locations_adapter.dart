import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:mysterium_vpn/models/location.dart';

class VpnLocationsAdapter extends TypeAdapter<VPNLocations> {
  VpnLocationsAdapter({required this.typeId});

  @override
  final int typeId;

  @override
  VPNLocations read(BinaryReader reader) {
    final raw = reader.readString();
    final json = jsonDecode(raw) as Map<String, dynamic>;
    try {
      return VPNLocations.fromJson(json);
    } catch (e) {
      return VPNLocations.fromLegacyJson(json);
    }
  }

  @override
  void write(BinaryWriter writer, VPNLocations obj) {
    writer.writeString(jsonEncode(obj.toJson()));
  }
}
