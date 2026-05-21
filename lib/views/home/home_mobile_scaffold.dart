import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/tabs/home_locations_tab.dart';
import 'package:mysterium_vpn/views/home/tabs/home_map_tab.dart';
import 'package:mysterium_vpn/views/home/tabs/home_products_tab/home_products_tab.dart';
import 'package:mysterium_vpn/views/settings/settings_mobile_view.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class HomeMobileScaffold extends HookConsumerWidget {
  const HomeMobileScaffold({super.key});

  static Widget _pageFor(HomeTab tab) => switch (tab) {
    HomeTab.map => const HomeMapTab(),
    HomeTab.locations => const HomeLocationsTab(),
    HomeTab.products => const HomeProductsTab(),
    HomeTab.settings => const SettingsMobileView(),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(homeTabsStorePOD);
    final selected = useComputedValue(() => store.selected);
    final settingsSubPage = useComputedValue(() => store.settingsSubPage);

    final tabs = HomeTab.mobileTabs();
    final selectedIndex = tabs.indexOf(selected).clamp(0, tabs.length - 1);
    final inSettingsSubPage = selected == HomeTab.settings && settingsSubPage != null;

    return PopScope(
      canPop: !inSettingsSubPage,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && inSettingsSubPage) {
          store.closeSettingsSubPage();
        }
      },
      child: Column(
        children: [
          _MobileTabHeader(
            tab: selected,
            onBack: inSettingsSubPage ? store.closeSettingsSubPage : null,
          ),
          Expanded(
            child: IndexedStack(
              index: selectedIndex,
              children: [for (final tab in tabs) _pageFor(tab)],
            ),
          ),
          BottomNavBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: (i) {
              if (!store.trySelect(tabs[i])) {
                Beamer.of(context).beamToNamed(Routes.platformLogin.path);
              }
            },
            items: [for (final tab in tabs) BottomNavBarItem(icon: tab.icon, label: tab.label())],
          ),
        ],
      ),
    );
  }
}

class _MobileTabHeader extends StatelessWidget {
  const _MobileTabHeader({required this.tab, this.onBack});

  final HomeTab tab;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    const actions = [HelpSupportIconButton()];
    final theme = Theme.of(context);

    if (onBack != null) {
      return Header(
        backgroundColor: theme.palette.bgSidePanel,
        backLabel: LocaleKeys.backToSettingsLbl.tr(),
        showBackButton: true,
        onBackPressed: onBack,
      );
    }

    if (tab == HomeTab.map) {
      return Header.logo(showBackButton: false, actions: actions);
    }

    return Header(
      showBackButton: false,
      backgroundColor: theme.palette.bgSidePanel,
      title: Text(
        tab.label(),
        style: theme.textStyles.displayXlg.semibold.copyWith(
          color: theme.palette.textPrimary,
          fontSize: 24,
          height: 28 / 24,
        ),
      ),
      actions: actions,
    );
  }
}
