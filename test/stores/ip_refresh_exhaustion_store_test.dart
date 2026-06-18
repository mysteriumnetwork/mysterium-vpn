import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/ip_refresh_exhaustion_store.dart';

class _FakeAnalyticsStore with AnalyticsStore {
  final events = <({AnalyticsEvent event, Map<String, dynamic>? params})>[];

  @override
  Future<void> logEvent(AnalyticsEvent event, {Map<String, dynamic>? parameters}) async {
    events.add((event: event, params: parameters));
  }

  @override
  List<NavigatorObserver> navigationObservers() => [];
  @override
  Future<void> setUserId(String id) async {}
  @override
  Future<void> setLogin([GrantType loginMethod = GrantType.email]) async {}
  @override
  Future<void> setConsents() async {}
}

const _country = VPNLocation(
  id: 'us',
  countryCode: 'us',
  ipType: IPType.datacenter,
  translations: {'en': 'United States'},
);
const _city = VPNLocation(
  id: 'new-york',
  countryCode: 'us',
  ipType: IPType.residential,
  translations: {'en': 'New York'},
);

void main() {
  late _FakeAnalyticsStore analytics;
  late IpRefreshExhaustionStore store;

  setUp(() {
    analytics = _FakeAnalyticsStore();
    store = IpRefreshExhaustionStore(analytics);
  });

  tearDown(() => analytics.dispose());

  test('fires notice once when refreshCount reaches nodeCount - 1', () {
    store.onConnected(_country);
    for (var i = 0; i < 9; i++) {
      store.registerRefresh(11);
      expect(store.exhaustionNotice, isNull, reason: 'refresh ${i + 1} should not exhaust');
    }
    store.registerRefresh(11); // 10th
    expect(store.exhaustionNotice, _country);
    expect(analytics.events, hasLength(1));
    expect(analytics.events.single.params, {
      'scope': 'country',
      'location_id': 'us',
      'location_name': 'United States',
      'ip_type': 'datacenter',
      'refresh_attempt_count': 10,
      'node_count': 11,
    });
  });

  test('does not re-fire on further refreshes within the same connection', () {
    store.onConnected(_country);
    for (var i = 0; i < 12; i++) {
      store.registerRefresh(11);
    }
    expect(analytics.events, hasLength(1));
  });

  test('onConnected resets count and notice', () {
    store.onConnected(_country);
    for (var i = 0; i < 10; i++) {
      store.registerRefresh(11);
    }
    store.onConnected(_city);
    expect(store.exhaustionNotice, isNull);
    store.registerRefresh(5); // count 1, needs 4
    expect(store.exhaustionNotice, isNull);
  });

  test('onDisconnected resets state', () {
    store
      ..onConnected(_country)
      ..registerRefresh(11)
      ..onDisconnected();
    expect(store.exhaustionNotice, isNull);
    store.registerRefresh(11); // no tracked location -> no-op
    expect(store.exhaustionNotice, isNull);
    expect(analytics.events, isEmpty);
  });

  test('never fires when poolCount is zero', () {
    store.onConnected(_country);
    for (var i = 0; i < 5; i++) {
      store.registerRefresh(0);
    }
    expect(store.exhaustionNotice, isNull);
    expect(analytics.events, isEmpty);
  });

  test('city location reports city scope and residential ip_type', () {
    store.onConnected(_city);
    for (var i = 0; i < 4; i++) {
      store.registerRefresh(5); // 4th refresh, nodeCount 5 -> exhausted
    }
    expect(store.exhaustionNotice, _city);
    expect(analytics.events.single.params?['scope'], 'city');
    expect(analytics.events.single.params?['location_name'], 'New York');
    expect(analytics.events.single.params?['ip_type'], 'residential');
  });

  test('clearNotice clears the observable', () {
    store.onConnected(_country);
    for (var i = 0; i < 10; i++) {
      store.registerRefresh(11);
    }
    store.clearNotice();
    expect(store.exhaustionNotice, isNull);
  });
}
