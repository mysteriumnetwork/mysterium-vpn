import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/location_item.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/stores/locations_store.dart';
import 'package:styled_widget/styled_widget.dart';

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
                'We could not find any locations for keyword: ${locationsStore.searchKeyword} ');
          }

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  EasyText(
                    LocaleKeys.top_locations.tr(),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  EasyText(LocaleKeys.browse_all.tr())
                ],
              ).padding(bottom: 20),
              ListView.separated(
                  shrinkWrap: true,
                  itemCount: locationsStore.locations.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 10);
                  },
                  itemBuilder: (_, int index) {
                    final location = locationsStore.locations[index];

                    return LocationItem(
                      location: location,
                      onPressed: () {},
                    );
                  }).expanded(),
            ],
          );
        },
      ).expanded();
}
