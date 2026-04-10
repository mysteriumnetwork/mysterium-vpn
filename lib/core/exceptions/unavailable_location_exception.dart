import 'package:mysterium_vpn/models/models.dart';

class UnavailableLocationException implements Exception {
  const UnavailableLocationException(this.location);

  final VPNLocation location;

  @override
  String toString() => 'UnavailableLocationException(location: ${location.id})';
}
