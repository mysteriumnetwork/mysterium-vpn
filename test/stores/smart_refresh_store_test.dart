import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/stores/smart_refresh_store.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:talker/talker.dart';

import 'smart_refresh_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LocationsStore>(),
  MockSpec<SubscriptionStore>(),
  MockSpec<AuthSessionStore>(),
  MockSpec<TermsConditionsStore>(),
  MockSpec<Talker>(),
])
void main() {
  late MockLocationsStore locations;
  late MockSubscriptionStore subscriptions;
  late MockAuthSessionStore authSession;
  late MockTermsConditionsStore termsConditions;
  late MockTalker logger;

  /// Indirection so a test can swap the store's future and have the plan
  /// reaction observe it — a mock getter is not itself observable.
  late Observable<ObservableFuture<Subscription>> subscriptionFuture;

  void emitSubscription(Subscription? subscription) => runInAction(
    () => subscriptionFuture.value = subscription == null
        ? ObservableFuture(Completer<Subscription>().future)
        : ObservableFuture.value(subscription),
  );

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    locations = MockLocationsStore();
    subscriptions = MockSubscriptionStore();
    authSession = MockAuthSessionStore();
    termsConditions = MockTermsConditionsStore();
    logger = MockTalker();

    subscriptionFuture = Observable(ObservableFuture(Completer<Subscription>().future));
    when(subscriptions.subscriptionFuture).thenAnswer((_) => subscriptionFuture.value);
    when(locations.refreshAll(invalidate: anyNamed('invalidate'))).thenAnswer((_) async {});
    when(authSession.isAuthenticated).thenReturn(false);
    when(
      subscriptions.refreshSubscription(force: anyNamed('force')),
    ).thenAnswer((_) async => Subscription.empty());
    when(termsConditions.checkForUpdatedTermsConditions()).thenAnswer((_) async {});
  });

  SmartRefreshStore buildStore() {
    final store = SmartRefreshStore(locations, subscriptions, authSession, termsConditions, logger);
    addTearDown(store.dispose);
    return store;
  }

  test('constructs and disposes cleanly', () async {
    final store = SmartRefreshStore(locations, subscriptions, authSession, termsConditions, logger);
    await store.dispose();
  });

  test('resume refresh calls refreshSubscription(force: true)', () async {
    final store = buildStore();

    await store.refreshSubscriptionOnResume();

    verify(subscriptions.refreshSubscription(force: true)).called(1);
  });

  test('resume refresh logs errors without rethrowing', () async {
    final error = Exception('offline');
    when(
      subscriptions.refreshSubscription(force: anyNamed('force')),
    ).thenAnswer((_) async => throw error);

    final store = buildStore();

    await store.refreshSubscriptionOnResume();

    verify(logger.handle(error, any)).called(1);
  });

  group('plan changes', () {
    /// The reaction is debounced by 200ms.
    Future<void> settle(WidgetTester tester) => tester.pump(const Duration(milliseconds: 300));

    testWidgets('the first resolved plan does not refetch locations', (tester) async {
      buildStore();

      emitSubscription(Subscription(active: true, planId: 'pro'));
      await settle(tester);

      verifyNever(locations.refreshAll(invalidate: anyNamed('invalidate')));
    });

    testWidgets('a plan change refetches locations', (tester) async {
      buildStore();

      emitSubscription(Subscription(active: true, planId: 'pro'));
      await settle(tester);
      emitSubscription(Subscription(active: true, planId: 'ultra'));
      await settle(tester);

      verify(locations.refreshAll(invalidate: argThat(isFalse, named: 'invalidate'))).called(1);
    });

    testWidgets('subscribing with no previous plan refetches locations', (tester) async {
      buildStore();

      // A loaded subscription with no plan reports a null planId, same as an
      // unresolved one — only the first of these two may be treated as a load.
      emitSubscription(Subscription.empty());
      await settle(tester);
      emitSubscription(Subscription(active: true, planId: 'pro'));
      await settle(tester);

      verify(locations.refreshAll(invalidate: argThat(isFalse, named: 'invalidate'))).called(1);
    });

    testWidgets('reloading the same plan does not refetch locations', (tester) async {
      buildStore();

      emitSubscription(Subscription(active: true, planId: 'pro'));
      await settle(tester);
      emitSubscription(null);
      await settle(tester);
      emitSubscription(Subscription(active: true, planId: 'pro'));
      await settle(tester);

      verifyNever(locations.refreshAll(invalidate: anyNamed('invalidate')));
    });
  });

  testWidgets('resume checks terms after the debounce', (tester) async {
    // Cold start is excluded now, so the app has to have left first.
    buildStore()
      ..didChangeAppLifecycleState(AppLifecycleState.paused)
      ..didChangeAppLifecycleState(AppLifecycleState.resumed);
    verifyNever(termsConditions.checkForUpdatedTermsConditions());

    await tester.pump(const Duration(milliseconds: 500));

    // Both must fire without a further frame: a post-frame hop would hang on a
    // static page, and only the terms call would catch a regression otherwise.
    verify(termsConditions.checkForUpdatedTermsConditions()).called(1);
    verify(subscriptions.refreshSubscription(force: true)).called(1);
  });
}
