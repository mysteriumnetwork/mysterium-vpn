import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/recent_location_item.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/stores/locations_store.dart';
import 'package:styled_widget/styled_widget.dart';

class RecentLocationsList extends StatelessWidget {
  const RecentLocationsList({Key? key, required this.sc, required this.locationsStore})
      : super(key: key);
  final LocationsStore locationsStore;
  final ScrollController sc;

  @override
  Widget build(BuildContext context) => Observer(
        builder: (_) {
          if (!locationsStore.hasRecentLocationsResults) {
            return Container();
          }
          if (locationsStore.recentLocations.isEmpty) {
            return EasyText(
                'We could not find any recent locations for keyword: ${locationsStore.searchKeyword} ');
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  EasyText(
                    LocaleKeys.recent_locations.tr(),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  EasyText(LocaleKeys.history.tr())
                ],
              ).padding(bottom: 20),
              ListView.builder(
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
                  }).height(100),
            ],
          );
        },
      );
}
