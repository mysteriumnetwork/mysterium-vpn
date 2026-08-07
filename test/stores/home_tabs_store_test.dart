import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/views/settings/setting_category.dart';

import 'home_tabs_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AuthSessionStore>(),
  MockSpec<AnalyticsStore>(),
  MockSpec<SubscriptionStore>(),
  MockSpec<LocationsQueryStore>(),
])
void main() {
  late HomeTabsStore store;
  late MockAuthSessionStore authSessionStore;
  late MockAnalyticsStore analyticsStore;
  late MockSubscriptionStore subscriptionStore;
  late MockLocationsQueryStore locationsQueryStore;
  late Observable<bool> isAuthenticatedSignal;

  HomeTabsStore build() => HomeTabsStore(
    authSessionStore,
    analyticsStore: analyticsStore,
    subscriptionStore: subscriptionStore,
    locationsQueryStore: locationsQueryStore,
  );

  setUp(() {
    authSessionStore = MockAuthSessionStore();
    analyticsStore = MockAnalyticsStore();
    subscriptionStore = MockSubscriptionStore();
    locationsQueryStore = MockLocationsQueryStore();
    // Back the mock with a real Observable so MobX reactions inside the
    // store fire when the auth flag flips.
    isAuthenticatedSignal = Observable(false);
    when(authSessionStore.isAuthenticated).thenAnswer((_) => isAuthenticatedSignal.value);
    when(subscriptionStore.productsScreenVariant).thenReturn(ProductsScreenVariant.defaultUpgrade);
    when(locationsQueryStore.searchTrimmed).thenReturn('');
    store = build();
  });

  group('HomeTabsStore.trySelect', () {
    test('defaults to map tab', () {
      expect(store.selected, HomeTab.map);
    });

    test('selects a non-auth-gated tab and returns true', () {
      expect(store.trySelect(HomeTab.locations), isTrue);
      expect(store.selected, HomeTab.locations);
    });

    test('blocks an auth-gated tab when unauthenticated and returns false', () {
      // Products requires auth in HomeTab.products.
      expect(HomeTab.products.requiresAuth, isTrue);
      expect(store.trySelect(HomeTab.products), isFalse);
      expect(store.selected, HomeTab.map);
    });

    test('allows an auth-gated tab when authenticated', () {
      when(authSessionStore.isAuthenticated).thenReturn(true);
      expect(store.trySelect(HomeTab.products), isTrue);
      expect(store.selected, HomeTab.products);
    });

    test('returns true and does not change selection when re-selecting same tab', () {
      store.trySelect(HomeTab.settings);
      expect(store.trySelect(HomeTab.settings), isTrue);
      expect(store.selected, HomeTab.settings);
    });

    test('preserves settingsSubPage across tab switches', () {
      // The current behavior is that the sub-page persists when the user
      // leaves the Settings tab and comes back. Lock it in.
      store
        ..openSettingsSubPage(SettingCategory.account)
        ..trySelect(HomeTab.map);
      expect(store.settingsSubPage, SettingCategory.account);
      store.trySelect(HomeTab.settings);
      expect(store.settingsSubPage, SettingCategory.account);
    });
  });

  group('HomeTabsStore.openLocationsSearch', () {
    test('switches to Locations tab and raises the pending-focus flag', () {
      expect(store.pendingLocationsSearchFocus, isFalse);

      store.openLocationsSearch();

      expect(store.selected, HomeTab.locations);
      expect(store.pendingLocationsSearchFocus, isTrue);
    });

    test('consumePendingLocationsSearchFocus clears the flag', () {
      store.openLocationsSearch();
      expect(store.pendingLocationsSearchFocus, isTrue);

      store.consumePendingLocationsSearchFocus();

      expect(store.pendingLocationsSearchFocus, isFalse);
      // Tab selection is unaffected.
      expect(store.selected, HomeTab.locations);
    });
  });

  group('HomeTabsStore.openFavoriteLocations', () {
    test('shows the Locations tab with Favourites selected', () {
      store.openFavoriteLocations();

      expect(store.selected, HomeTab.locations);
      verify(locationsQueryStore.selectTab(LocationsTab.favorite)).called(1);
    });
  });

  group('HomeTabsStore.settingsSubPage', () {
    test('starts null', () {
      expect(store.settingsSubPage, isNull);
    });

    test('openSettingsSubPage sets the active category', () {
      store.openSettingsSubPage(SettingCategory.connection);
      expect(store.settingsSubPage, SettingCategory.connection);
    });

    test('closeSettingsSubPage resets to null', () {
      store
        ..openSettingsSubPage(SettingCategory.preferences)
        ..closeSettingsSubPage();
      expect(store.settingsSubPage, isNull);
    });

    test('re-opening the same category is a no-op', () {
      store
        ..openSettingsSubPage(SettingCategory.account)
        // Setting again should not change the value (guarded by ==).
        ..openSettingsSubPage(SettingCategory.account);
      expect(store.settingsSubPage, SettingCategory.account);
    });
  });

  group('HomeTabsStore auth reset', () {
    test('does NOT reset on login (false -> true) so the user keeps the tab they were on', () {
      store
        ..openSettingsSubPage(SettingCategory.account)
        ..openLocationsSearch();
      expect(store.selected, HomeTab.locations);
      expect(store.settingsSubPage, SettingCategory.account);

      runInAction(() => isAuthenticatedSignal.value = true);

      // Tab + sub-page survive the login transition.
      expect(store.selected, HomeTab.locations);
      expect(store.settingsSubPage, SettingCategory.account);
    });

    test('resets selected tab, sub-page and focus flag on logout (true -> false)', () {
      runInAction(() => isAuthenticatedSignal.value = true);
      store
        ..trySelect(HomeTab.products)
        ..openSettingsSubPage(SettingCategory.connection)
        ..openLocationsSearch();
      expect(store.selected, HomeTab.locations);

      runInAction(() => isAuthenticatedSignal.value = false);

      expect(store.selected, HomeTab.map);
      expect(store.settingsSubPage, isNull);
      expect(store.pendingLocationsSearchFocus, isFalse);
    });
  });

  group('HomeTabsStore tab-view analytics', () {
    test('fires map_tab_viewed on construction (default tab)', () {
      verify(analyticsStore.logMapTabViewed()).called(1);
    });

    test('fires settings_tab_viewed when settings is selected', () {
      clearInteractions(analyticsStore);
      store.trySelect(HomeTab.settings);
      verify(analyticsStore.logSettingsTabViewed()).called(1);
    });

    test('fires locations_tab_viewed when locations is selected', () {
      clearInteractions(analyticsStore);
      store.trySelect(HomeTab.locations);
      verify(analyticsStore.logLocationsTabViewed()).called(1);
    });

    test('does not re-fire when re-selecting the same tab', () {
      store.trySelect(HomeTab.settings);
      clearInteractions(analyticsStore);
      store.trySelect(HomeTab.settings);
      verifyNever(analyticsStore.logSettingsTabViewed());
    });

    test(
      'fires products_tab_viewed (redirected_to_login: false, with variant) when products opens',
      () {
        when(authSessionStore.isAuthenticated).thenReturn(true);
        clearInteractions(analyticsStore);
        store.trySelect(HomeTab.products);
        verify(
          analyticsStore.logProductsTabViewed(
            redirectedToLogin: false,
            variant: ProductsScreenVariant.defaultUpgrade,
          ),
        ).called(1);
      },
    );

    test('does NOT fire products view while variant is loading', () {
      when(authSessionStore.isAuthenticated).thenReturn(true);
      when(subscriptionStore.productsScreenVariant).thenReturn(ProductsScreenVariant.loading);
      store = build();
      clearInteractions(analyticsStore);
      store.trySelect(HomeTab.products);
      verifyNever(
        analyticsStore.logProductsTabViewed(
          redirectedToLogin: anyNamed('redirectedToLogin'),
          variant: anyNamed('variant'),
        ),
      );
    });

    test('fires products_tab_viewed (redirected_to_login: true) when blocked by auth', () {
      clearInteractions(analyticsStore);
      expect(store.trySelect(HomeTab.products), isFalse);
      verify(analyticsStore.logProductsTabViewed(redirectedToLogin: true)).called(1);
    });

    test('openLocationsSearch fires map_search_redirected_to_locations with query flags', () {
      when(locationsQueryStore.searchTrimmed).thenReturn('berlin');
      clearInteractions(analyticsStore);
      store.openLocationsSearch();
      verify(
        analyticsStore.logMapSearchRedirectedToLocations(queryEntered: true, queryPreserved: true),
      ).called(1);
    });
  });
}
