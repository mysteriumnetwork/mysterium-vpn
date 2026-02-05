import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/services/services.dart';

void main() {
  final filterService = FilterService();
  const locale = 'en';

  group('FilterService', () {
    test('returns all locations when keyword is null', () {
      final locations = [Mocks.locationResidentialDE, Mocks.locationResidentialUS];
      final result = filterService.filterLocations(locations, locale: locale);
      expect(result, locations);
    });

    test('returns all locations when keyword is empty', () {
      final locations = [Mocks.locationResidentialDE, Mocks.locationResidentialUS];
      final result = filterService.filterLocations(locations, keyword: '', locale: locale);
      expect(result, locations);
    });

    test('filters locations by keyword', () {
      final locations = [Mocks.locationResidentialDE, Mocks.locationResidentialUS];
      final result = filterService.filterLocations(locations, keyword: 'us', locale: locale);
      expect(result, [Mocks.locationResidentialUS]);
    });

    test('filters locations by keyword case insensitive', () {
      final locations = [Mocks.locationResidentialDE, Mocks.locationResidentialUS];
      final result = filterService.filterLocations(locations, keyword: 'Us', locale: locale);
      expect(result, [Mocks.locationResidentialUS]);
    });

    test('returns empty list when no locations match keyword', () {
      final locations = [Mocks.locationResidentialDE, Mocks.locationResidentialUS];
      final result = filterService.filterLocations(locations, keyword: 'FR', locale: locale);
      expect(result, []);
    });

    test('filters locations by translated code', () {
      final locations = [Mocks.locationResidentialDE, Mocks.locationResidentialUS];
      final result = filterService.filterLocations(locations, keyword: 'de', locale: locale);
      expect(result, [Mocks.locationResidentialDE]);
    });
  });
}
