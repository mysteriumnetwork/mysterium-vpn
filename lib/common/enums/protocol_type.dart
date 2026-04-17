/// Protocol types supported by the app.
enum ProtocolType {
  wireguard('Fast (WireGuard)'),
  openvpn('OpenVPN');

  const ProtocolType(this.label);

  final String label;
}
