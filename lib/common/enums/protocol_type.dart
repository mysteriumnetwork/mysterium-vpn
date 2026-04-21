/// Protocol types supported by the app.
enum ProtocolType {
  wireguard('fastLabel', 'WireGuard'),
  openvpn('batterySaverLabel', 'OpenVPN');

  const ProtocolType(this.labelKey, this.subtitle);

  /// Locale key resolved via easy_localization at call site.
  final String labelKey;

  /// Technical protocol name shown as subtitle.
  final String subtitle;
}
