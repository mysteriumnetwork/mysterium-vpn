import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/stores/subscription_cancellation_store.dart';

import 'subscription_cancellation_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AnalyticsStore>(),
  MockSpec<SubscriptionStore>(),
  MockSpec<SubscriptionService>(),
  MockSpec<RemoteConfigStore>(),
])
void main() {
  late MockAnalyticsStore analyticsStore;
  late MockSubscriptionStore subscriptionStore;
  late MockSubscriptionService subscriptionService;
  late MockRemoteConfigStore remoteConfigStore;
  late SubscriptionCancellationStore store;

  setUp(() {
    analyticsStore = MockAnalyticsStore();
    subscriptionStore = MockSubscriptionStore();
    subscriptionService = MockSubscriptionService();
    remoteConfigStore = MockRemoteConfigStore();

    when(remoteConfigStore.pauseSubscriptionEnabled).thenReturn(true);
    when(subscriptionStore.useWebFlow).thenReturn(true);
    when(subscriptionStore.subscriptionFuture).thenAnswer(
      (_) => ObservableFuture.value(Subscription(active: true, paused: false, id: 'sub-1')),
    );
    when(subscriptionService.fetchPauseDurations()).thenAnswer((_) async => ['1m', '3m', '6m']);
    when(subscriptionStore.pauseSubscription(any)).thenAnswer((_) async {});
    when(
      analyticsStore.logCancellationPauseAccepted(
        pauseDuration: anyNamed('pauseDuration'),
        subscriptionId: anyNamed('subscriptionId'),
        pauseEndDate: anyNamed('pauseEndDate'),
        billingResumeDate: anyNamed('billingResumeDate'),
      ),
    ).thenAnswer((_) async {});
    when(
      analyticsStore.logCancellationPauseFailed(
        subscriptionId: anyNamed('subscriptionId'),
        pauseDuration: anyNamed('pauseDuration'),
        failureReason: anyNamed('failureReason'),
      ),
    ).thenAnswer((_) async {});
    when(
      analyticsStore.logSubscriptionCancellationPauseDuration(months: anyNamed('months')),
    ).thenAnswer((_) async {});
    when(
      analyticsStore.logSubscriptionCancellationSurvey(
        reasons: anyNamed('reasons'),
        feedback: anyNamed('feedback'),
      ),
    ).thenAnswer((_) async {});
    when(
      analyticsStore.logCancellationReasonSubmitted(
        reasons: anyNamed('reasons'),
        feedback: anyNamed('feedback'),
      ),
    ).thenAnswer((_) async {});

    store = SubscriptionCancellationStore(
      analyticsStore: analyticsStore,
      subscriptionStore: subscriptionStore,
      subscriptionService: subscriptionService,
      remoteConfigStore: remoteConfigStore,
    );
  });

  group('isStoreSubscription', () {
    test('returns false for web subscriptions', () {
      expect(store.isStoreSubscription(), isFalse);
    });

    test('returns true for Apple/Google subscriptions', () {
      when(subscriptionStore.useWebFlow).thenReturn(false);

      expect(store.isStoreSubscription(), isTrue);
    });
  });

  group('canPauseSubscription', () {
    test('returns false when the remote config flag is off', () async {
      when(remoteConfigStore.pauseSubscriptionEnabled).thenReturn(false);

      expect(await store.canPauseSubscription(), isFalse);
      verifyNever(subscriptionService.fetchPauseDurations());
    });

    test('returns false for store (Apple/Google) subscriptions', () async {
      when(subscriptionStore.useWebFlow).thenReturn(false);

      expect(await store.canPauseSubscription(), isFalse);
      verifyNever(subscriptionService.fetchPauseDurations());
    });

    test('loads durations and returns true when pause is available', () async {
      expect(await store.canPauseSubscription(), isTrue);
      expect(store.availablePauseDurations, ['1m', '3m', '6m']);
      verify(subscriptionService.fetchPauseDurations()).called(1);
    });

    test('returns false when API returns no durations', () async {
      when(subscriptionService.fetchPauseDurations()).thenAnswer((_) async => []);

      expect(await store.canPauseSubscription(), isFalse);
      expect(store.availablePauseDurations, isEmpty);
    });

    test('keeps unknown period codes from the API', () async {
      when(subscriptionService.fetchPauseDurations()).thenAnswer((_) async => ['12m', '1m']);

      expect(await store.canPauseSubscription(), isTrue);
      expect(store.availablePauseDurations, ['12m', '1m']);
    });

    test('drops blank period codes from the API', () async {
      when(subscriptionService.fetchPauseDurations()).thenAnswer((_) async => ['1m', '  ', '3m']);

      expect(await store.canPauseSubscription(), isTrue);
      expect(store.availablePauseDurations, ['1m', '3m']);
    });

    test('returns false when the subscription is already paused', () async {
      when(
        subscriptionStore.subscriptionFuture,
      ).thenAnswer((_) => ObservableFuture.value(Subscription(active: true, paused: true)));

      expect(await store.canPauseSubscription(), isFalse);
    });

    test('returns false when pausedFrom is set', () async {
      when(subscriptionStore.subscriptionFuture).thenAnswer(
        (_) => ObservableFuture.value(
          Subscription(active: true, paused: false, pausedFrom: DateTime(2026)),
        ),
      );

      expect(await store.canPauseSubscription(), isFalse);
    });

    test('returns false when pausedUntil is set', () async {
      when(subscriptionStore.subscriptionFuture).thenAnswer(
        (_) => ObservableFuture.value(
          Subscription(active: true, paused: false, pausedUntil: DateTime(2026)),
        ),
      );

      expect(await store.canPauseSubscription(), isFalse);
    });

    test('returns false when fetch fails', () async {
      when(subscriptionService.fetchPauseDurations()).thenThrow(Exception('network'));

      expect(await store.canPauseSubscription(), isFalse);
      expect(store.availablePauseDurations, isEmpty);
      expect(store.error, isA<Exception>());
    });
  });

  group('pauseSubscription', () {
    test('sends the period code and logs analytics', () async {
      await store.canPauseSubscription();

      final ok = await store.pauseSubscription('3m');

      expect(ok, isTrue);
      expect(store.isProcessing, isFalse);
      verify(subscriptionStore.pauseSubscription('3m')).called(1);
      verify(
        analyticsStore.logCancellationPauseAccepted(
          pauseDuration: '3m',
          subscriptionId: 'sub-1',
          pauseEndDate: anyNamed('pauseEndDate'),
          billingResumeDate: anyNamed('billingResumeDate'),
        ),
      ).called(1);
      verify(analyticsStore.logSubscriptionCancellationPauseDuration(months: 3)).called(1);
    });

    test('returns false when the duration was not offered by the API', () async {
      when(subscriptionService.fetchPauseDurations()).thenAnswer((_) async => ['1m']);
      await store.canPauseSubscription();

      final ok = await store.pauseSubscription('6m');

      expect(ok, isFalse);
      verifyNever(subscriptionStore.pauseSubscription(any));
    });

    test('skips duration analytics when the period code has no month number', () async {
      when(subscriptionService.fetchPauseDurations()).thenAnswer((_) async => ['foo']);
      await store.canPauseSubscription();

      final ok = await store.pauseSubscription('foo');

      expect(ok, isTrue);
      verify(subscriptionStore.pauseSubscription('foo')).called(1);
      verify(
        analyticsStore.logCancellationPauseAccepted(
          pauseDuration: 'foo',
          subscriptionId: 'sub-1',
          pauseEndDate: anyNamed('pauseEndDate'),
          billingResumeDate: anyNamed('billingResumeDate'),
        ),
      ).called(1);
      verifyNever(
        analyticsStore.logSubscriptionCancellationPauseDuration(months: anyNamed('months')),
      );
    });

    test('returns false when pause fails', () async {
      when(subscriptionStore.pauseSubscription(any)).thenThrow(Exception('network'));
      await store.canPauseSubscription();

      final ok = await store.pauseSubscription('3m');

      expect(ok, isFalse);
      expect(store.isProcessing, isFalse);
      expect(store.error, isA<Exception>());
      verifyNever(
        analyticsStore.logCancellationPauseAccepted(
          pauseDuration: anyNamed('pauseDuration'),
          subscriptionId: anyNamed('subscriptionId'),
          pauseEndDate: anyNamed('pauseEndDate'),
          billingResumeDate: anyNamed('billingResumeDate'),
        ),
      );
      verify(
        analyticsStore.logCancellationPauseFailed(
          subscriptionId: 'sub-1',
          pauseDuration: '3m',
          failureReason: anyNamed('failureReason'),
        ),
      ).called(1);
    });
  });

  group('setSurvey', () {
    test('returns false when there are no reasons or feedback', () async {
      final result = await store.setSurvey(reasons: {});

      expect(result, isFalse);
      verifyNever(
        analyticsStore.logSubscriptionCancellationSurvey(
          reasons: anyNamed('reasons'),
          feedback: anyNamed('feedback'),
        ),
      );
      verifyNever(
        analyticsStore.logCancellationReasonSubmitted(
          reasons: anyNamed('reasons'),
          feedback: anyNamed('feedback'),
        ),
      );
    });

    test('returns false when reasons are empty and feedback is only spaces', () async {
      final result = await store.setSurvey(reasons: {}, feedback: ' ');

      expect(result, isFalse);
      verifyNever(
        analyticsStore.logSubscriptionCancellationSurvey(
          reasons: anyNamed('reasons'),
          feedback: anyNamed('feedback'),
        ),
      );
    });

    test('returns true when reasons are set', () async {
      final result = await store.setSurvey(reasons: {'price'});

      expect(result, isTrue);
      expect(store.isProcessing, isFalse);
      verify(analyticsStore.logSubscriptionCancellationSurvey(reasons: {'price'})).called(1);
      verify(analyticsStore.logCancellationReasonSubmitted(reasons: {'price'})).called(1);
    });

    test('returns true when reasons are empty but feedback is set', () async {
      final result = await store.setSurvey(reasons: {}, feedback: 'too expensive');

      expect(result, isTrue);
      verify(
        analyticsStore.logSubscriptionCancellationSurvey(reasons: {}, feedback: 'too expensive'),
      ).called(1);
      verify(
        analyticsStore.logCancellationReasonSubmitted(reasons: {}, feedback: 'too expensive'),
      ).called(1);
    });

    test('trims feedback before logging', () async {
      final result = await store.setSurvey(reasons: {'price'}, feedback: '  too expensive  ');

      expect(result, isTrue);
      verify(
        analyticsStore.logSubscriptionCancellationSurvey(
          reasons: {'price'},
          feedback: 'too expensive',
        ),
      ).called(1);
      verify(
        analyticsStore.logCancellationReasonSubmitted(
          reasons: {'price'},
          feedback: 'too expensive',
        ),
      ).called(1);
    });

    test('returns false when analytics fails', () async {
      when(
        analyticsStore.logCancellationReasonSubmitted(
          reasons: anyNamed('reasons'),
          feedback: anyNamed('feedback'),
        ),
      ).thenThrow(Exception('network'));

      final result = await store.setSurvey(reasons: {'price'});

      expect(result, isFalse);
      expect(store.isProcessing, isFalse);
      expect(store.error, isA<Exception>());
    });
  });

  group('reset', () {
    test('clears processing and error after a failure', () async {
      when(
        analyticsStore.logCancellationReasonSubmitted(
          reasons: anyNamed('reasons'),
          feedback: anyNamed('feedback'),
        ),
      ).thenThrow(Exception('network'));
      await store.setSurvey(reasons: {'price'});

      store.reset();

      expect(store.isProcessing, isFalse);
      expect(store.error, isNull);
    });
  });
}
