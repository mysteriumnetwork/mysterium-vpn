import 'dart:math';

extension RandomListItem<T> on List<T> {
  T randomItem() => this[Random().nextInt(length)];
}

extension IterableExtensions<T> on Iterable<T> {
  Iterable<T> separateWith(T value) sync* {
    for (var i = 0; i < length; i++) {
      yield elementAt(i);
      if (i < length - 1) {
        yield value;
      }
    }
  }

  Iterable<T> distinctBy<R>(R Function(T) selector) sync* {
    final seen = <R>{};
    for (final element in this) {
      final key = selector(element);
      if (seen.add(key)) {
        yield element;
      }
    }
  }

  Iterable<List<T>> _batch(int size) sync* {
    final iterator = this.iterator;
    while (iterator.moveNext()) {
      final batch = <T>[iterator.current];
      for (var i = 1; i < size && iterator.moveNext(); i++) {
        batch.add(iterator.current);
      }
      yield batch;
    }
  }

  List<List<T>> batch(int size) {
    if (size <= 0) {
      throw ArgumentError('Batch size must be greater than zero');
    }
    return _batch(size).toList();
  }

  Iterable<T> flattenBy(Iterable<T> Function(T) childrenExtractor) sync* {
    for (final element in this) {
      yield element;
      final children = childrenExtractor(element);
      if (children.isNotEmpty) {
        yield* children.flattenBy(childrenExtractor);
      }
    }
  }
}

extension SetExtensions<T> on Set<T> {
  Set<T> toggle(T value) {
    final newSet = {...this};
    if (!newSet.add(value)) {
      newSet.remove(value);
    }
    return newSet;
  }
}
