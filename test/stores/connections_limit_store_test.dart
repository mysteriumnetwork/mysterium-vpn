import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/stores/stores.dart';

void main() {
  test('connectionLimitReached defaults to false and is mutable', () {
    final store = ConnectionsLimitStore();

    expect(store.connectionLimitReached, isFalse);

    store.connectionLimitReached = true;
    expect(store.connectionLimitReached, isTrue);
  });
}
