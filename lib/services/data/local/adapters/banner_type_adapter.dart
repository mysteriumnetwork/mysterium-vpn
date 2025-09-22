import 'package:hive_ce/hive.dart';
import 'package:mysterium_vpn/common/enums/banner_type.dart';

class BannerTypeAdapter extends TypeAdapter<BannerType> {
  const BannerTypeAdapter({required this.typeId});

  @override
  final int typeId;

  @override
  BannerType read(BinaryReader reader) {
    final raw = reader.readString();
    return BannerType.values.firstWhere((it) => it.name == raw);
  }

  @override
  void write(BinaryWriter writer, BannerType obj) {
    writer.writeString(obj.name);
  }
}
