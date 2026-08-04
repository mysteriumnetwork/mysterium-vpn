import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mqtt5_client/mqtt5_client.dart';
import 'package:mqtt5_client/mqtt5_server_client.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:talker/talker.dart';

import 'mqtt_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<RemoteConfigStore>(), MockSpec<Talker>()])
class FakeMqttClient extends MqttServerClient {
  FakeMqttClient() : super('wss://broker.test:443', 'test-client');

  var _updates = StreamController<List<MqttReceivedMessage<MqttMessage>>>.broadcast();
  MqttConnectionState state = MqttConnectionState.connected;
  int subscribeCalls = 0;
  int unsubscribeCalls = 0;

  @override
  Stream<List<MqttReceivedMessage<MqttMessage>>>? get updates =>
      state == MqttConnectionState.connected ? _updates.stream : null;

  @override
  MqttConnectionStatus? get connectionStatus => MqttConnectionStatus()..state = state;

  @override
  MqttSubscription? subscribe(String topic, MqttQos qosLevel) {
    subscribeCalls++;
    return MqttSubscription(MqttSubscriptionTopic(topic));
  }

  @override
  void unsubscribeSubscription(MqttSubscription subscription) {
    unsubscribeCalls++;
  }

  void emit(String topic, String message) {
    final builder = MqttPayloadBuilder()..addString(message);
    final publish = MqttPublishMessage()..payload.message = builder.payload;
    _updates.add([MqttReceivedMessage<MqttMessage>(topic, publish)]);
  }

  // a manual stop/start cycle recreates the subscriptions manager, so updates is a new stream
  void recreateUpdatesStream() {
    _updates.close();
    _updates = StreamController<List<MqttReceivedMessage<MqttMessage>>>.broadcast();
  }
}

void main() {
  late FakeMqttClient client;
  late MockRemoteConfigStore remoteConfig;
  late MockTalker logger;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    client = FakeMqttClient();
    remoteConfig = MockRemoteConfigStore();
    logger = MockTalker();
    when(remoteConfig.mqttExperiment).thenReturn(true);
  });

  MQTTService newService() =>
      MQTTService.withClient(client, 'wss://broker.test:443', 'user', 'pass', logger, remoteConfig);

  test('delivers messages for a subscribed topic', () async {
    final service = newService();
    final received = <String>[];
    service.subscribe('healthcheck').listen(received.add);

    client
      ..emit('healthcheck', 'hello')
      ..emit('other-topic', 'ignored');
    await Future<void>.delayed(Duration.zero);

    expect(received, ['hello']);
  });

  test('reconnect re-fires onConnected without crashing and keeps delivering', () async {
    final service = newService();
    final received = <String>[];
    service.subscribe('healthcheck').listen(received.add);

    // auto-reconnect: broker CONNACK fires onConnected again on the same updates stream
    client.onConnected!();
    await Future<void>.delayed(Duration.zero);

    client.emit('healthcheck', 'after-reconnect');
    await Future<void>.delayed(Duration.zero);

    expect(received, ['after-reconnect']);
  });

  test('stop/start cycle re-attaches forwarding to the new updates stream', () async {
    final service = newService();
    final received = <String>[];
    service.subscribe('healthcheck').listen(received.add);

    client
      ..state = MqttConnectionState.disconnected
      ..recreateUpdatesStream()
      ..state = MqttConnectionState.connected
      ..onConnected!();
    await Future<void>.delayed(Duration.zero);

    client.emit('healthcheck', 'after-restart');
    await Future<void>.delayed(Duration.zero);

    expect(received, ['after-restart']);
  });

  test('cancelling the stream unsubscribes from the broker', () async {
    final service = newService();
    final sub = service.subscribe('healthcheck').listen((_) {});

    await sub.cancel();

    expect(client.unsubscribeCalls, 1);
  });

  test('cancelled topics are not re-subscribed on reconnect', () async {
    final service = newService();
    final sub = service.subscribe('healthcheck').listen((_) {});
    await sub.cancel();

    client.subscribeCalls = 0;
    client.onConnected!();

    expect(client.subscribeCalls, 0);
  });

  test('returns an empty stream when the mqtt experiment is disabled', () async {
    when(remoteConfig.mqttExperiment).thenReturn(false);
    final service = newService();

    await expectLater(service.subscribe('healthcheck'), emitsDone);
    expect(client.subscribeCalls, 0);
  });
}
