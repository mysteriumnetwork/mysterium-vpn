import 'dart:convert';

import 'package:hive_ce/hive.dart';
import 'package:mysterium_vpn/models/location.dart';

class VpnLocationsAdapter extends TypeAdapter<VPNLocations> {
  const VpnLocationsAdapter({required this.typeId});

  @override
  final int typeId;

  @override
  VPNLocations read(BinaryReader reader) {
    final raw = reader.readString();
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return VPNLocations.fromJson(json);
  }

  @override
  void write(BinaryWriter writer, VPNLocations obj) {
    writer.writeString(jsonEncode(obj.toJson()));
  }
}
