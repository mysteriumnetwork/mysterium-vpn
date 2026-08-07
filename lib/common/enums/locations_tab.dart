import 'package:mysterium_vpn/common/enums/enums.dart';

/// Tabs of the Locations list. The first two mirror [IPType]; favorite is a
/// view-level tab with no backend counterpart.
enum LocationsTab {
  datacenter,
  residential,
  favorite;

  static LocationsTab fromIPType(IPType type) =>
      type == IPType.datacenter ? LocationsTab.datacenter : LocationsTab.residential;

  /// The [IPType] this tab maps to, or null for [favorite].
  IPType? get ipType => switch (this) {
    LocationsTab.datacenter => IPType.datacenter,
    LocationsTab.residential => IPType.residential,
    LocationsTab.favorite => null,
  };
}
