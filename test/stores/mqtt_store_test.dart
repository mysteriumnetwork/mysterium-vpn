import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:talker/talker.dart';

import 'mqtt_store_test.mocks.dart';

@GenerateNiceMocks([MockSpec<MQTTService>(), MockSpec<Talker>()])
void main() {
  late MockMQTTService mqtt;
  late MockTalker logger;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mqtt = MockMQTTService();
    logger = MockTalker();
  });

  MqttStore newStore() => MqttStore(mqtt: mqtt, logger: logger);

  test('initStore subscribes to healthcheck and parses messages', () async {
    final controller = StreamController<String>();
    when(mqtt.subscribe('healthcheck')).thenAnswer((_) => controller.stream);

    final store = newStore();
    await store.initStore();

    controller.add(jsonEncode({'status': 'ok', 'version': '1.0.0', 'sha': 'abc123'}));
    await Future<void>.delayed(Duration.zero);

    expect(store.lastHealthcheck, isNotNull);
    await controller.close();
    store.dispose();
  });

  test('initStore is idempotent — does not re-subscribe', () async {
    final controller = StreamController<String>.broadcast();
    when(mqtt.subscribe('healthcheck')).thenAnswer((_) => controller.stream);

    final store = newStore();
    await store.initStore();
    await store.initStore();

    verify(mqtt.subscribe('healthcheck')).called(1);
    await controller.close();
    store.dispose();
  });

  test('initStore logs and rethrows on subscription errors', () async {
    when(mqtt.subscribe('healthcheck')).thenThrow(Exception('mqtt down'));

    final store = newStore();
    await expectLater(store.initStore(), throwsA(isA<Exception>()));
    verify(logger.handle(any, any)).called(1);
  });

  test('dispose cancels the active subscription', () async {
    final controller = StreamController<String>();
    when(mqtt.subscribe('healthcheck')).thenAnswer((_) => controller.stream);

    final store = newStore();
    await store.initStore();
    store.dispose();

    expect(controller.hasListener, isFalse);
    await controller.close();
  });
}
