import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/all_locations_list.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/recent_locations_list.dart';
import 'package:mysterium_vpn/components/search_field.dart';
import 'package:mysterium_vpn/components/top_locations_list.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:styled_widget/styled_widget.dart';

class LocationsSliderMobileView extends HookConsumerWidget {
  const LocationsSliderMobileView({required this.sc, super.key});
  final ScrollController sc;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationsStore = ref.watch(locationsStorePOD);
    final vpnStore = ref.watch(vpnStorePOD);
    final themeStore = ref.watch(themeStorePOD);
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Observer(
        builder: (context) {
          final showAllLocations = locationsStore.showAllLocations;
          return ListView(
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
              if (!showAllLocations) ...[
                EasyText(
                  LocaleKeys.recentLocations.tr(),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ).padding(bottom: 20),
                RecentLocationsList(
                  themeStore: themeStore,
                  locationsStore: locationsStore,
                  vpnStore: vpnStore,
                ).padding(bottom: 20),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  EasyText(
                    showAllLocations
                        ? LocaleKeys.all_locations.tr()
                        : LocaleKeys.top_locations.tr(),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  TextButton(
                    onPressed: locationsStore.toggleShowAllLocations,
                    child: EasyText(
                      locationsStore.showAllLocations
                          ? LocaleKeys.browseTop.tr()
                          : LocaleKeys.browseAll.tr(),
                      color: Palette.pink,
                    ),
                  ),
                ],
              ).padding(bottom: 20),
              if (showAllLocations)
                AllLocationsList(
                  themeStore: themeStore,
                  locationsStore: locationsStore,
                  vpnStore: vpnStore,
                )
              else
                TopLocationsList(
                  locationsStore: locationsStore,
                  vpnStore: vpnStore,
                  themeStore: themeStore,
                )
            ],
          ).paddingDirectional(horizontal: 20);
        },
      ),
    );
  }
}
