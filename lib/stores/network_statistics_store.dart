// Flutter imports:
// Package imports:

import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/stores/vpn_store.dart';

// Project imports:

part 'network_statistics_store.g.dart';

// ignore: library_private_types_in_public_api
class NetworkStatisticsStore = _NetworkStatisticsStore with _$NetworkStatisticsStore;

abstract class _NetworkStatisticsStore with Store {
  _NetworkStatisticsStore(this._vpnStore, {required this.pollInterval}) {
    // Start the tunnel statistics stream
    _getTunnelStatistics();
  }

  /// How often the counters are sampled. Speeds are derived from the delta
  /// between consecutive samples, so this doubles as the averaging window.
  final Duration pollInterval;

  /// Read through the store rather than a protocol plugin: it owns the active
  /// repository, so statistics follow a WireGuard/OpenVPN switch on their own.
  final VpnStore _vpnStore;
  bool _stopped = false;

  @observable
  double downloadSpeed = 0;
  @observable
  double uploadSpeed = 0;

  @readonly
  TunnelStats? _tunnelStatistics;

  @computed
  DateTime? get latestHandshake => _tunnelStatistics?.latestHandshake;

  @computed
  int get totalDownload => _tunnelStatistics?.totalDownload ?? 0;
  @computed
  int get totalUpload => _tunnelStatistics?.totalUpload ?? 0;
  @computed
  double get totalDownloadInMB => totalDownload / 1000000;

  @computed
  double get totalUploadInMB => totalUpload / 1000000;

  @action
  Future<void> _getTunnelStatistics() async {
    while (!_stopped) {
      await Future.delayed(pollInterval);
      if (_stopped) {
        return;
      }
      try {
        final prevStats = _tunnelStatistics;
        final stats = await _vpnStore.tunnelStatistics();
        final seconds = pollInterval.inMicroseconds / Duration.microsecondsPerSecond;
        if (prevStats != null && stats != null && seconds > 0) {
          uploadSpeed = _mbps(stats.totalUpload - prevStats.totalUpload, seconds);
          downloadSpeed = _mbps(stats.totalDownload - prevStats.totalDownload, seconds);
        }
        _tunnelStatistics = stats;
      } on MissingPluginException {
        // Platform has no implementation; polling will never succeed.
        _stopped = true;
      } catch (_) {
        // Transient failure (e.g. tunnel down mid-poll) — keep polling.
      }
    }
  }

  /// Bytes moved over [seconds], as Mbps. A tunnel restart resets the platform
  /// counters, which would otherwise show up here as a negative rate.
  double _mbps(int byteDelta, double seconds) =>
      byteDelta <= 0 ? 0 : (byteDelta * 8) / 1000000 / seconds;

  void disposeStore() {
    _stopped = true;
  }
}
