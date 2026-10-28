import 'dart:io';

/// Per-leg timeout for a health probe, and the ceiling for any latency floor
/// configured against it.
const kProbeTimeout = Duration(seconds: 5);

/// Literal addresses of `location.mysterium.network`, the host the backend
/// excludes from the tunnel route.
///
/// A list because the host is geo/multi-addressed — resolvers hand back
/// different members — so pinning a single literal bets on one box staying in
/// the pool and staying excluded. Any one answering is enough to prove the
/// device has a network, and `controlIps` in ConfigCat can add or replace
/// members without an app release.
///
/// Must stay in step with `kDirectProbeUrl` in `tunnel_health_probe.dart` —
/// the same host, named there and numeric here. A list that is entirely stale
/// or not route-excluded turns every genuinely degraded tunnel into a "no
/// internet" snackbar, which is the inversion this check exists to prevent.
const kDefaultControlIps = <String>['159.69.15.34', '46.224.211.253', '116.203.130.98'];

/// Tunables for the resume-time tunnel health check, delivered as a single
/// ConfigCat JSON value (`tunnelHealthConfig`). Each field falls back to its
/// default independently when missing, the wrong type, or out of range, so a
/// partial or slightly malformed payload still yields a usable config.
///
/// [latencyRatioPercent] is an int percentage rather than a double on purpose:
/// a ratio entered as `2` decodes as an int, which an `is double` check would
/// reject, silently reverting to the default with no error anywhere.
class TunnelHealthConfig {
  const TunnelHealthConfig({
    this.enabled = false,
    this.minBackgroundSeconds = 300,
    this.degradedFloorMs = 1500,
    this.latencyRatioPercent = 200,
    this.controlIps = kDefaultControlIps,
  });

  factory TunnelHealthConfig.fromJson(Map<String, dynamic> json) {
    const defaults = TunnelHealthConfig();

    // `0` is meaningful here (it disables the check), so zero is accepted.
    int nonNegative(String key, int fallback) {
      final value = json[key];
      return value is int && value >= 0 ? value : fallback;
    }

    // Thresholds have no sensible zero, so these must be strictly positive.
    int positive(String key, int fallback, {int? max}) {
      final value = json[key];
      final inRange = value is int && value > 0 && (max == null || value < max);
      return inRange ? value : fallback;
    }

    // A control IP that does not parse would silently disable the check that
    // separates a bad node from a bad connection.
    // Accepts a list, or a bare string for the single-address form.
    List<String> ips(String key, List<String> fallback) {
      final value = json[key];
      final candidates = switch (value) {
        final String one => [one],
        final List<dynamic> many => many.whereType<String>().toList(),
        _ => const <String>[],
      };
      final valid = candidates.where((it) => InternetAddress.tryParse(it) != null).toList();

      return valid.isEmpty ? fallback : valid;
    }

    final enabled = json['enabled'];

    return TunnelHealthConfig(
      enabled: enabled is bool ? enabled : defaults.enabled,
      minBackgroundSeconds: nonNegative('minBackgroundSeconds', defaults.minBackgroundSeconds),
      degradedFloorMs: positive(
        'degradedFloorMs',
        defaults.degradedFloorMs,
        max: kProbeTimeout.inMilliseconds,
      ),
      latencyRatioPercent: positive('latencyRatioPercent', defaults.latencyRatioPercent),
      controlIps: ips('controlIps', defaults.controlIps),
    );
  }

  /// Master switch. Ships `false` — the feature is enabled after field data.
  final bool enabled;

  /// How long the app must stay backgrounded before a resume runs the check,
  /// in seconds. `0` disables it.
  final int minBackgroundSeconds;

  /// Latency above which the tunnelled probe counts as degraded, in ms.
  ///
  /// Must stay below the probe timeout: a successful leg can never report more
  /// than the probe's own timeout, so a higher floor would silently switch
  /// latency detection off. Out-of-range values fall back to the default.
  final int degradedFloorMs;

  /// How much slower than the direct probe the tunnelled one must be, as a
  /// percentage. Only binds once the direct probe is itself slow, so it acts
  /// as a veto on blaming the node for the user's own bad network.
  final int latencyRatioPercent;

  /// Literal IP of the control host, connected to over raw TCP so the check
  /// survives the tunnel's DNS being broken. Must stay in step with whatever
  /// the backend excludes from the tunnel route. Any one answering proves the
  /// device has a network.
  final List<String> controlIps;
}
