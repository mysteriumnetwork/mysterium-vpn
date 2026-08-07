import 'dart:convert';

import 'package:hive_ce/hive.dart';
import 'package:mysterium_vpn/models/models.dart';

class FavoriteIpAdapter extends TypeAdapter<FavoriteIp> {
  const FavoriteIpAdapter({required this.typeId});

  @override
  final int typeId;

  @override
  FavoriteIp read(BinaryReader reader) =>
      FavoriteIp.fromJson(jsonDecode(reader.readString()) as Map<String, dynamic>);

  @override
  void write(BinaryWriter writer, FavoriteIp obj) {
    writer.writeString(jsonEncode(obj.toJson()));
  }
}
