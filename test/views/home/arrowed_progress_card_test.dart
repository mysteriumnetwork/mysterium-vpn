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
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/views/home/arrowed_progress_card.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:showcaseview/showcaseview.dart';

import 'arrowed_progress_card_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AnalyticsStore>(),
  MockSpec<SubscriptionStore>(),
  MockSpec<LocalDBService>(),
  MockSpec<ThemeStore>(),
  MockSpec<RemoteConfigStore>(),
])
void main() {
  late MockAnalyticsStore analyticsStore;
  late MockSubscriptionStore subscriptionStore;
  late MockLocalDBService localDBService;
  late MockThemeStore themeStore;
  late MockRemoteConfigStore remoteConfigStore;
  late SubscriptionOnboardingStore subscriptionOnboardingStore;
  late GlobalKey<State<StatefulWidget>> showcaseKey;

  setUp(() {
    analyticsStore = MockAnalyticsStore();
    subscriptionStore = MockSubscriptionStore();
    localDBService = MockLocalDBService();
    themeStore = MockThemeStore();
    remoteConfigStore = MockRemoteConfigStore();
    showcaseKey = GlobalKey<State<StatefulWidget>>();

    when(themeStore.isDarkMode).thenReturn(false);

    when(localDBService.getSubscriptionOnboardingShown()).thenAnswer((_) async => false);
    when(
      subscriptionStore.subscriptionFuture,
    ).thenAnswer((_) => ObservableFuture.value(Subscription.empty()));

    subscriptionOnboardingStore = SubscriptionOnboardingStore(
      analyticsStore: analyticsStore,
      subscriptionStore: subscriptionStore,
      localDBService: localDBService,
      remoteConfigStore: remoteConfigStore,
    );
  });

  setUpAll(ShowcaseView.register);

  tearDownAll(() => ShowcaseView.get().unregister());

  Widget buildHarness({required Widget child}) => ProviderScope(
    overrides: [
      subscriptionOnboardingStorePOD.overrideWithValue(subscriptionOnboardingStore),
      themeStorePOD.overrideWithValue(themeStore),
    ],
    child: EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('en', 'US')],
      path: 'resources/langs',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      useOnlyLangCode: true,
      assetLoader: const CodegenLoader(),
      child: Builder(
        builder: (context) => MaterialApp(
          theme: DesignSystem.lightTheme,
          locale: EasyLocalization.of(context)?.locale,
          localizationsDelegates: EasyLocalization.of(context)?.delegates,
          supportedLocales: EasyLocalization.of(context)?.supportedLocales ?? const [Locale('en')],
          home: Scaffold(body: child),
        ),
      ),
    ),
  );

  group('ArrowedProgressCard', () {
    testWidgets('returns child without Showcase when startTour is false', (tester) async {
      await tester.pumpWidget(
        buildHarness(
          child: ArrowedProgressCard(
            globalKey: showcaseKey,
            step: SubscriptionOnboardingStep.map,
            tooltipPosition: TooltipPosition.top,
            child: const Text('showcase-target'),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('showcase-target'), findsOneWidget);
      expect(find.byType(Showcase), findsNothing);
    });

    testWidgets('wraps child with Showcase when startTour is true', (tester) async {
      subscriptionOnboardingStore.showSubscriptionOnboarding();

      await tester.pumpWidget(
        buildHarness(
          child: ArrowedProgressCard(
            globalKey: showcaseKey,
            step: SubscriptionOnboardingStep.map,
            tooltipPosition: TooltipPosition.top,
            child: const Text('showcase-target'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('showcase-target'), findsOneWidget);
      expect(find.byType(Showcase), findsOneWidget);
    });

    testWidgets('unwraps child after markShown resets startTour', (tester) async {
      subscriptionOnboardingStore.showSubscriptionOnboarding();

      await tester.pumpWidget(
        buildHarness(
          child: ArrowedProgressCard(
            globalKey: showcaseKey,
            step: SubscriptionOnboardingStep.map,
            tooltipPosition: TooltipPosition.top,
            child: const Text('showcase-target'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(Showcase), findsOneWidget);

      await subscriptionOnboardingStore.markShown();
      await tester.pumpAndSettle();

      expect(find.text('showcase-target'), findsOneWidget);
      expect(find.byType(Showcase), findsNothing);
    });
  });
}
