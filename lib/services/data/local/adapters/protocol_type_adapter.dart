import 'package:hive_ce/hive.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';

class ProtocolTypeAdapter extends TypeAdapter<ProtocolType> {
  const ProtocolTypeAdapter({required this.typeId});

  @override
  final int typeId;

  @override
  ProtocolType read(BinaryReader reader) {
    final raw = reader.readString();
    return ProtocolType.values.firstWhere((it) => it.name == raw);
  }

  @override
  void write(BinaryWriter writer, ProtocolType obj) {
    writer.writeString(obj.name);
  }
}
