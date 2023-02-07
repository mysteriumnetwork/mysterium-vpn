import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/recent_locations_list.dart';
import 'package:mysterium_vpn/components/search_field.dart';
import 'package:mysterium_vpn/components/top_locations_list.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:styled_widget/styled_widget.dart';

class LocationsSliderMobileView extends HookConsumerWidget {
  const LocationsSliderMobileView({required this.sc, Key? key}) : super(key: key);
  final ScrollController sc;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationsStore = ref.watch(locationsStorePOD);
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          controller: sc,
          children: <Widget>[
            Align(
              child: Container(
                width: 30,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.all(Radius.circular(12.0))),
              ),
            ).padding(bottom: 10, top: 10),
            SearchField(locationsStore).padding(bottom: 20),
            EasyText(
              LocaleKeys.recent_locations.tr(),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ).padding(bottom: 20),
            RecentLocationsList(
              locationsStore: locationsStore,
            ).padding(bottom: 20),
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
            TopLocationsList(
              locationsStore: locationsStore,
            ),
          ],
        ).paddingDirectional(horizontal: 20));
  }
}
