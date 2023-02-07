import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/location_item.dart';
import 'package:mysterium_vpn/stores/locations_store.dart';

class TopLocationsList extends StatelessWidget {
  const TopLocationsList({Key? key, required this.locationsStore}) : super(key: key);
  final LocationsStore locationsStore;
  @override
  Widget build(BuildContext context) => Observer(
        builder: (_) {
          if (!locationsStore.hasLocationsResults) {
            return const SizedBox.shrink();
          }

          if (locationsStore.locations.isEmpty) {
            return EasyText(
              'We could not find any locations for keyword: ${locationsStore.searchKeyword}',
              color: Theme.of(context).colorScheme.error,
            );
          }

          return ListView.builder(
              controller: ScrollController(),
              shrinkWrap: true,
              itemCount: locationsStore.locations.length,
              itemBuilder: (_, int index) {
                final location = locationsStore.locations[index];

                return LocationItem(
                  location: location,
                  onPressed: () {},
                );
              });
        },
      );
}
