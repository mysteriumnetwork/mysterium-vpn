import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/components/location_item.dart';
import 'package:mysterium_vpn/stores/vpn_store.dart';

class LocationsList extends HookWidget {
  const LocationsList({
    required this.locations,
    required this.vpnStore,
    super.key,
  });
  final List<String> locations;
  final VpnStore vpnStore;
  @override
  Widget build(BuildContext context) {
    final sc = useScrollController();
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      controller: sc,
      itemCount: locations.length,
      itemBuilder: (_, int index) {
        final location = locations[index];

        return LocationItem(
          location: location,
          vpnStore: vpnStore,
          onTap: () => vpnStore.toggleConnection(location: location),
        );
      },
    );
  }
}
