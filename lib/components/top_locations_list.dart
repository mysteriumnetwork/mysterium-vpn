import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/loading_placeholders.dart';
import 'package:mysterium_vpn/components/location_item.dart';
import 'package:mysterium_vpn/components/retry_widget.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/stores/connectivity_store.dart';
import 'package:mysterium_vpn/stores/locations_store.dart';
import 'package:mysterium_vpn/stores/theme_store.dart';
import 'package:mysterium_vpn/stores/vpn_store.dart';

class TopLocationsList extends StatelessWidget {
  const TopLocationsList({
    required this.themeStore,
    required this.vpnStore,
    required this.locationsStore,
    required this.connectivityStore,
    super.key,
  });
  final LocationsStore locationsStore;
  final VpnStore vpnStore;
  final ThemeStore themeStore;
  final ConnectivityStore connectivityStore;
  @override
  Widget build(BuildContext context) => Observer(
        builder: (_) {
          if (locationsStore.topLocationsFutureStatus == FutureStatus.pending) {
            return ListView.builder(
              controller: ScrollController(),
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (_, int index) => LocationPlaceholder(
                color: Theme.of(context).colorScheme.secondary,
              ),
            );
          }

          if (locationsStore.topLocationsFutureStatus == FutureStatus.rejected) {
            return RetryWdiget(
              asset: Assets.globe,
              onRetry: locationsStore.fetchTopLocations,
              text: LocaleKeys.failedToLoadLocations.tr(),
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
                connectivityStore: connectivityStore,
                onTap: () => vpnStore.connect(location: location),
              );
            },
          );
        },
      );
}
