import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/views/home/home_map.dart';

class _Locations extends Fake implements LocationsStore {
  ObservableFuture<VPNLocations> dc = ObservableFuture.value(VPNLocations());
  ObservableFuture<VPNLocations> residential = ObservableFuture.value(VPNLocations());

  @override
  ObservableFuture<VPNLocations> get dcLocationsFuture => dc;

  @override
  ObservableFuture<VPNLocations> get residentialLocationsFuture => residential;

  @override
  VPNLocation? findParent(VPNLocation location) {
    final catalog = location.ipType == IPType.datacenter ? dc : residential;
    return catalog.value?.allLocations
        .where((it) => it.isCountry && it.countryCode == location.countryCode)
        .firstOrNull;
  }
}

void main() {
  const dcCountry = VPNLocation(
    id: 'DE',
    ipType: IPType.datacenter,
    translations: {},
    countryCode: 'DE',
  );
  const residentialCountry = VPNLocation(
    id: 'DE',
    ipType: IPType.residential,
    translations: {},
    countryCode: 'DE',
  );
  const dcCity = VPNLocation(
    id: 'berlin',
    ipType: IPType.datacenter,
    translations: {},
    countryCode: 'DE',
  );
  const residentialCity = VPNLocation(
    id: 'berlin',
    ipType: IPType.residential,
    translations: {},
    countryCode: 'DE',
  );
  late _Locations locations;

  setUp(() {
    locations = _Locations()
      ..dc = ObservableFuture.value(
        VPNLocations(
          locations: [
            dcCountry.copyWith(children: [dcCity]),
          ],
        ),
      )
      ..residential = ObservableFuture.value(
        VPNLocations(
          locations: [
            residentialCountry.copyWith(children: [residentialCity]),
          ],
        ),
      );
  });

  VPNLocation? resolve(
    VPNLocation marker,
    IPType? type, {
    bool cityLevelAllowed = true,
    bool hasResolvedPlan = true,
    bool residentialIPsAllowed = true,
  }) => resolveMapLocation(
    location: marker,
    ipType: type,
    locationsStore: locations,
    cityLevelAllowed: cityLevelAllowed,
    hasResolvedPlan: hasResolvedPlan,
    residentialIPsAllowed: residentialIPsAllowed,
  );

  group('resolveMapLocation', () {
    test('Datacenter tab sends hosting even when the marker was residential', () {
      final target = resolve(residentialCountry, IPType.datacenter);
      expect(target, dcCountry);
      final request = ConnectionRequest(location: target);
      expect(request.country(null), 'DE');
      expect(request.city, isNull);
      expect(request.ipType(IPType.residential)?.key, 'hosting');
    });

    test('Residential tab sends residential even when the marker was Datacenter', () {
      final target = resolve(dcCountry, IPType.residential);
      expect(target, residentialCountry);
      expect(ConnectionRequest(location: target).ipType(IPType.datacenter)?.key, 'residential');
    });

    test('preserves an explicit Datacenter city and its request metadata', () {
      final target = resolve(dcCity, IPType.datacenter);
      expect(target, same(dcCity));
      final request = ConnectionRequest(location: target);
      expect(request.city, 'berlin');
      expect(request.ipType(IPType.residential)?.key, 'hosting');
    });

    test('matches a stale city marker by both city and country in the chosen catalog', () {
      locations.dc = ObservableFuture.value(
        VPNLocations(
          locations: [
            dcCity.copyWith(countryCode: 'US'),
            dcCity,
          ],
        ),
      );
      expect(resolve(residentialCity, IPType.datacenter), dcCity);
    });

    test('does not use residential when the Datacenter country is missing', () {
      locations.dc = ObservableFuture.value(VPNLocations());
      expect(resolve(residentialCountry, IPType.datacenter), isNull);
    });

    test('does not use Datacenter when the residential country is missing', () {
      locations.residential = ObservableFuture.value(VPNLocations());
      expect(resolve(dcCountry, IPType.residential), isNull);
    });

    test('does not use the other type while the chosen catalog is still loading', () {
      final pending = Completer<VPNLocations>();
      locations.dc = ObservableFuture(pending.future);
      expect(resolve(residentialCountry, IPType.datacenter), isNull);
      pending.complete(VPNLocations());
    });

    test('does not substitute another city or country for a missing typed city', () {
      locations.dc = ObservableFuture.value(VPNLocations(locations: [dcCountry]));
      expect(resolve(residentialCity, IPType.datacenter), isNull);
    });

    test('an unavailable residential target never silently becomes Datacenter', () {
      final unavailable = residentialCountry.copyWith(isAvailable: false);
      expect(resolve(unavailable, IPType.residential), same(unavailable));
    });

    test('a plan without residential access keeps an explicit Residential selection', () {
      expect(
        resolve(residentialCountry, IPType.residential, residentialIPsAllowed: false),
        residentialCountry,
      );
    });

    for (final type in [IPType.datacenter, IPType.residential]) {
      test('a city-gated plan resolves ${type.key} to its country in the same catalog', () {
        final city = type == IPType.datacenter ? dcCity : residentialCity;
        final target = resolve(city, type, cityLevelAllowed: false);
        expect(target?.isCountry, isTrue);
        expect(target?.ipType, type);
        expect(ConnectionRequest(location: target).ipType(null), type);
      });
    }

    test('a missing parent does not trigger a cross-type fallback', () {
      locations.residential = ObservableFuture.value(VPNLocations());
      expect(
        resolve(residentialCity, IPType.residential, cityLevelAllowed: false),
        residentialCity,
      );
    });

    test('an unresolved plan preserves the chosen city and IP type', () {
      expect(
        resolve(dcCity, IPType.datacenter, cityLevelAllowed: false, hasResolvedPlan: false),
        dcCity,
      );
    });
  });

  group('standalone map', () {
    test('uses Datacenter when the plan does not allow Residential', () {
      final target = resolve(residentialCountry, null, residentialIPsAllowed: false);
      expect(target, dcCountry);
      expect(ConnectionRequest(location: target).ipType(null)?.key, 'hosting');
    });

    test('keeps Residential when the plan allows it and the location is available', () {
      expect(resolve(residentialCountry, null), residentialCountry);
    });

    test('prefers the matching Datacenter city when Residential is unavailable', () {
      expect(resolve(residentialCity.copyWith(isAvailable: false), null), dcCity);
    });

    test('a plan without city targeting falls back to a Datacenter country', () {
      expect(
        resolve(residentialCity, null, cityLevelAllowed: false, residentialIPsAllowed: false),
        dcCountry,
      );
    });

    test('preserves Residential as the upgrade target without a Datacenter alternative', () {
      locations.dc = ObservableFuture.value(VPNLocations());
      expect(resolve(residentialCountry, null, residentialIPsAllowed: false), residentialCountry);
    });
  });
}
