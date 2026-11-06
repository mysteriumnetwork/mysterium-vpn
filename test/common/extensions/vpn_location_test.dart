import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
import 'package:mysterium_vpn/models/models.dart';

void main() {
  const texas = VPNLocation(
    id: 'texas',
    ipType: IPType.datacenter,
    translations: {},
    countryCode: 'US',
  );
  const us = VPNLocation(id: 'US', ipType: IPType.datacenter, translations: {}, countryCode: 'US');

  group('covers', () {
    test('a location covers itself', () {
      expect(texas.covers(texas), isTrue);
    });

    test('a country covers a city inside it', () {
      // The recents chip and the map tap guard both lean on this.
      expect(us.covers(texas), isTrue);
    });

    test('a city does not cover its country', () {
      expect(texas.covers(us), isFalse);
    });

    test('coverage does not cross IP types', () {
      const residentialUs = VPNLocation(
        id: 'US',
        ipType: IPType.residential,
        translations: {},
        countryCode: 'US',
      );
      expect(residentialUs.covers(texas), isFalse);
    });

    test('a country does not cover another country', () {
      const france = VPNLocation(
        id: 'FR',
        ipType: IPType.datacenter,
        translations: {},
        countryCode: 'FR',
      );
      expect(france.covers(texas), isFalse);
    });

    test('nothing covers null', () {
      expect(us.covers(null), isFalse);
    });
  });
}
