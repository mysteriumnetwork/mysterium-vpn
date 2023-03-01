import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/loading_placeholders.dart';
import 'package:mysterium_vpn/components/location_item.dart';
import 'package:mysterium_vpn/stores/locations_store.dart';
import 'package:mysterium_vpn/stores/theme_store.dart';
import 'package:mysterium_vpn/stores/vpn_store.dart';

class TopLocationsList extends StatelessWidget {
  const TopLocationsList({
    required this.themeStore,
    required this.vpnStore,
    required this.locationsStore,
    super.key,
  });
  final LocationsStore locationsStore;
  final VpnStore vpnStore;
  final ThemeStore themeStore;
  @override
  Widget build(BuildContext context) => Observer(
        builder: (_) {
          if (!locationsStore.hasTopLocationsResults) {
            return ListView.builder(
              controller: ScrollController(),
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (_, int index) => LocationPlaceholder(
                color: Theme.of(context).colorScheme.secondary,
              ),
            );
          }

          if (locationsStore.topLocations.isEmpty) {
            return EasyText(
              'We could not find any locations for keyword: ${locationsStore.searchTopKeyword}',
              color: Theme.of(context).colorScheme.error,
            );
          }

          return ListView.builder(
            controller: ScrollController(),
            shrinkWrap: true,
            itemCount: locationsStore.topLocations.length,
            itemBuilder: (_, int index) {
              final location = locationsStore.topLocations[index];

              return LocationItem(
                location: location,
                vpnStore: vpnStore,
                onTap: () => vpnStore.connect(location: location),
              );
            },
          );
        },
      );
}
