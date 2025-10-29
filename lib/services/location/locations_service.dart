import 'package:collection/collection.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/location/ping.dart';
import 'package:vpn_api/vpn_api.dart';

class LocationsService {
  const LocationsService(this._connectionAPI);

  final Connection _connectionAPI;

  /// Finds the closest VPN location from the provided list based on the user's network latency.
  /// Optionally filters locations by IP type (datacenter or residential).
  /// Returns null if no locations are available or if no regions can be determined.
  /// This method is useful for selecting the optimal VPN server for the user based on network performance
  Future<VPNLocation?> closestLocation(List<VPNLocation> data, {IPType? type}) async {
    final closestRegion = await this.closestRegion(type);

    if (closestRegion == null) {
      return null;
    }

    final closestLocations = closestRegion.topCountries
        .map((it) => data.firstWhereOrNull((location) => location.id == it))
        .nonNulls
        .toList();

    if (closestLocations.isEmpty) {
      return null;
    }

    return closestLocations.randomItem();
  }

  /// Determines the closest connection region by pinging known hosts and measuring latency.
  /// Optionally filters regions by IP type (datacenter or residential).
  /// Returns null if no regions are available.
  /// This method is useful for selecting the optimal server region for the user based on network performance.
  Future<ConnectionRegion?> closestRegion([IPType? type]) async {
    final connectionConfigRegions = (await _connectionAPI.connectionConfigRegions(
      ipType: switch (type) {
        IPType.datacenter => 'hosting',
        IPType.residential => 'residential',
        _ => null,
      },
    ))
        .data!;
    if (connectionConfigRegions.regions.isEmpty) {
      return null;
    }

    return _detectClosestRegion(connectionConfigRegions.regions);
  }

  /// Detects the closest connection region by pinging each region's host and measuring latency.
  /// Returns the region with the lowest median latency.
  /// This method is useful for optimizing server selection based on network performance.
  Future<ConnectionRegion> _detectClosestRegion(List<ConnectionRegion> regions) async {
    // Ensures all pings complete before finding the lowest latency
    final regionsWithLatencies = await Future.wait(
      regions.map((region) async {
        final ping = Ping(region.host, 80);
        return _RegionWithLatency(region, await ping.latencyMedian());
      }),
    );

    // Find region with lowest latency
    final region = regionsWithLatencies.reduce((a, b) => a.latency < b.latency ? a : b);
    return region.region;
  }
}

class _RegionWithLatency {
  const _RegionWithLatency(this.region, this.latency);

  final ConnectionRegion region;
  final Duration latency;
}
