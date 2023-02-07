import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/recent_location_item.dart';
import 'package:mysterium_vpn/stores/locations_store.dart';
import 'package:styled_widget/styled_widget.dart';

class RecentLocationsList extends StatelessWidget {
  const RecentLocationsList({Key? key, required this.locationsStore}) : super(key: key);
  final LocationsStore locationsStore;

  @override
  Widget build(BuildContext context) => Observer(
        builder: (_) {
          if (!locationsStore.hasRecentLocationsResults) {
            return Container();
          }
          if (locationsStore.recentLocations.isEmpty) {
            return EasyText(
              'We could not find any recent locations for keyword: ${locationsStore.searchKeyword} ',
              color: Theme.of(context).colorScheme.error,
            );
          }

          return ListView.builder(
              shrinkWrap: true,
              controller: ScrollController(),
              scrollDirection: Axis.horizontal,
              itemCount: locationsStore.recentLocations.length,
              itemBuilder: (_, int index) {
                final location = locationsStore.recentLocations[index];

                return RecentLocationItem(
                  location: location,
                  onPressed: () {},
                );
              }).height(100);
        },
      );
}
