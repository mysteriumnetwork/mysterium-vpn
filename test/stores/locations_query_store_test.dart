import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';

import 'locations_query_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SharedPreferenceService>(),
  MockSpec<AnalyticsStore>(),
  MockSpec<LocaleStore>(),
])
void main() {
  late MockSharedPreferenceService prefs;
  late MockAnalyticsStore analytics;
  late MockLocaleStore localeStore;

  setUp(() {
    prefs = MockSharedPreferenceService();
    analytics = MockAnalyticsStore();
    localeStore = MockLocaleStore();

    when(prefs.getIPType()).thenReturn(IPType.residential);
    when(prefs.setIPType(any)).thenAnswer((_) async => true);
  });

  LocationsQueryStore newStore() => LocationsQueryStore(prefs, analytics, localeStore);

  test('seeds ipType from SharedPreferenceService', () {
    when(prefs.getIPType()).thenReturn(IPType.datacenter);
    final store = newStore();
    expect(store.ipType, IPType.datacenter);
  });

  test('falls back to residential when prefs are empty', () {
    when(prefs.getIPType()).thenReturn(null);
    final store = newStore();
    expect(store.ipType, IPType.residential);
  });

  test('setSearch updates _search and emits a search analytics event', () async {
    final store = newStore()..setSearch('uk', debounce: Duration.zero);
    await Future<void>.delayed(Duration.zero);

    expect(store.search, 'uk');
    verify(analytics.setSearchEvent('uk')).called(1);
  });

  test('searchTrimmed strips surrounding whitespace', () async {
    final store = newStore()..setSearch('  hello  ', debounce: Duration.zero);
    await Future<void>.delayed(Duration.zero);

    expect(store.searchTrimmed, 'hello');
  });

  test('setIPType writes prefs but does NOT log a tab click', () async {
    final store = newStore();

    await store.setIPType(IPType.datacenter);

    expect(store.ipType, IPType.datacenter);
    verify(prefs.setIPType(IPType.datacenter)).called(1);
    verifyNever(analytics.logTabChange(any));
  });

  test('dispose tears down debouncer + reaction', () async {
    newStore().dispose();
  });
}
