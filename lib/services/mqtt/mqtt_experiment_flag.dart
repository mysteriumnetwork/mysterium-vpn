/// Narrow feature-flag port so `MQTTService` can read the MQTT experiment
/// toggle without depending on `RemoteConfigStore`.
abstract interface class MqttExperimentFlag {
  bool get mqttExperiment;
}
