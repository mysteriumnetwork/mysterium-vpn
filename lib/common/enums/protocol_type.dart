/// Protocol types supported by the app.
enum ProtocolType {
  wireguard('WireGuard'),
  openvpn('OpenVPN'),
  vless('VLESS');

  const ProtocolType(this.label);

  final String label;
}
