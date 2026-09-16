/// Narrow feature-flag port so `MQTTService` can read the MQTT experiment
/// toggle without depending on `RemoteConfigStore`.
typedef MqttExperimentFlag = bool Function();
