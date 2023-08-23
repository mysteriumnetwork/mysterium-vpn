import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/recent_location_item.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/stores/connectivity_store.dart';
import 'package:mysterium_vpn/stores/locations_store.dart';
import 'package:mysterium_vpn/stores/theme_store.dart';
import 'package:mysterium_vpn/stores/vpn_store.dart';
import 'package:styled_widget/styled_widget.dart';

class RecentLocationsList extends HookWidget {
  const RecentLocationsList({
    required this.themeStore,
    required this.vpnStore,
    required this.locationsStore,
    required this.connectivityStore,
    super.key,
  });
  final LocationsStore locationsStore;
  final ConnectivityStore connectivityStore;
  final VpnStore vpnStore;
  final ThemeStore themeStore;
  @override
  Widget build(BuildContext context) {
    final sc = useScrollController();
    return Observer(
      builder: (_) => Visibility(
        visible: locationsStore.recentLocations.isNotEmpty && locationsStore.searchKeyword.isEmpty,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EasyText(
              LocaleKeys.recentLocations.tr(),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ).padding(bottom: 10),
            ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              controller: sc,
              scrollDirection: Axis.horizontal,
              itemCount: locationsStore.recentLocations.length,
              itemBuilder: (_, int index) {
                final location = locationsStore.recentLocations[index];

                return RecentLocationItem(
                  location: location,
                  vpnStore: vpnStore,
                  onTap: () => vpnStore.connect(location: location),
                  connectivityStore: connectivityStore,
                );
              },
            ).height(130),
          ],
        ),
      ),
    );
  }
}
