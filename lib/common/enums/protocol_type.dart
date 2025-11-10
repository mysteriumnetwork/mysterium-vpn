/// Protocol types supported by the app.
enum ProtocolType {
  wireguard('WireGuard'),
  openvpn('OpenVPN');

  const ProtocolType(this.label);

  final String label;
}
