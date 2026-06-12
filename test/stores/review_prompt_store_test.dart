import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/data/local/shared_preferences_service.dart';
import 'package:mysterium_vpn/stores/stores.dart';

import 'review_prompt_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SharedPreferenceService>(),
  MockSpec<RemoteConfigStore>(),
  MockSpec<AnalyticsStore>(),
  MockSpec<VpnStore>(),
  MockSpec<AuthSessionStore>(),
])
void main() {
  late MockSharedPreferenceService prefs;
  late MockRemoteConfigStore remoteConfig;
  late MockAnalyticsStore analytics;
  late MockVpnStore vpnStore;
  late MockAuthSessionStore authSessionStore;

  // Fixed clock so age/cooldown maths are deterministic.
  final fixedNow = DateTime.utc(2026, 6, 10);
  final nowMs = fixedNow.millisecondsSinceEpoch;
  const dayMs = 24 * 60 * 60 * 1000;

  ReviewPromptStore createStore({
    bool Function()? didCrashRecently,
    Future<bool> Function()? canShowNativeReview,
  }) => ReviewPromptStore(
    prefs: prefs,
    remoteConfigStore: remoteConfig,
    analyticsStore: analytics,
    vpnStore: vpnStore,
    authSessionStore: authSessionStore,
    now: () => fixedNow,
    didCrashRecently: didCrashRecently,
    canShowNativeReview: canShowNativeReview,
  );

  /// Configure all mocks so the user is eligible and nothing suppresses.
  void makeEligibleAndClear() {
    when(prefs.getAppInstallDay()).thenReturn(nowMs - 10 * dayMs);
    when(prefs.getReviewAppOpenCount()).thenReturn(5);
    when(prefs.getReviewSuccessfulConnections()).thenReturn(10);
    when(prefs.getReviewRecentSessionOutcomes()).thenReturn([true, true, true]);
    when(prefs.getReviewCooldownUntil()).thenReturn(null);
    when(prefs.getReviewPromptShownTimestamps()).thenReturn([]);
    when(prefs.getReviewNativeReviewOpenedAt()).thenReturn(null);

    // Defaults match the eligible/clear scenario (7d age, 5 opens, 10 conns,
    // 60s stable, 30/75/105 cooldowns, cap 3, enabled).
    when(remoteConfig.reviewPromptConfig).thenReturn(const ReviewPromptConfig());

    when(authSessionStore.isAuthenticated).thenReturn(true);
    // The prompt is evaluated after a session completes, i.e. while
    // disconnected — that is the unsuppressed baseline.
    when(vpnStore.vpnStatus).thenReturn(VpnConnectionStatus.disconnected);
  }

  setUp(() {
    prefs = MockSharedPreferenceService();
    remoteConfig = MockRemoteConfigStore();
    analytics = MockAnalyticsStore();
    vpnStore = MockVpnStore();
    authSessionStore = MockAuthSessionStore();
    makeEligibleAndClear();
  });

  group('isEligible', () {
    test('true when all conditions are met', () {
      expect(createStore().isEligible, isTrue);
    });

    test('false when account is too young', () {
      when(prefs.getAppInstallDay()).thenReturn(nowMs - 3 * dayMs);
      expect(createStore().isEligible, isFalse);
    });

    test('false when install day is unknown', () {
      when(prefs.getAppInstallDay()).thenReturn(null);
      expect(createStore().isEligible, isFalse);
    });

    test('false when too few app opens', () {
      when(prefs.getReviewAppOpenCount()).thenReturn(4);
      expect(createStore().isEligible, isFalse);
    });

    test('false when too few successful connections', () {
      when(prefs.getReviewSuccessfulConnections()).thenReturn(9);
      expect(createStore().isEligible, isFalse);
    });

    test('false when a recent session failed', () {
      when(prefs.getReviewRecentSessionOutcomes()).thenReturn([true, false, true]);
      expect(createStore().isEligible, isFalse);
    });

    test('false when fewer than three recent sessions', () {
      when(prefs.getReviewRecentSessionOutcomes()).thenReturn([true, true]);
      expect(createStore().isEligible, isFalse);
    });

    test('honours a lower cleanSessionsRequired (single clean session)', () {
      when(
        remoteConfig.reviewPromptConfig,
      ).thenReturn(const ReviewPromptConfig(cleanSessionsRequired: 1));
      when(prefs.getReviewRecentSessionOutcomes()).thenReturn([true]);
      expect(createStore().isEligible, isTrue);
    });

    test('skips the recent-sessions check when cleanSessionsRequired is 0', () {
      when(
        remoteConfig.reviewPromptConfig,
      ).thenReturn(const ReviewPromptConfig(cleanSessionsRequired: 0));
      // Even with a failure on record, the check is disabled.
      when(prefs.getReviewRecentSessionOutcomes()).thenReturn([false]);
      expect(createStore().isEligible, isTrue);
    });
  });

  group('suppressionReason', () {
    test('null when nothing blocks', () {
      expect(createStore().suppressionReason, isNull);
    });

    test('disabled when master flag is off', () {
      when(remoteConfig.reviewPromptConfig).thenReturn(const ReviewPromptConfig(enabled: false));
      expect(createStore().suppressionReason, 'disabled');
    });

    test('unauthenticated when not logged in', () {
      when(authSessionStore.isAuthenticated).thenReturn(false);
      expect(createStore().suppressionReason, 'unauthenticated');
    });

    test('vpn_connecting while connecting', () {
      when(vpnStore.vpnStatus).thenReturn(VpnConnectionStatus.connecting);
      expect(createStore().suppressionReason, 'vpn_connecting');
    });

    test('vpn_connected while connected', () {
      when(vpnStore.vpnStatus).thenReturn(VpnConnectionStatus.connected);
      expect(createStore().suppressionReason, 'vpn_connected');
    });

    test('recent_crash when a crash was detected', () {
      expect(createStore(didCrashRecently: () => true).suppressionReason, 'recent_crash');
    });

    test('cooldown_active while cooldown is in the future', () {
      when(prefs.getReviewCooldownUntil()).thenReturn(nowMs + dayMs);
      expect(createStore().suppressionReason, 'cooldown_active');
    });

    test('no suppression once cooldown has elapsed', () {
      when(prefs.getReviewCooldownUntil()).thenReturn(nowMs - dayMs);
      expect(createStore().suppressionReason, isNull);
    });

    test('yearly_cap when cap reached within the year', () {
      when(
        prefs.getReviewPromptShownTimestamps(),
      ).thenReturn([nowMs - 10 * dayMs, nowMs - 20 * dayMs, nowMs - 30 * dayMs]);
      expect(createStore().suppressionReason, 'yearly_cap');
    });

    test('yearly cap is disabled when yearlyCap is 0', () {
      when(remoteConfig.reviewPromptConfig).thenReturn(const ReviewPromptConfig(yearlyCap: 0));
      when(prefs.getReviewPromptShownTimestamps()).thenReturn([
        nowMs - 10 * dayMs,
        nowMs - 20 * dayMs,
        nowMs - 30 * dayMs,
      ]);
      expect(createStore().suppressionReason, isNull);
    });

    test('old displays outside the year do not count toward the cap', () {
      when(
        prefs.getReviewPromptShownTimestamps(),
      ).thenReturn([nowMs - 400 * dayMs, nowMs - 401 * dayMs, nowMs - 402 * dayMs]);
      expect(createStore().suppressionReason, isNull);
    });

    test('native_review_recent when a native prompt opened within positive cooldown', () {
      when(prefs.getReviewNativeReviewOpenedAt()).thenReturn(nowMs - 10 * dayMs);
      expect(createStore().suppressionReason, 'native_review_recent');
    });
  });

  group('evaluate', () {
    test('sets pendingPrompt and fires eligible when clear', () async {
      final store = createStore();
      await store.evaluate();
      expect(store.pendingPrompt, isTrue);
      verify(analytics.logEvent(AnalyticsEvent.reviewPromptEligible)).called(1);
      verifyNever(
        analytics.logEvent(
          AnalyticsEvent.reviewPromptSuppressed,
          parameters: anyNamed('parameters'),
        ),
      );
    });

    test('fires suppressed and leaves pendingPrompt false when blocked', () async {
      when(prefs.getReviewCooldownUntil()).thenReturn(nowMs + dayMs);
      final store = createStore();
      await store.evaluate();
      expect(store.pendingPrompt, isFalse);
      verify(analytics.logEvent(AnalyticsEvent.reviewPromptEligible)).called(1);
      verify(
        analytics.logEvent(
          AnalyticsEvent.reviewPromptSuppressed,
          parameters: {'reason': 'cooldown_active'},
        ),
      ).called(1);
    });

    test('does nothing when not eligible', () async {
      when(prefs.getReviewSuccessfulConnections()).thenReturn(0);
      final store = createStore();
      await store.evaluate();
      expect(store.pendingPrompt, isFalse);
      verifyNever(analytics.logEvent(AnalyticsEvent.reviewPromptEligible));
    });

    test('suppresses when the native review cannot be shown', () async {
      final store = createStore(canShowNativeReview: () async => false);
      await store.evaluate();
      expect(store.pendingPrompt, isFalse);
      verify(analytics.logEvent(AnalyticsEvent.reviewPromptEligible)).called(1);
      verify(
        analytics.logEvent(
          AnalyticsEvent.reviewPromptSuppressed,
          parameters: {'reason': 'native_review_unavailable'},
        ),
      ).called(1);
    });
  });

  group('session recording', () {
    test('recordSuccessfulSession bumps the counter and pushes a success', () async {
      await createStore().recordSuccessfulSession();
      verify(prefs.setReviewSuccessfulConnections(11)).called(1);
      verify(prefs.setReviewRecentSessionOutcomes([true, true, true])).called(1);
    });

    test('recordSessionOutcome keeps only the last three', () async {
      when(prefs.getReviewRecentSessionOutcomes()).thenReturn([true, true, true]);
      await createStore().recordSessionOutcome(success: false);
      verify(prefs.setReviewRecentSessionOutcomes([true, true, false])).called(1);
    });
  });

  group('action handlers', () {
    test(
      'onShown records the display, prunes the year window, and sets a baseline cooldown',
      () async {
        when(
          prefs.getReviewPromptShownTimestamps(),
        ).thenReturn([nowMs - 400 * dayMs, nowMs - dayMs]);
        final store = createStore()..pendingPrompt = true;
        await store.onShown();
        expect(store.pendingPrompt, isFalse);
        verify(analytics.logEvent(AnalyticsEvent.reviewPromptShown)).called(1);
        verify(prefs.setReviewPromptShownTimestamps([nowMs - dayMs, nowMs])).called(1);
        // Baseline dismissal cooldown so abandoning the flow still defers, and a
        // session completing mid-dialog can't re-enqueue the prompt.
        verify(prefs.setReviewCooldownUntil(nowMs + 30 * dayMs)).called(1);
        verifyNever(analytics.logEvent(AnalyticsEvent.reviewPromptCooldownStarted));
      },
    );

    test('onSatisfactionNo fires negative + feedback and starts negative cooldown', () async {
      await createStore().onSatisfactionNo();
      verify(analytics.logEvent(AnalyticsEvent.reviewPromptNegativeClicked)).called(1);
      verify(analytics.logEvent(AnalyticsEvent.feedbackFlowOpened)).called(1);
      verify(prefs.setReviewCooldownUntil(nowMs + 75 * dayMs)).called(1);
      verify(analytics.logEvent(AnalyticsEvent.reviewPromptCooldownStarted)).called(1);
    });

    test('onLeaveReview records native open and starts positive cooldown', () async {
      await createStore().onLeaveReview();
      verify(analytics.logEvent(AnalyticsEvent.nativeReviewPromptOpened)).called(1);
      verify(prefs.setReviewNativeReviewOpenedAt(nowMs)).called(1);
      verify(prefs.setReviewCooldownUntil(nowMs + 105 * dayMs)).called(1);
    });

    test('onDismiss starts the short dismissal cooldown', () async {
      await createStore().onDismiss();
      verify(analytics.logEvent(AnalyticsEvent.reviewPromptDismissed)).called(1);
      verify(prefs.setReviewCooldownUntil(nowMs + 30 * dayMs)).called(1);
    });

    test('onSatisfactionYes fires the positive-clicked event only', () async {
      await createStore().onSatisfactionYes();
      verify(analytics.logEvent(AnalyticsEvent.reviewPromptPositiveClicked)).called(1);
      verifyNever(analytics.logEvent(AnalyticsEvent.reviewPromptCooldownStarted));
    });
  });

  group('init app-open tracking', () {
    test('seeds install day when absent and increments app-open count', () {
      when(prefs.getAppInstallDay()).thenReturn(null);
      when(prefs.getReviewAppOpenCount()).thenReturn(2);
      final store = createStore()..init();
      verify(prefs.setAppInstallDay(nowMs)).called(1);
      verify(prefs.setReviewAppOpenCount(3)).called(1);
      store.dispose();
    });

    test('does not reseed install day when already set', () {
      when(prefs.getAppInstallDay()).thenReturn(nowMs - 5 * dayMs);
      final store = createStore()..init();
      verifyNever(prefs.setAppInstallDay(any));
      store.dispose();
    });
  });

  group('connection lifecycle (handleConnectionStatus)', () {
    // Use a 0s stability window so the timer fires within the test, and report
    // the VPN as connected so the timer's re-check passes.
    void useInstantStableSession() {
      when(
        remoteConfig.reviewPromptConfig,
      ).thenReturn(const ReviewPromptConfig(stableSessionSeconds: 0));
      when(vpnStore.vpnStatus).thenReturn(VpnConnectionStatus.connected);
    }

    test('a stable session records a successful connection', () async {
      useInstantStableSession();
      final store = createStore()..handleConnectionStatus(VpnConnectionStatus.connected);
      await Future<void>.delayed(Duration.zero); // let the stability timer fire
      verify(prefs.setReviewSuccessfulConnections(11)).called(1);
      verify(prefs.setReviewRecentSessionOutcomes([true, true, true])).called(1);
      store.dispose();
    });

    test('disconnect after a stable session surfaces the prompt', () async {
      useInstantStableSession();
      final store = createStore()..handleConnectionStatus(VpnConnectionStatus.connected);
      await Future<void>.delayed(Duration.zero);
      // Session completes: now disconnected, so it isn't suppressed.
      when(vpnStore.vpnStatus).thenReturn(VpnConnectionStatus.disconnected);
      store.handleConnectionStatus(VpnConnectionStatus.disconnected);
      await Future<void>.delayed(Duration.zero); // let evaluate() run
      expect(store.pendingPrompt, isTrue);
      verify(analytics.logEvent(AnalyticsEvent.reviewPromptEligible)).called(1);
      store.dispose();
    });

    test('a connection dropped before stability records a failure', () async {
      // Default 60s window — the timer never fires within the test.
      final store = createStore()
        ..handleConnectionStatus(VpnConnectionStatus.connected)
        ..handleConnectionStatus(VpnConnectionStatus.disconnected);
      await Future<void>.delayed(Duration.zero);
      verify(prefs.setReviewRecentSessionOutcomes([true, true, false])).called(1);
      expect(store.pendingPrompt, isFalse);
      store.dispose();
    });

    test('a never-connected attempt records nothing', () async {
      final store = createStore()
        ..handleConnectionStatus(VpnConnectionStatus.connecting)
        ..handleConnectionStatus(VpnConnectionStatus.disconnected);
      await Future<void>.delayed(Duration.zero);
      verifyNever(prefs.setReviewRecentSessionOutcomes(any));
      verifyNever(prefs.setReviewSuccessfulConnections(any));
      store.dispose();
    });
  });

  group('onSuppressedByActiveFlow', () {
    test('clears pendingPrompt and fires a flow_active suppression event', () async {
      final store = createStore()..pendingPrompt = true;
      await store.onSuppressedByActiveFlow();
      expect(store.pendingPrompt, isFalse);
      verify(
        analytics.logEvent(
          AnalyticsEvent.reviewPromptSuppressed,
          parameters: {'reason': 'flow_active'},
        ),
      ).called(1);
    });
  });

  group('resetState (QA)', () {
    test('clears pendingPrompt and persisted state', () async {
      final store = createStore()..pendingPrompt = true;
      await store.resetState();
      expect(store.pendingPrompt, isFalse);
      verify(prefs.resetReviewPromptState()).called(1);
    });
  });
}
