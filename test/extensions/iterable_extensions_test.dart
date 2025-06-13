import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/extensions/list.dart';

void main() {
  group('SetExtensions.toggle', () {
    test('adds value when not in set', () {
      final set = <String>{'a', 'b'};
      final result = set.toggle('c');
      expect(result, contains('c'));
      expect(result.length, equals(3));
      expect(set, isNot(same(result))); // new instance
    });

    test('removes value when already in set', () {
      final set = <String>{'a', 'b'};
      final result = set.toggle('a');
      expect(result, isNot(contains('a')));
      expect(result.length, equals(1));
      expect(set, isNot(same(result))); // new instance
    });

    test('original set is not mutated', () {
      final set = <String>{'a', 'b'}..toggle('c');
      expect(set, equals({'a', 'b'}));
    });
  });
}
