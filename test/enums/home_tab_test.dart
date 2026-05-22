import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';

void main() {
  group('HomeTab.path', () {
    test('each tab has a distinct path', () {
      final paths = HomeTab.values.map((t) => t.path).toSet();
      expect(paths.length, HomeTab.values.length);
    });

    test('paths start with a leading slash', () {
      for (final tab in HomeTab.values) {
        expect(tab.path, startsWith('/'));
      }
    });

    test('round-trips through fromPath', () {
      for (final tab in HomeTab.values) {
        expect(HomeTab.fromPath(tab.path), tab);
      }
    });
  });

  group('HomeTab.fromPath', () {
    test('maps /map to HomeTab.map', () {
      expect(HomeTab.fromPath('/map'), HomeTab.map);
    });

    test('maps /locations to HomeTab.locations', () {
      expect(HomeTab.fromPath('/locations'), HomeTab.locations);
    });

    test('maps /products to HomeTab.products', () {
      expect(HomeTab.fromPath('/products'), HomeTab.products);
    });

    test('maps /settings to HomeTab.settings', () {
      expect(HomeTab.fromPath('/settings'), HomeTab.settings);
    });

    test('returns null for an unknown path', () {
      expect(HomeTab.fromPath('/unknown'), isNull);
      expect(HomeTab.fromPath(''), isNull);
      expect(HomeTab.fromPath('/'), isNull);
    });
  });
}
