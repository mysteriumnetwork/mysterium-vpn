import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

enum HomeTab {
  map(icon: UntitledUI.map_01, mobileOnly: false, requiresAuth: false),
  locations(icon: UntitledUI.flag_01, mobileOnly: true, requiresAuth: false),
  products(icon: UntitledUI.star_06, mobileOnly: false, requiresAuth: true),
  settings(icon: UntitledUI.settings_01, mobileOnly: false, requiresAuth: false);

  const HomeTab({required this.icon, required this.mobileOnly, required this.requiresAuth});

  final IconData icon;

  /// True when this tab is rendered only on mobile (e.g. Locations, which is
  /// merged into the Map tab on desktop).
  final bool mobileOnly;

  /// True when the tab is gated behind authentication — unauthenticated users
  /// who tap it are redirected to the login route instead.
  final bool requiresAuth;

  String label() => switch (this) {
    HomeTab.map => LocaleKeys.navMap.tr(),
    HomeTab.locations => LocaleKeys.navLocations.tr(),
    HomeTab.products => LocaleKeys.navProducts.tr(),
    HomeTab.settings => LocaleKeys.settings.tr(),
  };

  /// URL path that targets this tab via deep links (push notifications,
  /// campaign redirects, etc.). On platforms where the tab isn't surfaced
  /// (Locations on desktop), the scaffold clamps to the first available
  /// tab — see `HomeMobileScaffold` / `HomeDesktopScaffold`.
  String get path => switch (this) {
    HomeTab.map => '/map',
    HomeTab.locations => '/locations',
    HomeTab.products => '/products',
    HomeTab.settings => '/settings',
  };

  /// Returns the [HomeTab] for [path] or `null` when no tab matches.
  static HomeTab? fromPath(String path) => HomeTab.values.firstWhereOrNull((t) => t.path == path);

  static List<HomeTab> mobileTabs() => HomeTab.values;
  static List<HomeTab> desktopTabs() =>
      HomeTab.values.where((t) => !t.mobileOnly).toList(growable: false);
}
