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
import 'package:mysterium_vpn/views/home/tabs/home_products_tab/home_products_tab.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../../../support/test_localizations.dart';
import 'home_products_tab_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SubscriptionStore>()])
void main() {
  late MockSubscriptionStore subscriptionStore;

  setUp(() {
    subscriptionStore = MockSubscriptionStore();
    // Branch selection now lives in `productsScreenVariant` (unit-tested in
    // products_screen_variant_test.dart). This widget test only verifies that
    // each variant renders the right view, so we stub the variant directly and
    // keep `subscriptionFuture` on a stable default for the views that read it.
    when(
      subscriptionStore.subscriptionFuture,
    ).thenAnswer((_) => ObservableFuture.value(Subscription.empty()));
    when(subscriptionStore.productsScreenVariant).thenReturn(ProductsScreenVariant.defaultUpgrade);
  });

  Widget buildHarness() => ProviderScope(
    overrides: [subscriptionStorePOD.overrideWithValue(subscriptionStore)],
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
        home: const Scaffold(body: HomeProductsTab()),
      ),
    ),
  );

  group('HomeProductsTab variant rendering', () {
    // Branch *selection* (granular getters -> variant, and precedence) is
    // covered by products_screen_variant_test.dart. These tests verify the
    // widget renders the correct view for each settled variant.

    testWidgets('renders MaxPlanView for ProductsScreenVariant.maxPlan', (tester) async {
      when(subscriptionStore.productsScreenVariant).thenReturn(ProductsScreenVariant.maxPlan);

      await tester.pumpWidget(buildHarness());
      await tester.pump();

      // MaxPlanView's distinctive alert message (no localization load, so
      // the raw key may show — match either form).
      expect(
        find.textContaining(RegExp('highest plan|productsMaxPlanAlert')),
        findsOneWidget,
        reason: 'MaxPlanView alert text should be on screen',
      );
      expect(find.textContaining('Manage on the web'), findsNothing);
    });

    testWidgets('renders ManageOnWebView with active-sub copy for manageOnWeb + active sub', (
      tester,
    ) async {
      when(subscriptionStore.productsScreenVariant).thenReturn(ProductsScreenVariant.manageOnWeb);
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
      expect(find.textContaining('highest plan'), findsNothing);
      // Should not show the first-time-buyer copy.
      expect(find.textContaining('Subscribe on the web'), findsNothing);
    });

    testWidgets(
      'renders ManageOnWebView with first-time-buyer copy for manageOnWeb + no active sub',
      (tester) async {
        // Windows first-time buyer: manageOnWeb even though there is no active
        // subscription. Must NOT show the "you already have an active plan" alert.
        when(subscriptionStore.productsScreenVariant).thenReturn(ProductsScreenVariant.manageOnWeb);
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

    testWidgets('renders store-block view for ProductsScreenVariant.manageOnStore', (tester) async {
      // e.g. an Apple sub opened on Windows: must direct the user to the
      // originating store, never the web, and never the in-app upgrade picker.
      when(subscriptionStore.productsScreenVariant).thenReturn(ProductsScreenVariant.manageOnStore);
      when(subscriptionStore.subscriptionFuture).thenAnswer(
        (_) => ObservableFuture.value(
          Subscription(active: true, gateway: 'apple', planId: 'plan_monthly_basic'),
        ),
      );

      await tester.pumpWidget(buildHarness());
      await tester.pump();

      expect(
        find.textContaining(RegExp('active subscription paid via|activeSubsPaidVia')),
        findsOneWidget,
        reason: 'Store-block alert should be on screen',
      );
      expect(find.textContaining('Manage on the web'), findsNothing);
      expect(find.textContaining(RegExp('Subscribe on the web|subscribeOnWebBtn')), findsNothing);
    });

    // The default "upgrade view" branch wraps the [SubscriptionUpgradeView] in a
    // [SubscriptionStatusContainer] that reads several other stores (plans,
    // purchase, analytics, auth). It would need ~5 extra mocks to render without
    // crashing, so it is not exercised here.

    testWidgets('shows a loader for ProductsScreenVariant.loading', (tester) async {
      when(subscriptionStore.productsScreenVariant).thenReturn(ProductsScreenVariant.loading);

      await tester.pumpWidget(buildHarness());
      await tester.pump();

      expect(find.byType(LoadingIndicator), findsOneWidget);
      expect(find.textContaining('Manage on the web'), findsNothing);
    });
  });
}
