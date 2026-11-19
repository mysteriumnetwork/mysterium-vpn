import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/views/locations/location_markers_layer.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../../support/test_localizations.dart';

const _berlin = LatLng(52.52, 13.405);

class _RemoteConfig extends Fake implements RemoteConfigStore {
  @override
  bool get showCitiesAndStates => true;

  @override
  Set<String> get countriesWithCitiesOnMap => {'DE'};
}

class _Coordinates extends Fake implements LatLngStore {
  @override
  LatLng? coordinatesForCountry(String countryCode) => _berlin;

  @override
  LatLng? coordinatesForCity(VPNLocation location) => location.coordinates;
}

void main() {
  final remoteConfig = _RemoteConfig();
  final coordinates = _Coordinates();

  Widget buildMap({
    required List<VPNLocation> locations,
    required VPNLocation connected,
    VPNLocation? selected,
    ValueChanged<VPNLocation>? onTap,
  }) => ProviderScope(
    overrides: [
      remoteConfigStorePOD.overrideWithValue(remoteConfig),
      latLngStorePOD.overrideWithValue(coordinates),
    ],
    child: MaterialApp(
      theme: DesignSystem.lightTheme,
      locale: testLocale,
      localizationsDelegates: testLocalizationsDelegates,
      supportedLocales: testSupportedLocales,
      home: FlutterMap(
        options: const MapOptions(initialCenter: _berlin),
        children: [
          LocationMarkersLayer(
            locations: locations,
            selectedLocation: selected,
            connectedLocation: connected,
            onLocationPressed: (location, _) => onTap?.call(location),
          ),
        ],
      ),
    ),
  );

  testWidgets('same-city pins track IP type changes and keep catalog coordinates', (tester) async {
    const dcBerlin = VPNLocation(
      id: 'berlin',
      countryCode: 'DE',
      ipType: IPType.datacenter,
      translations: {},
      coordinates: _berlin,
    );
    final residentialBerlin = dcBerlin.copyWith(ipType: IPType.residential);
    final catalog = [dcBerlin, residentialBerlin];
    final pins = find.byType(MapLocationMarker);

    await tester.pumpWidget(
      buildMap(
        locations: catalog,
        connected: residentialBerlin.copyWith(coordinates: null),
        selected: dcBerlin,
      ),
    );
    expect(
      tester.widgetList<MapLocationMarker>(pins).singleWhere((p) => p.isSelected).isConnected,
      isFalse,
    );
    expect(tester.widgetList<MapLocationMarker>(pins).where((p) => p.isConnected), hasLength(1));

    await tester.pumpWidget(buildMap(locations: catalog, connected: dcBerlin, selected: dcBerlin));
    expect(
      tester.widgetList<MapLocationMarker>(pins).singleWhere((p) => p.isSelected).isConnected,
      isTrue,
    );
  });

  testWidgets('a connected Residential country does not remove its Datacenter pin', (tester) async {
    final dc = VPNLocation.fromCode('DE', IPType.datacenter);
    final residential = VPNLocation.fromCode('DE');
    VPNLocation? tapped;
    final catalog = [dc];
    final pins = find.byType(MapLocationMarker);

    await tester.pumpWidget(buildMap(locations: catalog, connected: residential));
    expect(pins, findsNWidgets(2));
    expect(tester.widgetList<MapLocationMarker>(pins).where((p) => p.isConnected), hasLength(1));

    await tester.pumpWidget(
      buildMap(
        locations: catalog,
        connected: residential,
        selected: dc,
        onTap: (location) => tapped = location,
      ),
    );
    final selectedPin = find.byWidgetPredicate(
      (widget) => widget is MapLocationMarker && widget.isSelected && !widget.isConnected,
    );
    await tester.tap(selectedPin);
    expect(tapped, dc);
  });
}
