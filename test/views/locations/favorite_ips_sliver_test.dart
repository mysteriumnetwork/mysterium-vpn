import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/views/locations/components/components.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/test_localizations.dart';
import 'favorite_ips_sliver_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FavoriteIpsStore>(),
  MockSpec<AnalyticsStore>(),
  MockSpec<VpnStore>(),
  MockSpec<ConnectionDisplayStore>(),
  MockSpec<LocationsStore>(),
  MockSpec<BannersStore>(),
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFavoriteIpsStore store;
  late MockAnalyticsStore analytics;
  late MockVpnStore vpnStore;
  late MockConnectionDisplayStore displayStore;
  late MockLocationsStore locationsStore;
  late MockBannersStore bannersStore;

  FavoriteIp fav(String ip, {IPType ipType = IPType.residential}) => FavoriteIp(
    ip: ip,
    countryCode: 'de',
    city: 'Berlin',
    ipType: ipType,
    savedAt: DateTime.utc(2026, 8, 5),
  );

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
  });

  setUp(() {
    store = MockFavoriteIpsStore();
    analytics = MockAnalyticsStore();
    vpnStore = MockVpnStore();
    displayStore = MockConnectionDisplayStore();
    locationsStore = MockLocationsStore();
    bannersStore = MockBannersStore();
    when(bannersStore.canShow(any)).thenReturn(true);

    // No live locations by default — cards fall back to the stored names.
    when(
      locationsStore.dcLocationsFuture,
    ).thenAnswer((_) => ObservableFuture.value(VPNLocations()));
    when(
      locationsStore.residentialLocationsFuture,
    ).thenAnswer((_) => ObservableFuture.value(VPNLocations()));

    when(store.isEnabled).thenReturn(true);
    when(store.favorites).thenReturn([]);
    when(store.availableFavorites).thenReturn([]);
    when(store.unavailableFavorites).thenReturn([]);
    when(store.future).thenAnswer((_) => ObservableFuture.value(const <FavoriteIp>[]));
    when(store.refreshAvailability()).thenAnswer((_) async => true);
    when(store.remove(any)).thenAnswer((_) async {});
    when(store.undoRemove()).thenAnswer((_) async => true);
    when(vpnStore.isConnected).thenReturn(false);
    when(displayStore.connectionIP).thenReturn(null);
  });

  Future<void> pumpSliver(WidgetTester tester, {bool settle = true}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          favoriteIpsStorePOD.overrideWithValue(store),
          analyticsStorePOD.overrideWithValue(analytics),
          vpnStorePOD.overrideWithValue(vpnStore),
          connectionDisplayStorePOD.overrideWithValue(displayStore),
          locationsStorePOD.overrideWithValue(locationsStore),
          bannersStorePOD.overrideWithValue(bannersStore),
        ],
        child: MaterialApp(
          theme: DesignSystem.lightTheme,
          locale: testLocale,
          localizationsDelegates: testLocalizationsDelegates,
          supportedLocales: testSupportedLocales,
          home: const ModalMessengerScope(
            child: Scaffold(body: CustomScrollView(slivers: [FavoriteIpsSliver()])),
          ),
        ),
      ),
    );
    // The connecting state renders an endlessly animating spinner, which
    // pumpAndSettle would wait on forever.
    if (settle) {
      await tester.pumpAndSettle();
    } else {
      await tester.pump();
    }
  }

  testWidgets('refreshes availability on mount', (tester) async {
    await pumpSliver(tester);

    verify(store.refreshAvailability()).called(1);
  });

  testWidgets('renders a SavedIpCard per available favorite', (tester) async {
    final favs = [fav('1.1.1.1'), fav('2.2.2.2', ipType: IPType.datacenter)];
    when(store.favorites).thenReturn(favs);
    when(store.availableFavorites).thenReturn(favs);

    await pumpSliver(tester);

    expect(find.byType(SavedIpCard), findsNWidgets(2));
    expect(find.text('1.1.1.1'), findsOneWidget);
    // The badge shows the bare IP-type name (no "IP" suffix) on this card.
    expect(find.text(S.current.residential), findsOneWidget);
    expect(find.text(S.current.highSpeed), findsOneWidget);
    expect(find.text(S.current.favoriteIpsUnavailableHeading), findsNothing);
  });

  testWidgets('shows the fallback disclaimer above the saved cards', (tester) async {
    final favs = [fav('1.1.1.1')];
    when(store.favorites).thenReturn(favs);
    when(store.availableFavorites).thenReturn(favs);

    await pumpSliver(tester);

    expect(find.text(S.current.favoriteIpsDisclaimer), findsOneWidget);
  });

  testWidgets('hides the disclaimer once dismissed', (tester) async {
    final favs = [fav('1.1.1.1')];
    when(store.favorites).thenReturn(favs);
    when(store.availableFavorites).thenReturn(favs);
    when(bannersStore.canShow(BannerType.favoriteIPs)).thenReturn(false);

    await pumpSliver(tester);

    expect(find.text(S.current.favoriteIpsDisclaimer), findsNothing);
    expect(find.byType(SavedIpCard), findsOneWidget);
  });

  testWidgets('no disclaimer on the empty or locked states', (tester) async {
    await pumpSliver(tester);
    expect(find.text(S.current.favoriteIpsDisclaimer), findsNothing);

    when(store.isEnabled).thenReturn(false);
    await pumpSliver(tester);
    expect(find.text(S.current.favoriteIpsDisclaimer), findsNothing);
  });

  testWidgets('unavailable favorites render greyed under the unavailable heading', (tester) async {
    final available = [fav('1.1.1.1')];
    final unavailable = [fav('2.2.2.2')];
    when(store.favorites).thenReturn([...available, ...unavailable]);
    when(store.availableFavorites).thenReturn(available);
    when(store.unavailableFavorites).thenReturn(unavailable);

    await pumpSliver(tester);

    expect(find.text(S.current.favoriteIpsUnavailableHeading), findsOneWidget);
    expect(find.byType(SavedIpCard), findsNWidgets(2));
  });

  testWidgets('an unavailable favorite can still be removed via its heart', (tester) async {
    final unavailable = [fav('2.2.2.2')];
    when(store.favorites).thenReturn(unavailable);
    when(store.availableFavorites).thenReturn([]);
    when(store.unavailableFavorites).thenReturn(unavailable);

    await pumpSliver(tester);

    final card = find.byType(SavedIpCard);
    expect(tester.widget<SavedIpCard>(card).status, SavedIpCardStatus.disabled);

    await tester.tap(find.descendant(of: card, matching: find.byIcon(UntitledUI.heart_filled)));
    await tester.pumpAndSettle();

    verify(store.remove('2.2.2.2')).called(1);
    expect(find.text(S.current.favoriteIpRemovedToast), findsOneWidget);
  });

  testWidgets('tapping the heart removes the favorite and offers undo', (tester) async {
    final favs = [fav('1.1.1.1')];
    when(store.favorites).thenReturn(favs);
    when(store.availableFavorites).thenReturn(favs);

    await pumpSliver(tester);

    await tester.tap(find.byIcon(UntitledUI.heart_filled));
    await tester.pumpAndSettle();

    verify(store.remove('1.1.1.1')).called(1);
    expect(find.text(S.current.favoriteIpRemovedToast), findsOneWidget);

    await tester.tap(find.text(S.current.undo));
    await tester.pumpAndSettle();
    verify(store.undoRemove()).called(1);
    // The undo snackbar is replaced by the added confirmation.
    expect(find.text(S.current.favoriteIpRemovedToast), findsNothing);
    expect(find.text(S.current.favoriteIpAddedToast), findsOneWidget);
  });

  testWidgets('card names resolve from the live locations so they follow the locale', (
    tester,
  ) async {
    final favs = [fav('1.1.1.1')];
    when(store.favorites).thenReturn(favs);
    when(store.availableFavorites).thenReturn(favs);
    when(locationsStore.residentialLocationsFuture).thenAnswer(
      (_) => ObservableFuture.value(
        VPNLocations(
          locations: [
            const VPNLocation(
              id: 'de',
              ipType: IPType.residential,
              countryCode: 'de',
              translations: {'en': 'Germany'},
            ),
          ],
        ),
      ),
    );

    await pumpSliver(tester);

    expect(find.text('Germany'), findsOneWidget);
  });

  testWidgets('cards update in place when the location lists finish loading', (tester) async {
    final favs = [fav('1.1.1.1')];
    when(store.favorites).thenReturn(favs);
    when(store.availableFavorites).thenReturn(favs);

    // Observable the Observer must track: read via the stub during build.
    final residential = Observable(VPNLocations());
    when(
      locationsStore.residentialLocationsFuture,
    ).thenAnswer((_) => ObservableFuture.value(residential.value));

    await pumpSliver(tester);
    expect(find.text('Germany'), findsNothing);

    // Lists arrive while the tab is open — no other store state changes.
    runInAction(
      () => residential.value = VPNLocations(
        locations: [
          const VPNLocation(
            id: 'de',
            ipType: IPType.residential,
            countryCode: 'de',
            translations: {'en': 'Germany'},
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Germany'), findsOneWidget);
  });

  testWidgets('connects with the live location, not the synthetic saved one', (tester) async {
    final favorite = FavoriteIp(
      ip: '1.1.1.1',
      countryCode: 'de',
      city: 'Frankfurt am Main',
      ipType: IPType.residential,
      savedAt: DateTime.utc(2026, 8, 5),
      locationId: 'frankfurt_am_main',
    );
    when(store.favorites).thenReturn([favorite]);
    when(store.availableFavorites).thenReturn([favorite]);
    when(locationsStore.residentialLocationsFuture).thenAnswer(
      (_) => ObservableFuture.value(
        VPNLocations(
          locations: [
            const VPNLocation(
              id: 'de',
              ipType: IPType.residential,
              countryCode: 'de',
              translations: {'en': 'Germany'},
              children: [
                VPNLocation(
                  id: 'frankfurt_am_main',
                  ipType: IPType.residential,
                  countryCode: 'de',
                  translations: {'en': 'Frankfurt am Main'},
                ),
              ],
            ),
          ],
        ),
      ),
    );

    await pumpSliver(tester);
    await tester.tap(find.text('1.1.1.1'));
    await tester.pumpAndSettle();

    final connectedTo =
        verify(
              vpnStore.manageConnection(
                location: captureAnyNamed('location'),
                intent: anyNamed('intent'),
                targetIp: anyNamed('targetIp'),
              ),
            ).captured.single
            as VPNLocation?;
    // A translation-less location makes every surface downstream (the main
    // card) fall back to the raw id — "Frankfurt_am_main".
    expect(connectedTo?.translations['en'], 'Frankfurt am Main');
  });

  testWidgets('tapping an available favorite logs a connect click', (tester) async {
    final favs = [fav('1.1.1.1')];
    when(store.favorites).thenReturn(favs);
    when(store.availableFavorites).thenReturn(favs);

    await pumpSliver(tester);
    await tester.tap(find.text('1.1.1.1'));
    await tester.pumpAndSettle();

    verify(store.recordConnectClicked(any)).called(1);
  });

  testWidgets('tapping the connected favorite is a disconnect, not a connect click', (
    tester,
  ) async {
    final favs = [fav('1.1.1.1')];
    when(store.favorites).thenReturn(favs);
    when(store.availableFavorites).thenReturn(favs);
    when(vpnStore.isConnected).thenReturn(true);
    when(displayStore.connectionIP).thenReturn('1.1.1.1');

    await pumpSliver(tester);
    await tester.tap(find.text('1.1.1.1'));
    await tester.pumpAndSettle();

    verifyNever(store.recordConnectClicked(any));
    verifyNever(store.recordConnectOutcome(any, connectedIp: anyNamed('connectedIp')));
  });

  testWidgets('connected favorite shows check, subtitle and selected surface', (tester) async {
    final favs = [fav('1.1.1.1')];
    when(store.favorites).thenReturn(favs);
    when(store.availableFavorites).thenReturn(favs);
    when(vpnStore.isConnected).thenReturn(true);
    when(displayStore.connectionIP).thenReturn('1.1.1.1');

    await pumpSliver(tester);

    expect(find.text('${S.current.connected} · Berlin'), findsOneWidget);
    expect(find.byIcon(UntitledUI.check), findsOneWidget);
    final card = tester.widget<SavedIpCard>(find.byType(SavedIpCard));
    expect(card.status, SavedIpCardStatus.connected);
  });

  testWidgets('connecting favorite shows spinner and connecting subtitle', (tester) async {
    final favs = [fav('1.1.1.1')];
    when(store.favorites).thenReturn(favs);
    when(store.availableFavorites).thenReturn(favs);
    when(store.connectingIp).thenReturn('1.1.1.1');

    await pumpSliver(tester, settle: false);

    expect(find.text('${S.current.connecting}...'), findsOneWidget);
    expect(find.byType(LoadingIndicator), findsOneWidget);
  });

  testWidgets('shows loading skeletons until the favorites first load', (tester) async {
    when(store.future).thenAnswer((_) => ObservableFuture(Completer<List<FavoriteIp>>().future));

    await pumpSliver(tester, settle: false);

    expect(find.byType(FavoriteIpItemLoading), findsWidgets);
    expect(find.text(S.current.favoriteIpsEmptyTitle), findsNothing);
  });

  testWidgets('enabled with no favorites shows the empty state', (tester) async {
    await pumpSliver(tester);

    expect(find.text(S.current.favoriteIpsEmptyTitle), findsOneWidget);
    expect(find.text(S.current.favoriteIpsEmptyBody), findsOneWidget);
    expect(find.byType(SavedIpCard), findsNothing);
  });

  testWidgets('locked state shows upgrade promo when there are no favorites', (tester) async {
    when(store.isEnabled).thenReturn(false);

    await pumpSliver(tester);

    expect(find.text(S.current.favoriteIpsLockedTitle), findsOneWidget);
    expect(find.text(S.current.favoriteIpsLockedBody), findsOneWidget);
    expect(find.text(S.current.favoriteIpsUpgradePlan), findsOneWidget);
    expect(find.byType(SavedIpCard), findsNothing);
  });

  testWidgets('downgraded state shows banner and locked disabled cards', (tester) async {
    final favs = [fav('1.1.1.1')];
    when(store.isEnabled).thenReturn(false);
    when(store.favorites).thenReturn(favs);
    when(store.availableFavorites).thenReturn(favs);

    await pumpSliver(tester);

    expect(find.text(S.current.favoriteIpsNotAvailableOnPlan), findsOneWidget);
    expect(find.text(S.current.subscriptionUpgrade), findsOneWidget);
    final card = tester.widget<SavedIpCard>(find.byType(SavedIpCard));
    expect(card.type, SavedIpCardType.locked);
    expect(card.status, SavedIpCardStatus.disabled);
  });
}
