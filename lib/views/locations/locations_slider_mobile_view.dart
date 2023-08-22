import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/recent_locations_list.dart';
import 'package:mysterium_vpn/components/search_field.dart';
import 'package:mysterium_vpn/components/vpn_locations.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:sliding_up_panel2/sliding_up_panel2.dart';
import 'package:styled_widget/styled_widget.dart';

class LocationsSliderMobileView extends HookConsumerWidget {
  const LocationsSliderMobileView({required this.sc, required this.pc, super.key});
  final ScrollController sc;
  final PanelController pc;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationsStore = ref.watch(locationsStorePOD);
    final vpnStore = ref.watch(vpnStorePOD);
    final themeStore = ref.watch(themeStorePOD);
    final connectivityStore = ref.watch(connectivityStorePOD);

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView(
        physics: PanelScrollPhysics(controller: pc),
        controller: sc,
        children: <Widget>[
          Align(
            child: Container(
              width: 30,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ).padding(bottom: 10, top: 10),
          SearchField(locationsStore).padding(bottom: 20),
          RecentLocationsList(
            themeStore: themeStore,
            locationsStore: locationsStore,
            vpnStore: vpnStore,
            connectivityStore: connectivityStore,
          ).padding(bottom: 20),
          EasyText(
            LocaleKeys.allLocations.tr(),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ).padding(bottom: 20),
          AllLocationsList(
            themeStore: themeStore,
            locationsStore: locationsStore,
            vpnStore: vpnStore,
            connectivityStore: connectivityStore,
          )
        ],
      ).paddingDirectional(horizontal: 20),
    );
  }
}
