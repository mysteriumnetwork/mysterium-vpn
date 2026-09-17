import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/views/settings/account_settings.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../../support/test_localizations.dart';
import 'account_settings_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SubscriptionStore>(),
  MockSpec<AuthSessionStore>(),
  MockSpec<AuthStore>(),
  MockSpec<AnalyticsStore>(),
  MockSpec<RemoteConfigStore>(),
  MockSpec<VpnStore>(),
])
void main() {
  late MockSubscriptionStore subscriptionStore;
  late MockAuthSessionStore authSessionStore;
  late MockAuthStore authStore;
  late MockAnalyticsStore analyticsStore;
  late MockRemoteConfigStore remoteConfigStore;
  late MockVpnStore vpnStore;

  // A recurring plan renders the two-action trailing (Manage / Cancel) plus the
  // "Renews on …" subtitle — the arrangement the discount prices sit beside.
  final recurringSubscription = Subscription(
    active: true,
    recurring: true,
    gateway: 'stripe',
    planId: 'plan_yearly_pro',
    activeUntil: DateTime.utc(2027, 8, 14),
  );

  setUp(() {
    subscriptionStore = MockSubscriptionStore();
    authSessionStore = MockAuthSessionStore();
    authStore = MockAuthStore();
    analyticsStore = MockAnalyticsStore();
    remoteConfigStore = MockRemoteConfigStore();
    vpnStore = MockVpnStore();

    when(
      subscriptionStore.subscriptionFuture,
    ).thenAnswer((_) => ObservableFuture.value(recurringSubscription));
    when(
      subscriptionStore.refreshSubscription(force: anyNamed('force')),
    ).thenAnswer((_) async => recurringSubscription);

    when(authSessionStore.status).thenReturn(AuthStatus.authenticated);
    when(
      authSessionStore.user,
    ).thenReturn(AuthUser(userId: 'user-1', username: 'someone@example.com'));

    // Keep the card list short so geometry assertions stay unambiguous.
    when(remoteConfigStore.hideDeleteAccount).thenReturn(true);
    when(vpnStore.isConnected).thenReturn(false);
  });

  Widget buildHarness() => ProviderScope(
    overrides: [
      subscriptionStorePOD.overrideWithValue(subscriptionStore),
      authSessionStorePOD.overrideWithValue(authSessionStore),
      authStorePOD.overrideWithValue(authStore),
      analyticsStorePOD.overrideWithValue(analyticsStore),
      remoteConfigStorePOD.overrideWithValue(remoteConfigStore),
      vpnStorePOD.overrideWithValue(vpnStore),
    ],
    child: BeamerProvider(
      routerDelegate: BeamerDelegate(
        locationBuilder: RoutesLocationBuilder(
          routes: {'/': (_, _, _) => const SizedBox.shrink()},
        ).call,
      ),
      child: MaterialApp(
        theme: DesignSystem.lightTheme,
        locale: testLocale,
        localizationsDelegates: testLocalizationsDelegates,
        supportedLocales: testSupportedLocales,
        home: const Scaffold(body: AccountSettings()),
      ),
    ),
  );

  /// Sizes the test surface so `ScreenType.of` resolves to the wanted form
  /// factor (mobile < 750 logical px, tablet and above >= 750).
  Future<void> pumpAt(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(buildHarness());
    await tester.pump();
  }

  // The prices are placeholders in the widget until they are wired to the
  // store; match the discount icon instead of the literal amounts so these
  // tests keep passing once real values arrive.
  final priceIcon = find.byWidgetPredicate(
    (w) => w is Icon && w.icon == UntitledUI.sale_02,
    description: 'discount (sale_02) icon',
  );
  final renewsOn = find.textContaining('Renews on');
  // The trailing actions of a recurring plan; their position marks the top row.
  final cancelAction = find.text('Cancel');

  group('AccountSettings subscription card', () {
    testWidgets('on mobile the subtitle and prices drop below the trailing actions', (
      tester,
    ) async {
      await pumpAt(tester, const Size(390, 900));

      expect(renewsOn, findsOneWidget);
      expect(priceIcon, findsOneWidget);

      // Mobile puts the subtitle+prices in the card footer, so they sit under
      // the row that holds the title and the Manage/Cancel actions.
      expect(
        tester.getTopLeft(renewsOn).dy,
        greaterThanOrEqualTo(tester.getBottomLeft(cancelAction).dy),
        reason: 'footer should be below the trailing actions on mobile',
      );

      // Footer is right-aligned, so the prices trail the subtitle text.
      expect(
        tester.getTopLeft(priceIcon).dx,
        greaterThan(tester.getTopRight(renewsOn).dx),
        reason: 'prices should be to the right of the subtitle',
      );
    });

    testWidgets('on mobile the subtitle and prices fit without overflowing', (tester) async {
      // A RenderFlex overflow reports a FlutterError, which fails the test — so
      // rendering at the narrowest supported width is the assertion here.
      await pumpAt(tester, const Size(320, 900));

      expect(renewsOn, findsOneWidget);
      expect(priceIcon, findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('on desktop the prices render inline with the subtitle', (tester) async {
      await pumpAt(tester, const Size(1200, 900));

      expect(renewsOn, findsOneWidget);
      expect(priceIcon, findsOneWidget);

      // Inline means the prices share the subtitle's row rather than dropping
      // to a footer line of their own.
      final iconCentre = tester.getCenter(priceIcon).dy;
      final subtitleRect = tester.getRect(renewsOn);
      expect(
        iconCentre,
        inInclusiveRange(subtitleRect.top - 8, subtitleRect.bottom + 8),
        reason: 'prices should be vertically aligned with the subtitle on desktop',
      );

      // And the subtitle stays inside the trailing actions' row instead of
      // being pushed underneath them as it is on mobile.
      expect(
        subtitleRect.top,
        lessThan(tester.getBottomLeft(cancelAction).dy),
        reason: 'desktop should not use the footer',
      );
    });

    testWidgets('a recurring plan shows both manage and cancel actions', (tester) async {
      await pumpAt(tester, const Size(390, 900));

      expect(find.text('Manage'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('an inactive subscription shows the see-plans action, not renewal copy', (
      tester,
    ) async {
      when(
        subscriptionStore.subscriptionFuture,
      ).thenAnswer((_) => ObservableFuture.value(Subscription.empty()));

      await pumpAt(tester, const Size(390, 900));

      expect(renewsOn, findsNothing);
      expect(cancelAction, findsNothing);
      // The prices are still hardcoded placeholders, so they render regardless
      // of subscription state — assert the action instead until they are wired
      // to the store.
      expect(find.text('See all plans'), findsOneWidget);
      expect(find.text('You have no active subscription'), findsOneWidget);
    });
  });
}
