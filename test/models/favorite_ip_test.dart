import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/models/models.dart';

void main() {
  group('FavoriteIp', () {
    final ip = FavoriteIp(
      ip: '195.285.15.404',
      countryCode: 'al',
      countryName: 'Albania',
      city: 'Tirana',
      locationId: 'tirana',
      ipType: IPType.residential,
      savedAt: DateTime.utc(2026, 8, 5),
    );

    test('json roundtrip preserves all fields', () {
      final restored = FavoriteIp.fromJson(ip.toJson());
      expect(restored.ip, '195.285.15.404');
      expect(restored.countryCode, 'al');
      expect(restored.countryName, 'Albania');
      expect(restored.city, 'Tirana');
      expect(restored.locationId, 'tirana');
      expect(restored.ipType, IPType.residential);
      expect(restored.savedAt, DateTime.utc(2026, 8, 5));
    });

    test('countryName and locationId default for entries persisted before the fields', () {
      final json = ip.toJson()
        ..remove('countryName')
        ..remove('locationId');
      final restored = FavoriteIp.fromJson(json);
      expect(restored.countryName, isEmpty);
      expect(restored.locationId, isEmpty);
    });

    test('a city pick connects to that city within its country', () {
      expect(ip.isCountryPick, isFalse);
      expect(ip.location.id, 'tirana');
      expect(ip.location.countryCode, 'al');
      expect(ip.location.isCountry, isFalse);
    });

    test('a country pick (or a legacy entry) connects country-level', () {
      final country = ip.copyWith(locationId: 'al');
      expect(country.isCountryPick, isTrue);
      expect(country.location.id, 'al');
      expect(country.location.isCountry, isTrue);

      final legacy = ip.copyWith(locationId: '');
      expect(legacy.isCountryPick, isTrue);
      expect(legacy.location.id, 'al');
    });

    test('ipType serializes by name so datacenter survives roundtrip', () {
      final dc = ip.copyWith(ipType: IPType.datacenter);
      expect(FavoriteIp.fromJson(dc.toJson()).ipType, IPType.datacenter);
    });
  });
}
