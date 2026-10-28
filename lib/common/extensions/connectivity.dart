import 'package:connectivity_plus/connectivity_plus.dart';

extension ConnectivityReportLabel on List<ConnectivityResult> {
  /// The connection kind to send as `internet_type` in a broken-node report.
  ///
  /// The platform can report several transports at once, so the most specific
  /// physical one wins; `vpn` is only reported when nothing else is known,
  /// since our own tunnel would otherwise mask the real network.
  String get reportLabel {
    if (contains(ConnectivityResult.wifi)) {
      return 'wifi';
    }
    if (contains(ConnectivityResult.mobile)) {
      return 'mobile';
    }
    if (contains(ConnectivityResult.ethernet)) {
      return 'ethernet';
    }
    if (contains(ConnectivityResult.vpn)) {
      return 'vpn';
    }
    if (every((it) => it == ConnectivityResult.none)) {
      return 'none';
    }
    return 'other';
  }
}
