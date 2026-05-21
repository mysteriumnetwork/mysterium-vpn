import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/views/settings/setting_category.dart';

part 'home_tabs_store.g.dart';

// ignore: library_private_types_in_public_api
class HomeTabsStore = _HomeTabsStore with _$HomeTabsStore;

abstract class _HomeTabsStore with Store {
  _HomeTabsStore(this._authSessionStore) {
    // Reset on logout only — keep the tab the user picked while unauthed.
    _authReactionDisposer = reaction<bool>((_) => _authSessionStore.isAuthenticated, (
      authenticated,
    ) {
      if (!authenticated) {
        _resetSessionState();
      }
    });
  }

  final AuthSessionStore _authSessionStore;
  late final ReactionDisposer _authReactionDisposer;

  @observable
  HomeTab selected = HomeTab.map;

  /// Set by [openLocationsSearch] so the Locations tab can grab focus once it
  /// mounts; the tab is expected to call [consumePendingLocationsSearchFocus]
  /// after it claims focus.
  @observable
  bool pendingLocationsSearchFocus = false;

  /// Active sub-page inside the Settings tab on mobile. `null` means the
  /// main settings list is shown. Rendered inline so the bottom nav stays
  /// visible (no Navigator push).
  @observable
  SettingCategory? settingsSubPage;

  /// Returns `false` when [tab] requires auth but the user isn't
  /// authenticated; the caller is responsible for the login redirect.
  @action
  bool trySelect(HomeTab tab) {
    if (tab.requiresAuth && !_authSessionStore.isAuthenticated) {
      return false;
    }
    if (selected == tab) {
      return true;
    }
    selected = tab;
    return true;
  }

  @action
  void _resetSessionState() {
    selected = HomeTab.map;
    settingsSubPage = null;
    pendingLocationsSearchFocus = false;
  }

  void dispose() {
    _authReactionDisposer();
  }

  @action
  void openLocationsSearch() {
    selected = HomeTab.locations;
    pendingLocationsSearchFocus = true;
  }

  @action
  void consumePendingLocationsSearchFocus() {
    pendingLocationsSearchFocus = false;
  }

  @action
  void openSettingsSubPage(SettingCategory category) {
    if (settingsSubPage == category) {
      return;
    }
    settingsSubPage = category;
  }

  @action
  void closeSettingsSubPage() {
    settingsSubPage = null;
  }
}
