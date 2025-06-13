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
