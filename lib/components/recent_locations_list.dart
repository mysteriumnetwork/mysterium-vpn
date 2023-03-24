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
  const RecentLocationsList({
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
          if (!locationsStore.hasRecentLocationsResults) {
            return ListView.builder(
              shrinkWrap: true,
              controller: ScrollController(),
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (_, __) => RecentLocationPlaceholder(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ).height(110);
          }
          if (locationsStore.recentLocations.isEmpty) {
            return EasyText(
              locationsStore.searchTopKeyword.isNotEmpty
                  ? 'We could not find any recent locations for keyword: ${locationsStore.searchTopKeyword} '
                  : 'Recent locations will appear here',
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
                vpnStore: vpnStore,
                onTap: () async => vpnStore.connect(location: location),
              );
            },
          ).height(110);
        },
      );
}
