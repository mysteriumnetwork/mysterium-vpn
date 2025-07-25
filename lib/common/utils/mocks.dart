import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/location.dart';

sealed class Mocks {
  static const locationResidentialUS = VPNLocation(
    id: 'US',
    ipType: IPType.residential,
    translations: {'en': 'United States'},
  );

  static const locationResidentialGB = VPNLocation(
    id: 'GB',
    ipType: IPType.residential,
    translations: {'en': 'United Kingdom'},
  );

  static const locationResidentialDE = VPNLocation(
    id: 'DE',
    ipType: IPType.residential,
    translations: {'en': 'Germany'},
  );

  static const locationResidentialNL = VPNLocation(
    id: 'NL',
    ipType: IPType.residential,
    translations: {'en': 'Netherlands'},
  );

  static const locationDatacenterUS = VPNLocation(
    id: 'US',
    ipType: IPType.datacenter,
    translations: {'en': 'United States'},
  );

  static const locationDatacenterGB = VPNLocation(
    id: 'GB',
    ipType: IPType.datacenter,
    translations: {'en': 'United Kingdom'},
  );

  static const locationDatacenterDE = VPNLocation(
    id: 'DE',
    ipType: IPType.datacenter,
    translations: {'en': 'Germany'},
  );

  static const locationDatacenterNL = VPNLocation(
    id: 'NL',
    ipType: IPType.datacenter,
    translations: {'en': 'Netherlands'},
  );
}
