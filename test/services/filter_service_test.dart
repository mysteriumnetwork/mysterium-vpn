import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/services/data/filter_service.dart';

void main() {
  final filterService = FilterService();

  group('FilterService', () {
    test('returns all locations when keyword is null', () {
      final locations = [const VPNLocation(code: 'US'), const VPNLocation(code: 'DE')];
      final result = filterService.filterLocations(locations);
      expect(result, locations);
    });

    test('returns all locations when keyword is empty', () {
      final locations = [const VPNLocation(code: 'US'), const VPNLocation(code: 'DE')];
      final result = filterService.filterLocations(locations, keyword: '');
      expect(result, locations);
    });

    test('filters locations by keyword', () {
      final locations = [const VPNLocation(code: 'US'), const VPNLocation(code: 'DE')];
      final result = filterService.filterLocations(locations, keyword: 'us');
      expect(result, [const VPNLocation(code: 'US')]);
    });

    test('filters locations by keyword case insensitive', () {
      final locations = [const VPNLocation(code: 'US'), const VPNLocation(code: 'DE')];
      final result = filterService.filterLocations(locations, keyword: 'Us');
      expect(result, [const VPNLocation(code: 'US')]);
    });

    test('returns empty list when no locations match keyword', () {
      final locations = [const VPNLocation(code: 'US'), const VPNLocation(code: 'DE')];
      final result = filterService.filterLocations(locations, keyword: 'FR');
      expect(result, []);
    });

    test('filters locations by translated code', () {
      final locations = [const VPNLocation(code: 'US'), const VPNLocation(code: 'DE')];
      final result = filterService.filterLocations(locations, keyword: 'de');
      expect(result, [const VPNLocation(code: 'DE')]);
    });
  });
}
