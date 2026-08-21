import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/components/dialogs/dialogs.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/stores/subscription_cancellation_store.dart';
import 'package:mysterium_vpn/stores/subscription_purchase_store.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../support/test_localizations.dart';
import 'cancel_subscription_dialog_test.mocks.dart';

class _CapturingUrlLauncher extends UrlLauncherPlatform with MockPlatformInterfaceMixin {
  final launchedUrls = <String>[];

  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> canLaunch(String url) async => true;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launchedUrls.add(url);
    return true;
  }
}

@GenerateNiceMocks([
  MockSpec<SubscriptionCancellationStore>(),
  MockSpec<AnalyticsStore>(),
  MockSpec<SubscriptionPurchaseStore>(),
  MockSpec<SubscriptionStore>(),
  MockSpec<RemoteConfigStore>(),
  MockSpec<AuthSessionStore>(),
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSubscriptionCancellationStore cancelStore;
  late MockAnalyticsStore analyticsStore;
  late MockSubscriptionPurchaseStore subscriptionPurchaseStore;
  late MockSubscriptionStore subscriptionStore;
  late MockRemoteConfigStore remoteConfigStore;
  late MockAuthSessionStore authSessionStore;
  late BuildContext context;

  setUp(() {
    cancelStore = MockSubscriptionCancellationStore();
    analyticsStore = MockAnalyticsStore();
    subscriptionPurchaseStore = MockSubscriptionPurchaseStore();
    subscriptionStore = MockSubscriptionStore();
    remoteConfigStore = MockRemoteConfigStore();
    authSessionStore = MockAuthSessionStore();
    when(analyticsStore.logCancellationConfirmViewed()).thenAnswer((_) async {});
    when(
      analyticsStore.logCancellationStarted(entrypoint: anyNamed('entrypoint')),
    ).thenAnswer((_) async {});
    when(
      analyticsStore.logCancellationDashboardOpened(
        source: anyNamed('source'),
        subscriptionId: anyNamed('subscriptionId'),
        pauseOfferShown: anyNamed('pauseOfferShown'),
      ),
    ).thenAnswer((_) async {});
    when(
      analyticsStore.logStoreSubscriptionManageClicked(
        store: anyNamed('store'),
        subscriptionId: anyNamed('subscriptionId'),
      ),
    ).thenAnswer((_) async {});
    when(
      analyticsStore.logCancellationRedirectFailed(
        subscriptionId: anyNamed('subscriptionId'),
        failureReason: anyNamed('failureReason'),
      ),
    ).thenAnswer((_) async {});
    when(cancelStore.pauseOfferShown).thenReturn(false);
    when(subscriptionStore.subscriptionFuture).thenAnswer(
      (_) => ObservableFuture.value(
        Subscription(active: true, id: 'sub-1', gateway: 'google', paused: false),
      ),
    );
  });

  /// Opens the confirm dialog via [showCancelSubscriptionDialog].
  Future<void> openConfirmDialog(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          subscriptionCancellationStorePOD.overrideWithValue(cancelStore),
          analyticsStorePOD.overrideWithValue(analyticsStore),
          subscriptionPurchaseStorePOD.overrideWithValue(subscriptionPurchaseStore),
          subscriptionStorePOD.overrideWithValue(subscriptionStore),
        ],
        child: MaterialApp(
          scaffoldMessengerKey: snackbarKey,
          theme: DesignSystem.lightTheme,
          locale: testLocale,
          localizationsDelegates: testLocalizationsDelegates,
          supportedLocales: testSupportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (ctx) {
                context = ctx;
                return ElevatedButton(
                  onPressed: () => showCancelSubscriptionDialog(context),
                  child: const Text('open'),
                );
              },
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('shows the confirm dialog and logs started + confirm viewed', (tester) async {
    await openConfirmDialog(tester);

    expect(find.text(S.current.cancelSubscriptionTitle), findsOneWidget);
    expect(find.text(S.current.continueBtn), findsOneWidget);
    expect(find.text(S.current.keepSubscriptionBtn), findsOneWidget);
    verify(analyticsStore.logCancellationStarted(entrypoint: 'account')).called(1);
    verify(analyticsStore.logCancellationConfirmViewed()).called(1);
  });

  testWidgets('keep subscription dismisses without continuing the flow', (tester) async {
    // arrange
    await openConfirmDialog(tester);

    // act
    await tester.tap(find.byType(ButtonTertiary));
    await tester.pump();

    // assert
    verify(analyticsStore.logCancellationStarted(entrypoint: 'account')).called(1);
    verifyNever(subscriptionPurchaseStore.manageSubscription());
    verify(cancelStore.reset()).called(2);
  });

  testWidgets('close dismisses without continuing the flow', (tester) async {
    // arrange
    await openConfirmDialog(tester);

    // act
    await tester.tap(find.byIcon(UntitledUI.x_close));
    await tester.pumpAndSettle();

    // assert
    expect(find.text(S.current.cancelSubscriptionTitle), findsNothing);
    verify(analyticsStore.logCancellationStarted(entrypoint: 'account')).called(1);
    verifyNever(subscriptionPurchaseStore.manageSubscription());
    verify(cancelStore.reset()).called(2);
  });

  testWidgets('continue on a store sub skips survey and opens manage', (tester) async {
    // arrange
    await openConfirmDialog(tester);
    when(cancelStore.isStoreSubscription()).thenReturn(true);
    when(subscriptionPurchaseStore.manageSubscription()).thenAnswer((_) async {});

    // act
    await tester.tap(find.byType(ButtonPrimary));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));

    // assert
    verify(cancelStore.reset()).called(2);
    verify(analyticsStore.logCancellationStarted(entrypoint: 'account')).called(1);
    verify(
      analyticsStore.logStoreSubscriptionManageClicked(
        store: anyNamed('store'),
        subscriptionId: anyNamed('subscriptionId'),
      ),
    ).called(1);
    verify(subscriptionPurchaseStore.manageSubscription()).called(1);
  });

  testWidgets('shows a snackbar when store manage fails', (tester) async {
    // arrange
    when(cancelStore.isStoreSubscription()).thenReturn(true);
    when(subscriptionPurchaseStore.manageSubscription()).thenThrow(Exception('fail'));
    await openConfirmDialog(tester);

    // act
    await tester.tap(find.byType(ButtonPrimary));
    await tester.pump();

    // assert
    expect(find.text(S.current.somethingWentWrong), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('refreshes the subscription after store manage handoff', (tester) async {
    // arrange
    when(cancelStore.isStoreSubscription()).thenReturn(true);
    when(subscriptionPurchaseStore.manageSubscription()).thenAnswer((_) async {});
    when(
      subscriptionStore.refreshSubscription(force: anyNamed('force')),
    ).thenAnswer((_) async => Subscription(active: true));
    await openConfirmDialog(tester);

    // act
    await tester.tap(find.byType(ButtonPrimary));
    await tester.pump();

    // assert
    verifyNever(subscriptionStore.refreshSubscription(force: anyNamed('force')));
    await tester.pump(const Duration(seconds: 2));
    verify(subscriptionStore.refreshSubscription(force: true)).called(1);
  });

  group('showContinueToWebPrompt', () {
    Future<void> openWebPrompt(
      WidgetTester tester, {
      required VoidCallback onContinuePressed,
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: DesignSystem.lightTheme,
          locale: testLocale,
          localizationsDelegates: testLocalizationsDelegates,
          supportedLocales: testSupportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () =>
                    showContinueToWebPrompt(context: ctx, onContinuePressed: onContinuePressed),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
    }

    testWidgets('shows title, continue to web, and stay', (tester) async {
      await openWebPrompt(tester, onContinuePressed: () {});

      expect(find.text(S.current.continueCancellationOnWebTitle), findsOneWidget);
      expect(find.text(S.current.continueToWebBtn), findsOneWidget);
      expect(find.text(S.current.stayOnAppBtn), findsOneWidget);
    });

    testWidgets('stay dismisses without continuing', (tester) async {
      var continued = false;
      await openWebPrompt(tester, onContinuePressed: () => continued = true);

      await tester.tap(find.byType(ButtonTertiary));
      await tester.pumpAndSettle();

      expect(continued, isFalse);
      expect(find.text(S.current.continueCancellationOnWebTitle), findsNothing);
    });

    testWidgets('continue to web dismisses and runs the callback', (tester) async {
      var continued = false;
      await openWebPrompt(tester, onContinuePressed: () => continued = true);

      await tester.tap(find.byType(ButtonPrimary));
      await tester.pumpAndSettle();

      expect(continued, isTrue);
      expect(find.text(S.current.continueCancellationOnWebTitle), findsNothing);
    });
  });

  group('openCancelSubscriptionLink web', () {
    late UrlLauncherPlatform originalLauncher;
    late _CapturingUrlLauncher urlLauncher;

    setUp(() {
      originalLauncher = UrlLauncherPlatform.instance;
      urlLauncher = _CapturingUrlLauncher();
      UrlLauncherPlatform.instance = urlLauncher;
      when(cancelStore.isStoreSubscription()).thenReturn(false);
      when(
        remoteConfigStore.cancelSubscriptionPage,
      ).thenReturn('https://app.example.com/dashboard/cancel');
      when(authSessionStore.accessToken).thenReturn('token-123');
    });

    tearDown(() {
      UrlLauncherPlatform.instance = originalLauncher;
    });

    Future<void> openWebLink(WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            subscriptionCancellationStorePOD.overrideWithValue(cancelStore),
            analyticsStorePOD.overrideWithValue(analyticsStore),
            remoteConfigStorePOD.overrideWithValue(remoteConfigStore),
            authSessionStorePOD.overrideWithValue(authSessionStore),
            subscriptionStorePOD.overrideWithValue(subscriptionStore),
          ],
          child: MaterialApp(
            theme: DesignSystem.lightTheme,
            locale: testLocale,
            localizationsDelegates: testLocalizationsDelegates,
            supportedLocales: testSupportedLocales,
            home: Scaffold(
              body: Builder(
                builder: (ctx) {
                  context = ctx;
                  return ElevatedButton(
                    onPressed: () => openCancelSubscriptionLink(
                      context,
                      store: cancelStore,
                      analyticsStore: analyticsStore,
                    ),
                    child: const Text('open'),
                  );
                },
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
    }

    testWidgets('opens the cancel page with access_token and logs dashboard opened', (
      tester,
    ) async {
      await openWebLink(tester);

      verify(
        analyticsStore.logCancellationDashboardOpened(
          source: anyNamed('source'),
          subscriptionId: anyNamed('subscriptionId'),
          pauseOfferShown: anyNamed('pauseOfferShown'),
        ),
      ).called(1);
      expect(urlLauncher.launchedUrls, [
        'https://app.example.com/dashboard/cancel?access_token=token-123',
      ]);
    });
  });
}
