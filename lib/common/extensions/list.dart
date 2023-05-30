import 'dart:math';

extension RandomListItem<T> on List<T> {
  T randomItem() => this[Random().nextInt(length)];
}
