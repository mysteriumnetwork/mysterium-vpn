// Represents the VPN connection status
// Unified for both WireGuard and OpenVPN
enum VpnConnectionStatus {
  connecting,
  connected,
  disconnecting,
  disconnected,
  unknown;

  factory VpnConnectionStatus.fromString(String s) => VpnConnectionStatus.values.firstWhere(
    (v) => v.name == s,
    orElse: () => VpnConnectionStatus.unknown,
  );
}
