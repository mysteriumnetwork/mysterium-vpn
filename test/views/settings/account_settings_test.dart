import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

/// Colour of the status run — the design paints the status instead of badging it.
Color? statusColour(WidgetTester tester, String text) =>
    tester.widget<Text>(find.textContaining(text)).style?.color;

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
    orderSummary: OrderSummary(
      currency: 'USD',
      totalPrice: '74.23',
      totalPriceBeforeDiscount: '89.54',
    ),
  );

  final bonusSubscription = recurringSubscription.copyWith(
    extraDuration: ExtraDuration(amount: 3, unit: ExtraDurationUnit.month),
  );
  final cancelledBonus = bonusSubscription.copyWith(recurring: false);

  void stubSubscription(Subscription subscription) => when(
    subscriptionStore.subscriptionFuture,
  ).thenAnswer((_) => ObservableFuture.value(subscription));

  setUp(() {
    subscriptionStore = MockSubscriptionStore();
    authSessionStore = MockAuthSessionStore();
    authStore = MockAuthStore();
    analyticsStore = MockAnalyticsStore();
    remoteConfigStore = MockRemoteConfigStore();
    vpnStore = MockVpnStore();

    stubSubscription(recurringSubscription);
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

  // Prices come from the loaded subscription's order summary.
  final priceIcon = find.byWidgetPredicate(
    (w) => w is Icon && w.icon == UntitledUI.sale_02,
    description: 'discount (sale_02) icon',
  );
  final vatIcon = find.byIcon(UntitledUI.info_circle);
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
      expect(find.text(r'$74.23'), findsOneWidget);
      expect(find.text(r'$89.54'), findsOneWidget);

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
      expect(find.text(r'$74.23'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('on desktop the prices render inline with the subtitle', (tester) async {
      await pumpAt(tester, const Size(1200, 900));

      expect(renewsOn, findsOneWidget);
      expect(priceIcon, findsOneWidget);
      expect(find.text(r'$74.23'), findsOneWidget);

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

    testWidgets('a cancelled plan colours the status and keeps the access date', (tester) async {
      stubSubscription(recurringSubscription.copyWith(recurring: false));

      await pumpAt(tester, const Size(390, 900));

      expect(find.byIcon(UntitledUI.gift_02), findsNothing);
      expect(find.text('Cancelled'), findsOneWidget);
      expect(find.textContaining('Access available until'), findsOneWidget);
      expect(statusColour(tester, 'Cancelled'), DesignSystem.lightTheme.palette.textErrorPrimary);
    });

    testWidgets('a recurring plan shows both manage and cancel actions', (tester) async {
      await pumpAt(tester, const Size(390, 900));

      expect(find.text('Manage'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('the VAT note is reachable from the prices', (tester) async {
      await pumpAt(tester, const Size(390, 900));

      await tester.tap(vatIcon);
      await tester.pumpAndSettle();

      expect(find.text('Price includes applicable VAT.'), findsOneWidget);
    });

    testWidgets('no prices means no VAT note', (tester) async {
      stubSubscription(recurringSubscription.copyWith(orderSummary: null));

      await pumpAt(tester, const Size(390, 900));

      expect(priceIcon, findsNothing);
      expect(vatIcon, findsNothing);
    });

    testWidgets('an inactive subscription shows the see-plans action, not renewal copy', (
      tester,
    ) async {
      stubSubscription(Subscription.empty());

      await pumpAt(tester, const Size(390, 900));

      expect(renewsOn, findsNothing);
      expect(cancelAction, findsNothing);
      expect(priceIcon, findsNothing);
      expect(find.text('See all plans'), findsOneWidget);
      expect(find.text('You have no active subscription'), findsOneWidget);
    });
  });

  group('AccountSettings bonus badge', () {
    final bonusPill = find.text('+3 bonus months');
    // On the pill whatever its label says, so it also catches a wrong label.
    final pillIcon = find.byIcon(UntitledUI.gift_02);

    testWidgets('an active recurring plan with a bonus shows the pill', (tester) async {
      stubSubscription(bonusSubscription);

      await pumpAt(tester, const Size(390, 900));

      expect(bonusPill, findsOneWidget);
      expect(pillIcon, findsOneWidget);
      expect(renewsOn, findsOneWidget);
    });

    testWidgets('the pill also renders on desktop', (tester) async {
      stubSubscription(bonusSubscription);

      await pumpAt(tester, const Size(1200, 900));

      expect(bonusPill, findsOneWidget);
      expect(pillIcon, findsOneWidget);
    });

    testWidgets('no pill without an extra duration', (tester) async {
      await pumpAt(tester, const Size(390, 900));
      expect(bonusPill, findsNothing);
      expect(pillIcon, findsNothing);
    });

    testWidgets('no pill for a zero-amount extra duration', (tester) async {
      when(subscriptionStore.subscriptionFuture).thenAnswer(
        (_) => ObservableFuture.value(
          recurringSubscription.copyWith(
            extraDuration: ExtraDuration(amount: 0, unit: ExtraDurationUnit.month),
          ),
        ),
      );

      await pumpAt(tester, const Size(390, 900));

      expect(bonusPill, findsNothing);
      expect(pillIcon, findsNothing);
      expect(find.textContaining('bonus'), findsNothing);
    });

    // Only `month` ships today, so a mis-mapped arm would go unnoticed.
    for (final (unit, label) in [
      (ExtraDurationUnit.day, '+3 bonus days'),
      (ExtraDurationUnit.week, '+3 bonus weeks'),
      (ExtraDurationUnit.month, '+3 bonus months'),
      (ExtraDurationUnit.year, '+3 bonus years'),
    ]) {
      testWidgets('a ${unit.name} bonus reads "$label"', (tester) async {
        when(subscriptionStore.subscriptionFuture).thenAnswer(
          (_) => ObservableFuture.value(
            recurringSubscription.copyWith(extraDuration: ExtraDuration(amount: 3, unit: unit)),
          ),
        );

        await pumpAt(tester, const Size(1200, 900));

        expect(find.text(label), findsOneWidget);
      });
    }

    testWidgets('a single-unit bonus uses the singular form', (tester) async {
      when(subscriptionStore.subscriptionFuture).thenAnswer(
        (_) => ObservableFuture.value(
          recurringSubscription.copyWith(
            extraDuration: ExtraDuration(amount: 1, unit: ExtraDurationUnit.month),
          ),
        ),
      );

      await pumpAt(tester, const Size(1200, 900));

      expect(find.text('+1 bonus month'), findsOneWidget);
    });

    // The status moved out of the badge slot and into the subtitle, so a
    // cancelled or paused plan now shows its bonus alongside the status.
    testWidgets('a cancelled bonus plan shows the pill beside a red status', (tester) async {
      stubSubscription(cancelledBonus);

      await pumpAt(tester, const Size(390, 900));

      expect(bonusPill, findsOneWidget);
      expect(pillIcon, findsOneWidget);
      expect(find.text('Cancelled'), findsOneWidget);
      expect(find.textContaining('Access available until'), findsOneWidget);
      expect(statusColour(tester, 'Cancelled'), DesignSystem.lightTheme.palette.textErrorPrimary);
    });

    // The date must stay readable: it drops under the status, never ellipsizes.
    testWidgets('the access date is never truncated on a phone', (tester) async {
      stubSubscription(cancelledBonus);

      for (final width in [320.0, 390.0, 430.0]) {
        await pumpAt(tester, Size(width, 900));
        final date = tester.renderObject<RenderParagraph>(
          find.textContaining('Access available until'),
        );
        final status = tester.renderObject<RenderParagraph>(find.text('Cancelled'));
        expect(date.didExceedMaxLines, isFalse, reason: 'date truncated at ${width}pt');
        expect(status.didExceedMaxLines, isFalse, reason: 'status truncated at ${width}pt');
      }
    });

    testWidgets('the access date sits beside the status, or under it', (tester) async {
      stubSubscription(cancelledBonus);

      await pumpAt(tester, const Size(1200, 900));
      var status = tester.getRect(find.text('Cancelled'));
      var date = tester.getRect(find.textContaining('Access available until'));
      expect(date.left, greaterThan(status.right));

      await pumpAt(tester, const Size(320, 900));
      status = tester.getRect(find.text('Cancelled'));
      date = tester.getRect(find.textContaining('Access available until'));
      expect(date.top, greaterThanOrEqualTo(status.bottom));
      expect(date.left, status.left);
    });

    testWidgets('a paused bonus plan shows the pill beside an amber status', (tester) async {
      stubSubscription(
        bonusSubscription.copyWith(paused: true, pausedUntil: DateTime.utc(2027, 2)),
      );

      await pumpAt(tester, const Size(390, 900));

      expect(bonusPill, findsOneWidget);
      expect(pillIcon, findsOneWidget);
      expect(find.text('Paused'), findsOneWidget);
      expect(find.textContaining('Resumes on'), findsOneWidget);
      expect(statusColour(tester, 'Paused'), DesignSystem.lightTheme.palette.textWarningPrimary);
    });

    // The badge must not promise a renewal the subscription will never make.
    testWidgets('a cancelled plan drops the renewal sentence from the tooltip', (tester) async {
      stubSubscription(cancelledBonus);

      await pumpAt(tester, const Size(390, 900));
      await tester.tap(bonusPill);
      await tester.pumpAndSettle();

      expect(find.textContaining('renews'), findsNothing);
      expect(
        find.textContaining('Your subscription period includes 3 bonus months'),
        findsOneWidget,
      );
    });

    // find.text matches Text.data, not glyphs, so only a width check can prove
    // the pill is rendered whole rather than ellipsized.
    testWidgets('the pill is never truncated, from desktop down to 320pt', (tester) async {
      stubSubscription(cancelledBonus);

      await pumpAt(tester, const Size(1200, 900));
      final natural = tester.getRect(find.byType(AppBadge)).width;

      for (final width in [430.0, 390.0, 320.0]) {
        await pumpAt(tester, Size(width, 900));
        expect(
          tester.getRect(find.byType(AppBadge)).width,
          natural,
          reason: 'pill truncated at ${width}pt',
        );
      }
    });

    // The mobile account frame stacks the pill; the desktop one keeps it inline.
    testWidgets('the pill drops below the title only when the row runs out of room', (
      tester,
    ) async {
      stubSubscription(cancelledBonus);

      await pumpAt(tester, const Size(390, 900));
      var title = tester.getRect(find.textContaining('Pro'));
      var pill = tester.getRect(find.byType(AppBadge));
      expect(pill.left, greaterThan(title.right));

      await pumpAt(tester, const Size(320, 900));
      title = tester.getRect(find.textContaining('Pro'));
      pill = tester.getRect(find.byType(AppBadge));
      expect(pill.top, greaterThanOrEqualTo(title.bottom));
      expect(pill.left, title.left);
    });

    testWidgets('an inactive subscription shows no pill', (tester) async {
      when(subscriptionStore.subscriptionFuture).thenAnswer(
        (_) => ObservableFuture.value(
          Subscription(
            active: false,
            extraDuration: ExtraDuration(amount: 3, unit: ExtraDurationUnit.month),
          ),
        ),
      );

      await pumpAt(tester, const Size(390, 900));
      expect(bonusPill, findsNothing);
    });

    testWidgets('tapping the pill explains the bonus period', (tester) async {
      stubSubscription(bonusSubscription);
      when(subscriptionStore.billingPeriodMonths).thenReturn(12);

      await pumpAt(tester, const Size(390, 900));
      await tester.tap(bonusPill);
      await tester.pumpAndSettle();

      expect(find.textContaining('renews every 12 months'), findsOneWidget);
    });

    // The renewal interval is a billing claim, so it comes from the plan the
    // backend states — `plan_yearly_pro` would read as 12 months from its id.
    testWidgets('the renewal interval comes from the plan, not the plan id', (tester) async {
      stubSubscription(bonusSubscription);
      when(subscriptionStore.billingPeriodMonths).thenReturn(6);

      await pumpAt(tester, const Size(390, 900));
      await tester.tap(bonusPill);
      await tester.pumpAndSettle();

      expect(find.textContaining('renews every 6 months'), findsOneWidget);
      expect(find.textContaining('renews every 12 months'), findsNothing);
    });

    testWidgets('an unresolved plan omits the renewal interval', (tester) async {
      stubSubscription(bonusSubscription);
      when(subscriptionStore.billingPeriodMonths).thenReturn(null);

      await pumpAt(tester, const Size(390, 900));
      await tester.tap(bonusPill);
      await tester.pumpAndSettle();

      expect(find.textContaining('renews every'), findsNothing);
      expect(find.textContaining('renews at the standard price'), findsOneWidget);
    });

    testWidgets('the pill and a long plan name fit the narrowest phone', (tester) async {
      when(subscriptionStore.subscriptionFuture).thenAnswer(
        (_) => ObservableFuture.value(
          bonusSubscription.copyWith(planId: 'an extraordinarily long plan name'),
        ),
      );

      await pumpAt(tester, const Size(320, 900));
      expect(tester.takeException(), isNull);
    });
  });
}
