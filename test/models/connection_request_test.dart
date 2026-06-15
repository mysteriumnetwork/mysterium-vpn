import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/models.dart';

VPNLocation _country(String code, {IPType ipType = IPType.datacenter}) =>
    VPNLocation(id: code, ipType: ipType, translations: const {}, countryCode: code);

VPNLocation _city(String id, String country, {IPType ipType = IPType.datacenter}) =>
    VPNLocation(id: id, ipType: ipType, translations: const {}, countryCode: country);

void main() {
  group('ConnectionRequest', () {
    const realIp = IPInfo(country: 'us', city: 'ny', ip: '1.1.1.1');

    test('country selection → city is null, country is the code', () {
      final r = ConnectionRequest(location: _country('fr'));
      expect(r.city, isNull);
      expect(r.country(realIp), 'fr');
    });

    test('city selection → city is the id, country is the country code', () {
      final r = ConnectionRequest(location: _city('paris', 'fr'));
      expect(r.city, 'paris');
      expect(r.country(realIp), 'fr');
    });

    test('nearest intent → city null, country from real IP', () {
      const r = ConnectionRequest(intent: UserIntent.nearestLocation);
      expect(r.city, isNull);
      expect(r.country(realIp), 'us');
    });

    test('no location and no intent → city and country null', () {
      const r = ConnectionRequest();
      expect(r.city, isNull);
      expect(r.country(realIp), isNull);
    });

    test('ipType: location ipType wins', () {
      final r = ConnectionRequest(location: _country('fr', ipType: IPType.residential));
      expect(r.ipType(IPType.datacenter), IPType.residential);
    });

    test('ipType: nearest intent falls back to provided fallback', () {
      const r = ConnectionRequest(intent: UserIntent.nearestLocation);
      expect(r.ipType(IPType.residential), IPType.residential);
    });

    test('ipType: non-nearest intent with no location → null (ignores fallback)', () {
      const r = ConnectionRequest(intent: UserIntent.bestSpeed);
      expect(r.ipType(IPType.datacenter), isNull);
    });

    test('requiresCluster mirrors the intent', () {
      expect(const ConnectionRequest(intent: UserIntent.bestSpeed).requiresCluster, isTrue);
      expect(const ConnectionRequest(intent: UserIntent.nearestLocation).requiresCluster, isFalse);
      expect(const ConnectionRequest().requiresCluster, isFalse);
    });
  });
}
