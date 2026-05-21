import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/generated/codegen_loader.g.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/views/home/tabs/home_products_tab/home_products_tab.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import 'home_products_tab_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SubscriptionStore>()])
void main() {
  late MockSubscriptionStore subscriptionStore;

  setUp(() {
    subscriptionStore = MockSubscriptionStore();
    // The HomeProductsTab Observer reads these too — keep them on stable
    // defaults so the build doesn't trip on a missing future.
    when(
      subscriptionStore.subscriptionFuture,
    ).thenAnswer((_) => ObservableFuture.value(Subscription.empty()));
    when(
      subscriptionStore.subscriptionConfigFuture,
    ).thenAnswer((_) => ObservableFuture.value(null));
    // Default to "no special state" — individual tests override.
    when(subscriptionStore.isOnMaxPlan).thenReturn(false);
    when(subscriptionStore.useWebFlow).thenReturn(false);
  });

  Widget buildHarness() => ProviderScope(
    overrides: [subscriptionStorePOD.overrideWithValue(subscriptionStore)],
    child: EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('en', 'US')],
      path: 'resources/langs',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      useOnlyLangCode: true,
      assetLoader: const CodegenLoader(),
      child: Builder(
        builder: (ctx) {
          final delegate = BeamerDelegate(
            locationBuilder: RoutesLocationBuilder(
              routes: {'/': (_, _, _) => const SizedBox.shrink()},
            ).call,
          );
          return BeamerProvider(
            routerDelegate: delegate,
            child: MaterialApp(
              theme: DesignSystem.lightTheme,
              locale: EasyLocalization.of(ctx)?.locale,
              localizationsDelegates: EasyLocalization.of(ctx)?.delegates,
              supportedLocales: EasyLocalization.of(ctx)?.supportedLocales ?? const [Locale('en')],
              home: const Scaffold(body: HomeProductsTab()),
            ),
          );
        },
      ),
    ),
  );

  group('HomeProductsTab branching', () {
    testWidgets('renders MaxPlanView when isOnMaxPlan is true', (tester) async {
      when(subscriptionStore.isOnMaxPlan).thenReturn(true);

      await tester.pumpWidget(buildHarness());
      await tester.pump();

      // MaxPlanView's distinctive alert message (no localization load, so
      // the raw key may show — match either form).
      expect(
        find.textContaining(RegExp('highest plan|productsMaxPlanAlert')),
        findsOneWidget,
        reason: 'MaxPlanView alert text should be on screen',
      );
      // Should not be the manage-on-web variant.
      expect(find.textContaining('Manage on the web'), findsNothing);
    });

    testWidgets('renders ManageOnWebView with active-sub copy when useWebFlow is true', (
      tester,
    ) async {
      when(subscriptionStore.useWebFlow).thenReturn(true);
      // Active subscription (e.g. credit card / PayPal paid on web).
      when(subscriptionStore.subscriptionFuture).thenAnswer(
        (_) => ObservableFuture.value(
          Subscription(active: true, gateway: 'stripe', planId: 'plan_yearly_pro'),
        ),
      );

      await tester.pumpWidget(buildHarness());
      await tester.pump();

      // ManageOnWebView's active-sub CTA button label.
      expect(
        find.textContaining(RegExp('Manage on the web|manageOnWebBtn')),
        findsOneWidget,
        reason: 'Manage on the web button should be on screen',
      );
      // Should not be the max-plan variant.
      expect(find.textContaining('highest plan'), findsNothing);
      // Should not show the first-time-buyer copy.
      expect(find.textContaining('Subscribe on the web'), findsNothing);
    });

    testWidgets(
      'renders ManageOnWebView with first-time-buyer copy on Windows with no active sub',
      (tester) async {
        // Windows first-time buyer: useWebFlow is true even though there is
        // no active subscription. Must NOT show the "you already have an
        // active plan" alert.
        when(subscriptionStore.useWebFlow).thenReturn(true);
        when(
          subscriptionStore.subscriptionFuture,
        ).thenAnswer((_) => ObservableFuture.value(Subscription.empty()));

        await tester.pumpWidget(buildHarness());
        await tester.pump();

        // First-time-buyer CTA + subtitle.
        expect(
          find.textContaining(RegExp('Subscribe on the web|subscribeOnWebBtn')),
          findsWidgets,
          reason: 'Subscribe on the web copy should be on screen',
        );
        // Active-sub copy must not be present.
        expect(find.textContaining('already have an active plan'), findsNothing);
        expect(find.textContaining('Manage on the web'), findsNothing);
      },
    );

    testWidgets('prefers MaxPlanView over ManageOnWebView when both flags are true', (
      tester,
    ) async {
      // Defensive: max plan is checked first in HomeProductsTab.build,
      // so an active sub on the max plan that also matches the web-flow
      // criteria should still render the max-plan variant.
      when(subscriptionStore.isOnMaxPlan).thenReturn(true);
      when(subscriptionStore.useWebFlow).thenReturn(true);

      await tester.pumpWidget(buildHarness());
      await tester.pump();

      expect(find.textContaining(RegExp('highest plan|productsMaxPlanAlert')), findsOneWidget);
      expect(find.textContaining('Manage on the web'), findsNothing);
    });

    // The default "upgrade view" branch (both flags false) wraps the
    // [SubscriptionUpgradeView] in a [SubscriptionStatusContainer] that
    // reads several other stores (plans, purchase, analytics, auth). It
    // would need ~5 extra mocks to render without crashing; the branching
    // itself is already covered by the three tests above.

    testWidgets('shows a loader while subscriptionFuture is pending', (tester) async {
      // Pending future — must not commit to a branch yet, even if the
      // web-flow computed has already flipped (e.g. Windows).
      final pending = ObservableFuture<Subscription>(Completer<Subscription>().future);
      when(subscriptionStore.subscriptionFuture).thenAnswer((_) => pending);
      when(subscriptionStore.useWebFlow).thenReturn(true);

      await tester.pumpWidget(buildHarness());
      await tester.pump();

      expect(find.byType(LoadingIndicator), findsOneWidget);
      expect(find.textContaining('Manage on the web'), findsNothing);
    });
  });
}
