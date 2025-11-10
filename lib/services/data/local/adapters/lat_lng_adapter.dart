import 'package:hive_ce/hive.dart';
import 'package:latlong2/latlong.dart';

class LatLngAdapter extends TypeAdapter<LatLng> {
  const LatLngAdapter({required this.typeId});

  @override
  final int typeId;

  @override
  LatLng read(BinaryReader reader) {
    final lat = reader.readDouble();
    final lng = reader.readDouble();
    return LatLng(lat, lng);
  }

  @override
  void write(BinaryWriter writer, LatLng obj) {
    writer
      ..writeDouble(obj.latitude)
      ..writeDouble(obj.longitude);
  }
}
