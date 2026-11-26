import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/repositories/repositories.dart';
import 'package:mysterium_vpn/stores/stores.dart';

class _Settings extends Fake implements AppSettingsRepository {
  @override
  IPType ipType() => IPType.residential;

  @override
  Future<void> setIpType(IPType type) async {}
}

class _Analytics extends Fake implements AnalyticsStore {}

class _Locale extends Fake implements LocaleStore {
  @override
  Locale get currentLocale => const Locale('en');
}

void main() {
  late LocationsQueryStore query;
  late ProviderContainer container;
  late SelectedLocationStore selected;

  setUp(() {
    query = LocationsQueryStore(_Settings(), _Analytics(), _Locale());
    container = ProviderContainer(overrides: [locationsQueryStorePOD.overrideWithValue(query)]);
    selected = container.read(selectedLocationStorePOD);
  });

  tearDown(() {
    container.dispose();
    query.dispose();
  });

  VPNLocation location(IPType type) =>
      VPNLocation(id: 'berlin', countryCode: 'DE', ipType: type, translations: const {});

  for (final tab in [LocationsTab.datacenter, LocationsTab.residential]) {
    test('selecting $tab clears a pending selection of the other type', () async {
      final other = tab == LocationsTab.datacenter ? IPType.residential : IPType.datacenter;
      await query.selectTab(LocationsTab.fromIPType(other));
      selected.value = location(other);
      await query.selectTab(tab);
      expect(selected.value, isNull);
    });

    test('selecting $tab preserves a pending selection of the same type', () async {
      final target = location(tab.ipType!);
      selected.value = target;
      await query.selectTab(tab);
      expect(selected.value, same(target));
    });
  }

  test('opening Favourite preserves the explicitly selected location type', () async {
    final target = location(IPType.residential);
    selected.value = target;
    await query.selectTab(LocationsTab.favorite);
    expect(selected.value, same(target));
  });

  test('disposing the provider removes the tab-change reaction', () async {
    final target = location(IPType.residential);
    selected.value = target;
    container.dispose();
    await query.selectTab(LocationsTab.datacenter);
    expect(selected.value, same(target));
  });
}
