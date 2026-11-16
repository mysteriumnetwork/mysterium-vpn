import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:talker/talker.dart';

import 'mqtt_connection_store_test.mocks.dart';

@GenerateNiceMocks([MockSpec<MQTTService>(), MockSpec<AnalyticsStore>(), MockSpec<Talker>()])
void main() {
  late MockMQTTService mqtt;
  late MockAnalyticsStore analytics;
  late MockTalker logger;
  late MqttConnectionStore store;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mqtt = MockMQTTService();
    analytics = MockAnalyticsStore();
    logger = MockTalker();
    when(mqtt.start()).thenAnswer((_) async {});
    store = MqttConnectionStore(mqtt: mqtt, analytics: analytics, logger: logger);
  });

  tearDown(() => store.dispose());

  /// Every test but the backgrounded ones starts foregrounded; the binding's
  /// own lifecycle state is not drivable from a plain `test()`.
  Future<void> initForeground() => store.init(lifecycleState: AppLifecycleState.resumed);

  Map<String, dynamic> captureDropParams() =>
      verify(
            analytics.logEvent(
              AnalyticsEvent.mqttReconnects,
              parameters: captureAnyNamed('parameters'),
            ),
          ).captured.single
          as Map<String, dynamic>;

  test('init connects and registers for lifecycle changes', () async {
    await initForeground();

    verify(mqtt.start()).called(1);
  });

  test('leaving the foreground closes the connection', () async {
    await initForeground();
    clearInteractions(mqtt);

    store.didChangeAppLifecycleState(AppLifecycleState.paused);

    verify(mqtt.stop()).called(1);
  });

  test('returning to the foreground reconnects once', () async {
    await initForeground();
    store.didChangeAppLifecycleState(AppLifecycleState.paused);
    clearInteractions(mqtt);

    store.didChangeAppLifecycleState(AppLifecycleState.resumed);
    await Future<void>.delayed(Duration.zero);

    verify(mqtt.start()).called(1);
  });

  // Flutter expands paused -> resumed into hidden -> inactive -> resumed, so
  // only the first non-resumed state may close the connection.
  test('a hidden/inactive sequence closes the connection once', () async {
    await initForeground();
    clearInteractions(mqtt);

    store
      ..didChangeAppLifecycleState(AppLifecycleState.hidden)
      ..didChangeAppLifecycleState(AppLifecycleState.inactive)
      ..didChangeAppLifecycleState(AppLifecycleState.paused);

    verify(mqtt.stop()).called(1);
  });

  test('a cold-start resumed does not reconnect', () async {
    await initForeground();
    clearInteractions(mqtt);

    store.didChangeAppLifecycleState(AppLifecycleState.resumed);
    await Future<void>.delayed(Duration.zero);

    verifyNever(mqtt.start());
  });

  test('a failed connect is reported, not thrown', () async {
    when(mqtt.start()).thenThrow(Exception('broker down'));

    await expectLater(initForeground(), completes);

    verify(logger.warning(any, any, any)).called(1);
  });

  test('dispose closes the connection', () async {
    await initForeground();
    clearInteractions(mqtt);

    await store.dispose();

    verify(mqtt.stop()).called(1);
  });

  group('registration while already backgrounded', () {
    // Deferred init can land after the app has gone away, and registering an
    // observer replays nothing — so without seeding, the socket would be
    // opened and then held until a full lifecycle cycle completed.
    test('does not connect, and defers to the next resume', () async {
      await store.init(lifecycleState: AppLifecycleState.paused);

      verifyNever(mqtt.start());

      store.didChangeAppLifecycleState(AppLifecycleState.resumed);
      await Future<void>.delayed(Duration.zero);

      verify(mqtt.start()).called(1);
    });
  });

  group('a connect that outlives the foreground', () {
    // stop() cannot cancel a handshake already in flight, so the intent is
    // re-read once it lands; otherwise a late success leaves MQTT running.
    test('is closed again once it lands', () async {
      final handshake = Completer<void>();
      when(mqtt.start()).thenAnswer((_) => handshake.future);

      final pending = initForeground();
      store.didChangeAppLifecycleState(AppLifecycleState.paused);
      handshake.complete();
      await pending;

      // Once for the backgrounding, once for the late handshake.
      verify(mqtt.stop()).called(2);
    });

    test('a resume mid-handshake joins it instead of opening a second', () async {
      final handshake = Completer<void>();
      when(mqtt.start()).thenAnswer((_) => handshake.future);

      final pending = initForeground();
      store
        ..didChangeAppLifecycleState(AppLifecycleState.paused)
        ..didChangeAppLifecycleState(AppLifecycleState.resumed);
      handshake.complete();
      await pending;
      await Future<void>.delayed(Duration.zero);

      verify(mqtt.start()).called(1);
    });
  });

  group('drop counting', () {
    test('reports unwanted drops once, on leaving the foreground', () async {
      await initForeground();

      store
        ..handleConnectionChanged(connected: false)
        ..handleConnectionChanged(connected: true)
        ..handleConnectionChanged(connected: false);

      verifyNever(
        analytics.logEvent(AnalyticsEvent.mqttReconnects, parameters: anyNamed('parameters')),
      );

      store.didChangeAppLifecycleState(AppLifecycleState.paused);

      expect(captureDropParams()['count'], 2);
    });

    test('a deliberate close is not counted', () async {
      await initForeground();

      store
        ..didChangeAppLifecycleState(AppLifecycleState.paused)
        ..handleConnectionChanged(connected: false)
        ..didChangeAppLifecycleState(AppLifecycleState.resumed);
      await Future<void>.delayed(Duration.zero);
      store.didChangeAppLifecycleState(AppLifecycleState.paused);

      verifyNever(
        analytics.logEvent(AnalyticsEvent.mqttReconnects, parameters: anyNamed('parameters')),
      );
    });

    test('a clean foreground period reports nothing', () async {
      await initForeground();

      store.didChangeAppLifecycleState(AppLifecycleState.paused);

      verifyNever(
        analytics.logEvent(AnalyticsEvent.mqttReconnects, parameters: anyNamed('parameters')),
      );
    });

    test('dispose reports what the last foreground period accrued', () async {
      await initForeground();
      store.handleConnectionChanged(connected: false);

      await store.dispose();

      expect(captureDropParams()['count'], 1);
    });
  });
}
