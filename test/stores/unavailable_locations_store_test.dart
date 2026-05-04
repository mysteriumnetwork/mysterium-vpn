import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/stores/stores.dart';

import 'unavailable_locations_store_test.mocks.dart';

@GenerateNiceMocks([MockSpec<LocationsStore>()])
void main() {
  late MockLocationsStore locationsStore;

  const us = VPNLocation(id: 'us', ipType: IPType.residential, countryCode: 'US', translations: {});
  const de = VPNLocation(id: 'de', ipType: IPType.residential, countryCode: 'DE', translations: {});

  setUp(() {
    locationsStore = MockLocationsStore();
    final empty = VPNLocations();
    when(locationsStore.dcLocationsFuture).thenAnswer((_) => ObservableFuture.value(empty));
    when(
      locationsStore.residentialLocationsFuture,
    ).thenAnswer((_) => ObservableFuture.value(empty));
  });

  test('toggleAvailability(availability: false) marks a location unavailable', () {
    final store = UnavailableLocationsStore(locationsStore)
      ..toggleAvailability(us, availability: false);

    expect(store.unavailableLocations, contains(us));
  });

  test('toggleAvailability(availability: true) restores availability', () {
    final store = UnavailableLocationsStore(locationsStore)
      ..toggleAvailability(us, availability: false)
      ..toggleAvailability(us, availability: true);

    expect(store.unavailableLocations, isNot(contains(us)));
  });

  test('toggleAvailability(no arg) is a no-op (current behaviour)', () {
    // The default branch resolves availability to the opposite of "is in
    // unavailable set" — which leaves state unchanged in both cases.
    final store = UnavailableLocationsStore(locationsStore)..toggleAvailability(us);

    expect(store.unavailableLocations, isEmpty);
  });

  test('toggleAvailability honours an explicit availability override', () {
    final store = UnavailableLocationsStore(locationsStore)
      ..toggleAvailability(us, availability: false)
      ..toggleAvailability(de, availability: false);

    expect(store.unavailableLocations, {us, de});

    store.toggleAvailability(us, availability: true);
    expect(store.unavailableLocations, {de});
  });

  test('clear empties the unavailable set', () {
    final store = UnavailableLocationsStore(locationsStore)
      ..toggleAvailability(us, availability: false)
      ..toggleAvailability(de, availability: false)
      ..clear();

    expect(store.unavailableLocations, isEmpty);
  });

  test('dispose tears down the reaction', () {
    UnavailableLocationsStore(locationsStore).dispose();
  });
}
