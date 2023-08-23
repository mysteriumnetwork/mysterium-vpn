import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/loading_placeholders.dart';
import 'package:mysterium_vpn/components/locations_list.dart';
import 'package:mysterium_vpn/components/retry_widget.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/stores/connectivity_store.dart';
import 'package:mysterium_vpn/stores/locations_store.dart';
import 'package:mysterium_vpn/stores/theme_store.dart';
import 'package:mysterium_vpn/stores/vpn_store.dart';
import 'package:styled_widget/styled_widget.dart';

class AllLocationsList extends StatelessWidget {
  const AllLocationsList({
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
  Widget build(BuildContext context) => Observer(
        builder: (_) {
          if (locationsStore.vpnLocationsFutureStatus == FutureStatus.pending) {
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (_, int index) => LocationPlaceholder(
                color: Theme.of(context).colorScheme.secondary,
              ),
            );
          }

          if (locationsStore.vpnLocationsFutureStatus == FutureStatus.rejected) {
            return RetryWdiget(
              asset: Assets.globe,
              onRetry: locationsStore.fetchVPNLocations,
              text: LocaleKeys.failedToLoadLocations.tr(),
            );
          }
          final topLocations = locationsStore.vpnLocations.topLocations;
          final allLocations = locationsStore.vpnLocations.allLocations;
          if (topLocations.isEmpty && allLocations.isEmpty) {
            return EasyText(
              LocaleKeys.coudntFindLocations.tr(
                namedArgs: {
                  'searchKeyword': locationsStore.searchKeyword,
                },
              ),
              color: Theme.of(context).colorScheme.error,
            );
          }

          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              if (topLocations.isNotEmpty)
                LocationsList(
                  locations: topLocations,
                  vpnStore: vpnStore,
                  connectivityStore: connectivityStore,
                ),
              if (topLocations.isNotEmpty && allLocations.isNotEmpty)
                const Divider(thickness: 0.5, color: Palette.lightBlue)
                    .padding(bottom: 10, horizontal: 25),
              if (allLocations.isNotEmpty)
                LocationsList(
                  locations: allLocations,
                  vpnStore: vpnStore,
                  connectivityStore: connectivityStore,
                ),
            ],
          );
        },
      );
}
