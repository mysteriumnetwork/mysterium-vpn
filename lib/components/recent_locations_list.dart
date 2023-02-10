import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/loading_placeholders.dart';
import 'package:mysterium_vpn/components/recent_location_item.dart';
import 'package:mysterium_vpn/stores/locations_store.dart';
import 'package:mysterium_vpn/stores/theme_store.dart';
import 'package:mysterium_vpn/stores/vpn_store.dart';
import 'package:styled_widget/styled_widget.dart';

class RecentLocationsList extends StatelessWidget {
  const RecentLocationsList(
      {Key? key, required this.themeStore, required this.vpnStore, required this.locationsStore})
      : super(key: key);
  final LocationsStore locationsStore;
  final VpnStore vpnStore;
  final ThemeStore themeStore;
  @override
  Widget build(BuildContext context) => Observer(
        builder: (_) {
          if (!locationsStore.hasRecentLocationsResults) {
            return ListView.builder(
                shrinkWrap: true,
                controller: ScrollController(),
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (_, __) => RecentLocationPlaceholder(
                      color: themeStore.currentPalette.placeholderColor,
                    )).height(100);
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
                  onTap: () => vpnStore.connect(location.name),
                );
              }).height(100);
        },
      );
}
