// Flutter imports:
// Package imports:

import 'package:mobx/mobx.dart';
import 'package:wireguard_dart/wireguard_dart.dart';

// Project imports:

part 'network_statistics_store.g.dart';

// ignore: library_private_types_in_public_api
class NetworkStatisticsStore = _NetworkStatisticsStore with _$NetworkStatisticsStore;

abstract class _NetworkStatisticsStore with Store {
  _NetworkStatisticsStore(
    this._wireguardService,
  ) {
    // Start the tunnel statistics stream
    _getTunnelStatistics();
  }

  final WireguardDart _wireguardService;

  @observable
  double downloadSpeed = 0;
  @observable
  double uploadSpeed = 0;

  @readonly
  TunnelStatistics? _tunnelStatistics;

  @computed
  DateTime? get latestHandshake {
    if (_tunnelStatistics == null) {
      return null;
    }

    return DateTime.fromMillisecondsSinceEpoch(_tunnelStatistics!.latestHandshake).toLocal();
  }

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
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      final prevStats = _tunnelStatistics;
      final stats = await _wireguardService.getTunnelStatistics();
      if (prevStats != null && stats != null) {
        uploadSpeed =
            ((stats.totalUpload - prevStats.totalUpload) * 8) / 1000000; // Convert to Mbps
        downloadSpeed =
            ((stats.totalDownload - prevStats.totalDownload) * 8) / 1000000; // Convert to Mbps
      }
      _tunnelStatistics = stats;
    }
  }
}
