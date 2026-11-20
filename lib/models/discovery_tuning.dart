/// Tunables for signed domain discovery, delivered as a single ConfigCat JSON
/// value (`domainDiscoveryConfig`).
class DiscoveryTuning {
  const DiscoveryTuning({
    this.enabled = true,
    this.checkInterval = const Duration(minutes: 30),
    this.cooldown = const Duration(minutes: 30),
    this.refreshInterval = const Duration(hours: 1),
  });

  factory DiscoveryTuning.fromJson(Map<String, dynamic> json) {
    const defaults = DiscoveryTuning();

    // A day is the ceiling for every interval here: anything longer is a typo,
    // and silently honouring it would strand the feature for that long.
    const ceilingMinutes = 24 * 60;

    Duration minutes(String key, Duration fallback, {int min = 1}) {
      final value = json[key];
      final inRange = value is int && value >= min && value <= ceilingMinutes;
      return inRange ? Duration(minutes: value) : fallback;
    }

    final enabled = json['enabled'];

    return DiscoveryTuning(
      enabled: enabled is bool ? enabled : defaults.enabled,
      // Zero is meaningful only for the check interval: it turns the background
      // warm-up off while leaving failover itself on.
      checkInterval: minutes('checkIntervalMinutes', defaults.checkInterval, min: 0),
      cooldown: minutes('cooldownMinutes', defaults.cooldown),
      refreshInterval: minutes('refreshIntervalMinutes', defaults.refreshInterval),
    );
  }

  /// Master switch for the whole feature.
  final bool enabled;

  /// How often the browser hosts are health-checked in the background.
  final Duration checkInterval;

  /// How long a failed host is deprioritised.
  final Duration cooldown;

  /// How long a verified configuration is reused before refetching.
  final Duration refreshInterval;
}
