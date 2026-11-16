import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:talker/talker.dart';

import 'mqtt_connection_store_test.mocks.dart';

@GenerateNiceMocks([MockSpec<MQTTService>(), MockSpec<Talker>()])
void main() {
  late MockMQTTService mqtt;
  late MockTalker logger;
  late MqttConnectionStore store;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mqtt = MockMQTTService();
    logger = MockTalker();
    when(mqtt.start()).thenAnswer((_) async {});
    store = MqttConnectionStore(mqtt: mqtt, logger: logger);
  });

  tearDown(() => store.dispose());

  test('init connects and registers for lifecycle changes', () async {
    await store.init();

    verify(mqtt.start()).called(1);
  });

  test('leaving the foreground closes the connection', () async {
    await store.init();
    clearInteractions(mqtt);

    store.didChangeAppLifecycleState(AppLifecycleState.paused);

    verify(mqtt.stop()).called(1);
  });

  test('returning to the foreground reconnects once', () async {
    await store.init();
    store.didChangeAppLifecycleState(AppLifecycleState.paused);
    clearInteractions(mqtt);

    store.didChangeAppLifecycleState(AppLifecycleState.resumed);
    await Future<void>.delayed(Duration.zero);

    verify(mqtt.start()).called(1);
  });

  // Flutter expands paused -> resumed into hidden -> inactive -> resumed, so
  // only the first non-resumed state may close the connection.
  test('a hidden/inactive sequence closes the connection once', () async {
    await store.init();
    clearInteractions(mqtt);

    store
      ..didChangeAppLifecycleState(AppLifecycleState.hidden)
      ..didChangeAppLifecycleState(AppLifecycleState.inactive)
      ..didChangeAppLifecycleState(AppLifecycleState.paused);

    verify(mqtt.stop()).called(1);
  });

  test('a cold-start resumed does not reconnect', () async {
    await store.init();
    clearInteractions(mqtt);

    store.didChangeAppLifecycleState(AppLifecycleState.resumed);
    await Future<void>.delayed(Duration.zero);

    verifyNever(mqtt.start());
  });

  test('a failed connect is reported, not thrown', () async {
    when(mqtt.start()).thenThrow(Exception('broker down'));

    await expectLater(store.init(), completes);

    verify(logger.warning(any, any, any)).called(1);
  });

  test('dispose closes the connection', () async {
    await store.init();
    clearInteractions(mqtt);

    await store.dispose();

    verify(mqtt.stop()).called(1);
  });
}
