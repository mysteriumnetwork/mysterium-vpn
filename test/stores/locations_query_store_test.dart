import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/repositories/repositories.dart';
import 'package:mysterium_vpn/stores/stores.dart';

import 'locations_query_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AppSettingsRepository>(),
  MockSpec<AnalyticsStore>(),
  MockSpec<LocaleStore>(),
])
void main() {
  late MockAppSettingsRepository prefs;
  late MockAnalyticsStore analytics;
  late MockLocaleStore localeStore;

  setUp(() {
    prefs = MockAppSettingsRepository();
    analytics = MockAnalyticsStore();
    localeStore = MockLocaleStore();

    when(prefs.ipType()).thenReturn(IPType.residential);
    when(prefs.setIpType(any)).thenAnswer((_) async => true);
  });

  LocationsQueryStore newStore() => LocationsQueryStore(prefs, analytics, localeStore);

  test('seeds ipType from SharedPreferenceService', () {
    when(prefs.ipType()).thenReturn(IPType.datacenter);
    final store = newStore();
    expect(store.ipType, IPType.datacenter);
  });

  test('falls back to residential when prefs are empty', () {
    when(prefs.ipType()).thenReturn(null);
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
    verify(prefs.setIpType(IPType.datacenter)).called(1);
    verifyNever(analytics.logTabChange(any));
  });

  test('dispose tears down debouncer + reaction', () async {
    newStore().dispose();
  });

  group('favourite tab', () {
    test('tab reflects ipType when favourites are not selected', () {
      when(prefs.ipType()).thenReturn(IPType.datacenter);
      final store = newStore();

      expect(store.tab, LocationsTab.datacenter);
    });

    test('selectTab(favorite) switches the tab without touching ipType', () {
      final store = newStore()..selectTab(LocationsTab.favorite);

      expect(store.tab, LocationsTab.favorite);
      expect(store.ipType, IPType.residential);
      verifyNever(prefs.setIpType(any));
    });

    test('selectTab of an IP-type tab deselects favourites', () async {
      final store = newStore()..selectTab(LocationsTab.favorite);

      await store.selectTab(LocationsTab.datacenter);

      expect(store.tab, LocationsTab.datacenter);
      expect(store.ipType, IPType.datacenter);
    });

    test('deselectFavoritesTab drops the selection (e.g. on logout)', () {
      final store = newStore()
        ..selectTab(LocationsTab.favorite)
        ..deselectFavoritesTab();

      expect(store.tab, LocationsTab.residential);
    });

    test('syncIPType updates the type without stealing the favourite selection', () async {
      final store = newStore()..selectTab(LocationsTab.favorite);

      await store.syncIPType(IPType.datacenter);

      expect(store.tab, LocationsTab.favorite);
      expect(store.ipType, IPType.datacenter);
      verify(prefs.setIpType(IPType.datacenter)).called(1);
    });
  });
}
