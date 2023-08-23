import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/recent_locations_list.dart';
import 'package:mysterium_vpn/components/search_field.dart';
import 'package:mysterium_vpn/components/vpn_locations.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/home_desktop_app_bar.dart';
import 'package:styled_widget/styled_widget.dart';

class HomeDesktopLeftPanel extends ConsumerWidget {
  const HomeDesktopLeftPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationsStore = ref.read(locationsStorePOD);
    final themeStore = ref.read(themeStorePOD);
    final vpnStore = ref.read(vpnStorePOD);
    final connectivityStore = ref.watch(connectivityStorePOD);
    return Container(
      color: Theme.of(context).primaryColor,
      width: double.infinity,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        children: [
          const HomeDesktopAppBar(),
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
          ).padding(bottom: 10),
          AllLocationsList(
            themeStore: themeStore,
            locationsStore: locationsStore,
            vpnStore: vpnStore,
            connectivityStore: connectivityStore,
          ),
        ],
      ),
    );
  }
}
