import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/map_extensions.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';

class _FakeAnalyticsStore with AnalyticsStore {
  final List<GrantType> loginCalls = [];
  final List<String> userIdCalls = [];

  @override
  List<NavigatorObserver> navigationObservers() => [];

  @override
  Future<void> setUserId(String id) async => userIdCalls.add(id);

  @override
  Future<void> setLogin([GrantType loginMethod = GrantType.email]) async =>
      loginCalls.add(loginMethod);

  @override
  Future<void> setConsents() async {}
}

void main() {
  late _FakeAnalyticsStore store;

  setUp(() {
    store = _FakeAnalyticsStore();
  });

  tearDown(() {
    store.dispose();
  });

  Future<AnalyticsLogEntry> nextLog() => store.watchLogs().first;
  Future<AnalyticsUserProperty> nextProperty() => store.watchUserProperties().first;

  group('logEvent', () {
    test('emits an event entry with formatted name and parameters', () async {
      final entry = nextLog();
      await store.logEvent(AnalyticsEvent.appLaunch, parameters: {'platform': 'ios'});

      final log = await entry;
      expect(log.type, AnalyticsLogType.event);
      expect(log.message, AnalyticsEvent.appLaunch.formattedName);
      expect(log.params, {'platform': 'ios'});
    });
  });

  group('logError', () {
    test('emits an error entry with fatal flag', () async {
      final entry = nextLog();
      await store.logError(err: 'boom', fatal: true);

      final log = await entry;
      expect(log.type, AnalyticsLogType.error);
      expect(log.message, 'boom');
      expect(log.params, {'fatal': true});
    });

    test('defaults fatal to false', () async {
      final entry = nextLog();
      await store.logError(err: Exception('e'));

      final log = await entry;
      expect(log.params, {'fatal': false});
    });
  });

  group('setUserProperty', () {
    test('emits to user-properties stream', () async {
      final next = nextProperty();
      final prop = AnalyticsUserProperty.fromEnum(
        name: AnalyticsUserPropName.email,
        value: 'a@b.com',
      );
      await store.setUserProperty(prop);

      expect(await next, prop);
    });
  });

  group('logMessage / logScreenViewed', () {
    test('logMessage emits message-typed entry', () async {
      final entry = nextLog();
      await store.logMessage('hello');

      final log = await entry;
      expect(log.type, AnalyticsLogType.message);
      expect(log.message, 'hello');
    });

    test('logScreenViewed emits screenView-typed entry', () async {
      final entry = nextLog();
      await store.logScreenViewed('Home');

      final log = await entry;
      expect(log.type, AnalyticsLogType.screenView);
      expect(log.message, 'Home');
    });
  });

  group('parameter-laden helpers', () {
    test('logSearchEvent embeds search_term', () async {
      final entry = nextLog();
      await store.setSearchEvent('us');

      final log = await entry;
      expect(log.message, AnalyticsEvent.search.formattedName);
      expect(log.params, {'search_term': 'us'});
    });

    test('logThemeChange embeds themeMode', () async {
      final entry = nextLog();
      await store.logThemeChange('dark');

      expect((await entry).params, {'themeMode': 'dark'});
    });

    test('logLanguageChange embeds language', () async {
      final entry = nextLog();
      await store.logLanguageChange('en');

      expect((await entry).params, {'language': 'en'});
    });

    test('logBannerClose / logBannerClick embed banner name', () async {
      final close = nextLog();
      await store.logBannerClose(BannerType.datacenter);
      expect((await close).params, {'banner': BannerType.datacenter.name});

      final click = store.watchLogs().skip(1).first;
      await store.logBannerClick(BannerType.datacenter);
      expect((await click).params, {'banner': BannerType.datacenter.name});
    });

    test('logLocationTabOpen embeds ip_type', () async {
      final entry = nextLog();
      await store.logLocationTabOpen(IPType.residential);

      expect((await entry).params, {'ip_type': IPType.residential.name});
    });

    test('logTabChange embeds tab name', () async {
      final entry = nextLog();
      await store.logTabChange(IPType.residential);

      expect((await entry).params, {'tab': IPType.residential.name});
    });

    test('logRefreshIP embeds ip when provided', () async {
      final entry = nextLog();
      await store.logRefreshIP('1.2.3.4');

      expect((await entry).params, {'ip': '1.2.3.4'});
    });

    test('logRefreshIP omits parameters when ip is null', () async {
      final entry = nextLog();
      await store.logRefreshIP();

      expect((await entry).params, isNull);
    });

    test('logMapLocationClick embeds location id and short coordinate', () async {
      final entry = nextLog();
      const point = LatLng(1.234, 5.678);
      await store.logMapLocationClick('paris', point);

      final params = (await entry).params!;
      expect(params['location'], 'paris');
      expect(params['point'], point.toShortString());
    });
  });

  group('connect / disconnect', () {
    const location = VPNLocation(
      id: 'us-1',
      ipType: IPType.residential,
      translations: {},
      countryCode: 'US',
    );

    test('logConnect with a location embeds location + ip_type', () async {
      final entry = nextLog();
      await store.logConnect(location);

      final params = (await entry).params!;
      expect(params['location'], 'us-1');
      expect(params['ip_type'], 'residential');
      expect(params.containsKey('user_intent'), isFalse);
    });

    test('logConnect with intent adds user_intent', () async {
      final entry = nextLog();
      await store.logConnect(location, intent: UserIntent.streaming);

      expect((await entry).params!['user_intent'], UserIntent.streaming.key);
    });

    test('logConnect with null location emits no parameters', () async {
      final entry = nextLog();
      await store.logConnect(null);

      expect((await entry).params, isNull);
    });

    test('logDisconnect mirrors logConnect parameters', () async {
      final entry = nextLog();
      await store.logDisconnect(location);

      expect((await entry).message, AnalyticsEvent.disconnectFromVpn.formattedName);
      expect((await entry).params!['location'], 'us-1');
    });
  });

  group('logProductSelected', () {
    test('maps each plan to its analytics event', () async {
      // Add events first, then drain — ReplayStreamController is racy when
      // listening overlaps with add().
      await store.logProductSelected(kAnnualPlan, [kAnnualPlan]);
      await store.logProductSelected(kMonthlyPlan, [kMonthlyPlan]);
      await store.logProductSelected(ksemiAnnualPlan, [ksemiAnnualPlan]);

      final logs = await store.watchLogs().take(3).toList();

      expect(logs.map((e) => e.message), [
        AnalyticsEvent.click1YearPlan.formattedName,
        AnalyticsEvent.click1MonthPlan.formattedName,
        AnalyticsEvent.click6MonthsPlan.formattedName,
      ]);
    });

    test('emits nothing for an unknown product id', () async {
      // No subscription before call → no entry should arrive.
      final logs = <AnalyticsLogEntry>[];
      final sub = store.watchLogs().listen(logs.add);

      await store.logProductSelected('mystery_plan', ['mystery_plan']);
      await Future.delayed(Duration.zero);

      expect(logs, isEmpty);
      await sub.cancel();
    });
  });

  group('logPaymentSuccess', () {
    test('emits both verification-success and 1m bucket for duration=1', () async {
      final logs = <AnalyticsLogEntry>[];
      final sub = store.watchLogs().listen(logs.add);

      await store.logPaymentSuccess(productId: 'p', price: '9.99', currency: 'USD', duration: 1);
      await Future.delayed(Duration.zero);

      expect(logs.length, 2);
      expect(logs[0].message, AnalyticsEvent.paymentVerificationSuccess.formattedName);
      expect(logs[1].message, AnalyticsEvent.paymentSuccess1m.formattedName);
      await sub.cancel();
    });

    test('emits 6m bucket for duration=6', () async {
      final logs = <AnalyticsLogEntry>[];
      final sub = store.watchLogs().listen(logs.add);

      await store.logPaymentSuccess(productId: 'p', price: '9', currency: 'USD', duration: 6);
      await Future.delayed(Duration.zero);

      expect(logs[1].message, AnalyticsEvent.paymentSuccess6m.formattedName);
      await sub.cancel();
    });

    test('emits 1y bucket for duration=12', () async {
      final logs = <AnalyticsLogEntry>[];
      final sub = store.watchLogs().listen(logs.add);

      await store.logPaymentSuccess(productId: 'p', price: '9', currency: 'USD', duration: 12);
      await Future.delayed(Duration.zero);

      expect(logs[1].message, AnalyticsEvent.paymentSuccess1y.formattedName);
      await sub.cancel();
    });

    test('emits only the verification event for an unknown duration', () async {
      final logs = <AnalyticsLogEntry>[];
      final sub = store.watchLogs().listen(logs.add);

      await store.logPaymentSuccess(productId: 'p', price: '9', currency: 'USD', duration: 3);
      await Future.delayed(Duration.zero);

      expect(logs.length, 1);
      expect(logs.single.message, AnalyticsEvent.paymentVerificationSuccess.formattedName);
      await sub.cancel();
    });
  });

  group('logSubscriptionCancellationSurvey', () {
    test('joins reasons with comma and includes feedback', () async {
      final entry = nextLog();
      await store.logSubscriptionCancellationSurvey(
        reasons: {'price', 'speed'},
        feedback: 'too pricey',
      );

      final params = (await entry).params!;
      expect((params['reasons']! as String).split(',').toSet(), {'price', 'speed'});
      expect(params['feedback'], 'too pricey');
    });

    test('omits feedback when null', () async {
      final entry = nextLog();
      await store.logSubscriptionCancellationSurvey(reasons: {'price'});

      expect((await entry).params!.containsKey('feedback'), isFalse);
    });
  });

  group('cancellation flow analytics', () {
    test('logCancellationReasonSubmitted joins reasons and includes feedback', () async {
      final entry = nextLog();
      await store.logCancellationReasonSubmitted(
        reasons: {'price', 'speed'},
        feedback: 'too pricey',
      );

      final log = await entry;
      expect(log.message, AnalyticsEvent.cancellationReasonSubmitted.formattedName);
      expect((log.params!['reasons']! as String).split(',').toSet(), {'price', 'speed'});
      expect(log.params!['feedback'], 'too pricey');
    });

    test('logCancellationReasonSkipped emits event with no params', () async {
      final entry = nextLog();
      await store.logCancellationReasonSkipped();

      final log = await entry;
      expect(log.message, AnalyticsEvent.cancellationReasonSkipped.formattedName);
    });
  });

  group('logPushNotificationsPermissionsChanged', () {
    test('granted → granted event + property', () async {
      final logFuture = nextLog();
      final propFuture = nextProperty();

      await store.logPushNotificationsPermissionsChanged(permissionsGranted: true);

      final log = await logFuture;
      expect(log.message, AnalyticsEvent.pushNotificationsPermissionsGranted.formattedName);
      expect(log.params, {'permission': 'true'});

      final prop = await propFuture;
      expect(prop.value, 'true');
    });

    test('denied → denied event + property', () async {
      final logFuture = nextLog();
      final propFuture = nextProperty();

      await store.logPushNotificationsPermissionsChanged(permissionsGranted: false);

      final log = await logFuture;
      expect(log.message, AnalyticsEvent.pushNotificationsPermissionsDenied.formattedName);
      expect((await propFuture).value, 'false');
    });
  });

  group('logIpRefreshExhausted', () {
    test('emits exhausted event with location/type/counts for a country', () async {
      final entry = nextLog();
      await store.logIpRefreshExhausted(
        location: const VPNLocation(
          id: 'us',
          countryCode: 'us',
          ipType: IPType.datacenter,
          translations: {'en': 'United States'},
        ),
        nodeCount: 11,
        refreshCount: 10,
      );

      final log = await entry;
      expect(log.message, AnalyticsEvent.ipRefreshExhaustedMessageShown.formattedName);
      expect(log.params, {
        'scope': 'country',
        'location_id': 'us',
        'location_name': 'United States',
        'ip_type': 'datacenter',
        'refresh_attempt_count': 10,
        'node_count': 11,
      });
    });

    test('uses city scope and residential ip_type for a city', () async {
      final entry = nextLog();
      await store.logIpRefreshExhausted(
        location: const VPNLocation(
          id: 'new-york',
          countryCode: 'us',
          ipType: IPType.residential,
          translations: {},
        ),
        nodeCount: 5,
        refreshCount: 4,
      );

      final log = await entry;
      expect(log.params?['scope'], 'city');
      expect(log.params?['location_name'], 'new-york');
      expect(log.params?['ip_type'], 'residential');
    });
  });

  group('streams', () {
    test('replays previous events to late subscribers', () async {
      await store.logEvent(AnalyticsEvent.appLaunch);
      // ReplayStreamController replays buffered values to a new listener.
      expect(await store.watchLogs().first, isA<AnalyticsLogEntry>());
    });
  });

  group('tab navigation events', () {
    test('logMapTabViewed emits the event with no parameters', () async {
      final entry = nextLog();
      await store.logMapTabViewed();
      final log = await entry;
      expect(log.message, AnalyticsEvent.mapTabViewed.formattedName);
      expect(log.params, isNull);
    });

    test('logLocationsTabViewed emits the event with no parameters', () async {
      final entry = nextLog();
      await store.logLocationsTabViewed();
      final log = await entry;
      expect(log.message, AnalyticsEvent.locationsTabViewed.formattedName);
      expect(log.params, isNull);
    });

    test('logSettingsTabViewed emits the event with no parameters', () async {
      final entry = nextLog();
      await store.logSettingsTabViewed();
      final log = await entry;
      expect(log.message, AnalyticsEvent.settingsTabViewed.formattedName);
      expect(log.params, isNull);
    });

    test('logMapSearchRedirectedToLocations emits query flags', () async {
      final entry = nextLog();
      await store.logMapSearchRedirectedToLocations(queryEntered: true, queryPreserved: true);
      final log = await entry;
      expect(log.message, AnalyticsEvent.mapSearchRedirectedToLocations.formattedName);
      expect(log.params, {'query_entered': true, 'query_preserved': true});
    });

    test(
      'logProductsTabViewed on successful open emits variant + redirected_to_login=false',
      () async {
        final entry = nextLog();
        await store.logProductsTabViewed(
          redirectedToLogin: false,
          variant: ProductsScreenVariant.defaultUpgrade,
        );
        final log = await entry;
        expect(log.message, AnalyticsEvent.productsTabViewed.formattedName);
        expect(log.params, {'redirected_to_login': false, 'screen_variant': 'default_upgrade'});
      },
    );

    test('logProductsTabViewed on redirect omits screen_variant', () async {
      final entry = nextLog();
      await store.logProductsTabViewed(redirectedToLogin: true);
      final log = await entry;
      expect(log.message, AnalyticsEvent.productsTabViewed.formattedName);
      expect(log.params, {'redirected_to_login': true});
    });
  });
}
