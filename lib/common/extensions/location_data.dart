import 'package:mysterium_vpn/models/models.dart';

typedef LocationData = ({String country, String city});

extension IPInfoExtensions on IPInfo? {
  ({String country, String city}) toLocationData() => (
        country: this?.country ?? 'null',
        city: this?.city ?? 'null',
      );
}
