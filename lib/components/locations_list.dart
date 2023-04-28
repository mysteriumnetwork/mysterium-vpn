import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/location_item.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/stores/connectivity_store.dart';
import 'package:mysterium_vpn/stores/vpn_store.dart';

class LocationsList extends StatelessWidget {
  const LocationsList({
    required this.locations,
    required this.vpnStore,
    required this.connectivityStore,
    super.key,
  });
  final List<Location> locations;
  final VpnStore vpnStore;
  final ConnectivityStore connectivityStore;
  @override
  Widget build(BuildContext context) => ListView.builder(
        controller: ScrollController(),
        shrinkWrap: true,
        itemCount: locations.length,
        itemBuilder: (_, int index) {
          final location = locations[index];

          return LocationItem(
            location: location,
            vpnStore: vpnStore,
            connectivityStore: connectivityStore,
            onTap: () => vpnStore.connect(location: location),
          );
        },
      );
}
