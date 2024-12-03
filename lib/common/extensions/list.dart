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
}
