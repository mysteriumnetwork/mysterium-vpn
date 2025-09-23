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

  group('IterableExtensions.batch', () {
    test('batches items correctly', () {
      final items = List.generate(10, (index) => index);
      final batches = items.batch(3);
      expect(batches, hasLength(4));
      expect(batches[0], equals([0, 1, 2]));
      expect(batches[1], equals([3, 4, 5]));
      expect(batches[2], equals([6, 7, 8]));
      expect(batches[3], equals([9]));
    });

    test('throws error for zero batch size', () {
      final items = List.generate(5, (index) => index);
      expect(() => items.batch(0), throwsArgumentError);
    });

    test('throws error for negative batch size', () {
      final items = List.generate(5, (index) => index);
      expect(() => items.batch(-1), throwsArgumentError);
    });
  });

  group('IterableExtensions.flattenBy', () {
    test('flattens nested structures', () {
      final items = [
        {'id': 1, 'children': <Map<String, Object>>[]},
        {
          'id': 2,
          'children': [
            {'id': 3, 'children': <Map<String, Object>>[]},
          ],
        },
        {'id': 4, 'children': <Map<String, Object>>[]},
      ];
      final flattened = items.flattenBy((item) => item['children']! as List<Map<String, Object>>);
      expect(flattened.map((e) => e['id']).toList(), equals([1, 2, 3, 4]));
    });

    test('handles empty children', () {
      final items = [
        {'id': 1, 'children': <Map<String, Object>>[]},
        {'id': 2, 'children': <Map<String, Object>>[]},
      ];
      final flattened = items.flattenBy((item) => item['children']! as List<Map<String, Object>>);
      expect(flattened.map((e) => e['id']).toList(), equals([1, 2]));
    });
  });

  group('IterableExtensions.intersect', () {
    test('returns common elements in order of the first iterable', () {
      final first = [1, 2, 3, 4];
      final second = [3, 4, 5, 6];
      final result = first.intersect(second).toList();
      expect(result, [3, 4]);
    });

    test('returns an empty iterable when there are no common elements', () {
      final first = [1, 2, 3];
      final second = [4, 5, 6];
      final result = first.intersect(second).toList();
      expect(result, []);
    });

    test('handles duplicates in the first iterable', () {
      final first = [1, 2, 2, 3];
      final second = [2, 3];
      final result = first.intersect(second).toList();
      expect(result, [2, 2, 3]);
    });

    test('handles duplicates in the second iterable', () {
      final first = [1, 2, 3];
      final second = [2, 2, 3];
      final result = first.intersect(second).toList();
      expect(result, [2, 3]);
    });

    test('returns an empty iterable when the first iterable is empty', () {
      final first = <int>[];
      final second = [1, 2, 3];
      final result = first.intersect(second).toList();
      expect(result, []);
    });

    test('returns an empty iterable when the second iterable is empty', () {
      final first = [1, 2, 3];
      final second = <int>[];
      final result = first.intersect(second).toList();
      expect(result, []);
    });

    test('returns an empty iterable when both iterables are empty', () {
      final first = <int>[];
      final second = <int>[];
      final result = first.intersect(second).toList();
      expect(result, []);
    });

    test('handles iterables with different types', () {
      final first = ['a', 'b', 'c'];
      final second = ['b', 'c', 'd'];
      final result = first.intersect(second).toList();
      expect(result, ['b', 'c']);
    });
  });
}
