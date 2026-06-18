import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';

part 'ip_refresh_exhaustion_store.g.dart';

// ignore: library_private_types_in_public_api
class IpRefreshExhaustionStore = _IpRefreshExhaustionStore with _$IpRefreshExhaustionStore;

/// Tracks refresh presses for the current connection and surfaces a one-shot
/// notice when all refresh-eligible IPs for the selected location are used up.
abstract class _IpRefreshExhaustionStore with Store {
  _IpRefreshExhaustionStore(this._analyticsStore);

  final AnalyticsStore _analyticsStore;

  int _refreshCount = 0;
  bool _noticeShown = false;
  VPNLocation? _location;

  /// Set to the exhausted location when newly exhausted; drives the snackbar.
  @observable
  VPNLocation? exhaustionNotice;

  /// New (non-refresh) connection: reset counters and remember the intended
  /// location (country or city) used for the message and analytics.
  @action
  void onConnected(VPNLocation location) {
    _reset();
    _location = location;
  }

  @action
  void onDisconnected() => _reset();

  void _reset() {
    _location = null;
    _refreshCount = 0;
    _noticeShown = false;
    exhaustionNotice = null;
  }

  /// One successful refresh. [poolCount] is the pool size for the connected
  /// location + IP type. Exhausted once seen IPs (initial + refreshes) cover
  /// the pool: refreshCount >= poolCount - 1.
  @action
  void registerRefresh(int poolCount) {
    _refreshCount++;
    final location = _location;
    if (location == null || _noticeShown || poolCount <= 0) {
      return;
    }
    if (_refreshCount >= poolCount - 1) {
      _noticeShown = true;
      exhaustionNotice = location;
      _analyticsStore.logIpRefreshExhausted(
        location: location,
        nodeCount: poolCount,
        refreshCount: _refreshCount,
      );
    }
  }

  @action
  void clearNotice() {
    exhaustionNotice = null;
  }
}
