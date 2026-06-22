import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/views/settings/setting_category.dart';

part 'home_tabs_store.g.dart';

// ignore: library_private_types_in_public_api
class HomeTabsStore = _HomeTabsStore with _$HomeTabsStore;

abstract class _HomeTabsStore with Store {
  _HomeTabsStore(
    this._authSessionStore, {
    required AnalyticsStore analyticsStore,
    required SubscriptionStore subscriptionStore,
    required LocationsQueryStore locationsQueryStore,
  }) : _analyticsStore = analyticsStore,
       _subscriptionStore = subscriptionStore,
       _locationsQueryStore = locationsQueryStore {
    // Reset on logout only — keep the tab the user picked while unauthed.
    _authReactionDisposer = reaction<bool>((_) => _authSessionStore.isAuthenticated, (
      authenticated,
    ) {
      if (!authenticated) {
        _resetSessionState();
      }
    });

    // Fire *_tab_viewed for map/locations/settings on selection. fireImmediately
    // captures the default Map render at construction. Products is handled by
    // the variant reaction below (it needs the settled screen variant).
    _tabViewReactionDisposer = reaction<HomeTab>(
      (_) => selected,
      _logTabViewed,
      fireImmediately: true,
    );

    // Fire products_tab_viewed once the variant settles to a non-loading value
    // while Products is selected. Null (not selected, or still loading) => no fire.
    _productsViewReactionDisposer = reaction<ProductsScreenVariant?>(
      (_) {
        if (selected != HomeTab.products) {
          return null;
        }
        final variant = _subscriptionStore.productsScreenVariant;
        return variant == ProductsScreenVariant.loading ? null : variant;
      },
      (variant) {
        if (variant != null) {
          _analyticsStore.logProductsTabViewed(redirectedToLogin: false, variant: variant);
        }
      },
    );
  }

  final AuthSessionStore _authSessionStore;
  final AnalyticsStore _analyticsStore;
  final SubscriptionStore _subscriptionStore;
  final LocationsQueryStore _locationsQueryStore;

  late final ReactionDisposer _authReactionDisposer;
  late final ReactionDisposer _tabViewReactionDisposer;
  late final ReactionDisposer _productsViewReactionDisposer;

  void _logTabViewed(HomeTab tab) {
    switch (tab) {
      case HomeTab.map:
        _analyticsStore.logMapTabViewed();
      case HomeTab.locations:
        _analyticsStore.logLocationsTabViewed();
      case HomeTab.settings:
        _analyticsStore.logSettingsTabViewed();
      case HomeTab.products:
        break; // handled by _productsViewReactionDisposer
    }
  }

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
      // The auth gate blocks Products; the caller redirects to login. Log it as
      // a Products view with no rendered variant (the screen never mounts).
      if (tab == HomeTab.products) {
        _analyticsStore.logProductsTabViewed(redirectedToLogin: true);
      }
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
    _tabViewReactionDisposer();
    _productsViewReactionDisposer();
  }

  @action
  void openLocationsSearch() {
    // Pre-existing query state: whether the user already had a search before the
    // redirect, and (since the store persists it across the tab switch) whether
    // it's preserved into Locations. See the design spec for query semantics.
    final hadQuery = _locationsQueryStore.searchTrimmed.isNotEmpty;
    _analyticsStore.logMapSearchRedirectedToLocations(
      queryEntered: hadQuery,
      queryPreserved: hadQuery,
    );
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
