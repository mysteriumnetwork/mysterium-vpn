/// Protocol types supported by the app.
enum ProtocolType {
  wireguard('WireGuard'),
  openvpn('OpenVPN');

  const ProtocolType(this.subtitle);

  final String subtitle;
}
