import 'package:mysterium_vpn/services/network_health/tunnel_health_types.dart';

/// Maps a probe sample to a verdict. Pure: every input is a parameter.
///
/// The hard case — both HTTP legs down — is decided by the control connect,
/// not by the legs themselves. The tunnel pushes its own DNS, so a broken
/// tunnel breaks name resolution for both legs alike and they fail together
/// whether the fault is the node or the user's own connection. Only the
/// control, which needs no DNS, tells those apart.
TunnelHealthVerdict classifyTunnelHealth({
  required TunnelHealthSample sample,
  required bool tunnelCarriedData,
  required int degradedFloorMs,
  required int latencyRatioPercent,
  required bool connected,
}) {
  final tunnelled = sample.tunnelled.elapsed;
  final direct = sample.direct.elapsed;
  final anyLegAnswered = tunnelled != null || direct != null;

  if (!connected) {
    // No tunnel to assess, so the only question is whether the device is
    // online at all. Degradation cannot be measured without a comparison.
    return anyLegAnswered || sample.controlReachable
        ? TunnelHealthVerdict.healthy
        : TunnelHealthVerdict.noNetwork;
  }

  if (!anyLegAnswered) {
    if (!sample.controlReachable) {
      return TunnelHealthVerdict.noNetwork;
    }
    // The user's network is demonstrably alive while nothing gets through the
    // tunnel: the node is at fault, unless the counters say it carried data.
    return tunnelCarriedData ? TunnelHealthVerdict.inconclusive : TunnelHealthVerdict.degraded;
  }

  if (direct == null) {
    return TunnelHealthVerdict.inconclusive;
  }
  if (!sample.bypassVerified) {
    return TunnelHealthVerdict.bypassUnavailable;
  }
  if (tunnelled == null) {
    // Counters proving the tunnel moved data both ways mean the endpoint is
    // down, not the node.
    return tunnelCarriedData ? TunnelHealthVerdict.inconclusive : TunnelHealthVerdict.degraded;
  }

  final overFloor = tunnelled.inMilliseconds >= degradedFloorMs;
  final overRatio = tunnelled.inMilliseconds * 100 >= direct.inMilliseconds * latencyRatioPercent;

  return overFloor && overRatio ? TunnelHealthVerdict.degraded : TunnelHealthVerdict.healthy;
}
