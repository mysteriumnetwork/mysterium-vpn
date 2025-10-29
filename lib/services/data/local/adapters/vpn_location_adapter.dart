import 'dart:convert';

import 'package:hive_ce/hive.dart';
import 'package:mysterium_vpn/models/location.dart';

class VPNLocationAdapter extends TypeAdapter<VPNLocation> {
  const VPNLocationAdapter({required this.typeId});

  @override
  final int typeId;

  @override
  VPNLocation read(BinaryReader reader) {
    final raw = reader.readString();
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return VPNLocation.fromJson(json);
    } catch (e) {
      return VPNLocation.fromCode(raw);
    }
  }

  @override
  void write(BinaryWriter writer, VPNLocation obj) {
    writer.writeString(jsonEncode(obj.toJson()));
  }
}
