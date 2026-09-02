import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/data/local/shared_preferences_service.dart';
import 'package:mysterium_vpn/stores/stores.dart';

part 'review_prompt_store.g.dart';

/// Drives the in-app "would you recommend this app" review/feedback prompt.
///
/// Watches the VPN connection status; once a connection has stayed up stably
/// for the configured stable-session window it records a successful
/// session and evaluates eligibility + suppression. When the user is eligible
/// and nothing blocks the prompt, `pendingPrompt` flips to `true` and the home
/// autorun surfaces the modal. All persisted state (counters, cooldown, yearly
/// cap) lives in [SharedPreferenceService] so it survives restarts.
// ignore: library_private_types_in_public_api
class ReviewPromptStore = _ReviewPromptStore with _$ReviewPromptStore;

abstract class _ReviewPromptStore with Store {
  _ReviewPromptStore({
    required SharedPreferenceService prefs,
    required RemoteConfigStore remoteConfigStore,
    required AnalyticsStore analyticsStore,
    required VpnStore vpnStore,
    required AuthSessionStore authSessionStore,
    required SubscriptionStore subscriptionStore,
    DateTime Function()? now,
    bool Function()? didCrashRecently,
    Future<bool> Function()? canShowNativeReview,
  }) : _prefs = prefs,
       _remoteConfig = remoteConfigStore,
       _analytics = analyticsStore,
       _vpnStore = vpnStore,
       _authSessionStore = authSessionStore,
       _subscriptionStore = subscriptionStore,
       _now = now ?? DateTime.now,
       _didCrashRecently = didCrashRecently ?? (() => false),
       _canShowNativeReview = canShowNativeReview ?? (() async => true);

  final SharedPreferenceService _prefs;
  final RemoteConfigStore _remoteConfig;
  final AnalyticsStore _analytics;
  final VpnStore _vpnStore;
  final AuthSessionStore _authSessionStore;
  final SubscriptionStore _subscriptionStore;
  final DateTime Function() _now;
  final bool Function() _didCrashRecently;

  /// Whether the platform can actually present the native store review prompt.
  /// When it can't (e.g. Windows/Linux), there's no point showing the in-app
  /// flow, so the prompt is suppressed entirely.
  final Future<bool> Function() _canShowNativeReview;

  ReactionDisposer? _statusDisposer;
  ReactionDisposer? _authDisposer;
  ReactionDisposer? _teardownDisposer;
  Timer? _stableTimer;

  /// Whether the current connection reached the stable threshold.
  bool _sessionStable = false;

  /// Whether a connection attempt is in progress (we have seen `connecting` or
  /// `connected`). An attempt that ends without reaching stability — whether it
  /// connected then dropped or never connected at all — is a failed session.
  bool _sessionAttempted = false;

  /// Set when the user is eligible and nothing suppresses the prompt. The home
  /// autorun watches this and shows the modal.
  @observable
  bool pendingPrompt = false;

  int get _nowMs => _now().millisecondsSinceEpoch;

  ReviewPromptConfig get _config => _remoteConfig.reviewPromptConfig;

  /// Seed the launch-time signals the prompt depends on and start observing the
  /// VPN connection status. Call once after construction.
  void init() {
    _trackAppOpen();
    _statusDisposer ??= reaction(
      (_) => _vpnStore.vpnStatus,
      handleConnectionStatus,
      fireImmediately: false,
    );
    // The dialog queue is serial, so a prompt can still be armed at logout.
    _authDisposer ??= reaction<bool>((_) => _authSessionStore.isAuthenticated, (authenticated) {
      if (!authenticated) {
        pendingPrompt = false;
      }
    });
    // Stamped before disconnectTunnel awaits, so this lands while the user is
    // still authenticated — earlier than the auth reaction above can fire.
    _teardownDisposer ??= reaction<VpnDisconnectReason>((_) => _vpnStore.disconnectReason, (
      reason,
    ) {
      if (reason.isAppInitiated) {
        pendingPrompt = false;
      }
    });
  }

  /// Seeds the install date on first launch and counts each app open — the
  /// account-age and app-open eligibility inputs. Fire-and-forget: the values
  /// aren't read until a session completes, well after launch.
  void _trackAppOpen() {
    if (_prefs.getAppInstallDay() == null) {
      unawaited(_prefs.setAppInstallDay(_nowMs));
    }
    unawaited(_prefs.setReviewAppOpenCount(_prefs.getReviewAppOpenCount() + 1));
  }

  void dispose() {
    _stableTimer?.cancel();
    _statusDisposer?.call();
    _statusDisposer = null;
    _authDisposer?.call();
    _authDisposer = null;
    _teardownDisposer?.call();
    _teardownDisposer = null;
  }

  /// Drives the session lifecycle off the VPN connection status. Public for
  /// tests; in production it's wired to a reaction on [VpnStore.vpnStatus].
  @visibleForTesting
  void handleConnectionStatus(VpnConnectionStatus status) {
    switch (status) {
      case VpnConnectionStatus.connected:
        _sessionAttempted = true;
        _sessionStable = false;
        _stableTimer?.cancel();
        // Wall-clock timer: if the app is backgrounded the isolate is suspended
        // and this fires late on resume. We re-check the status in the callback,
        // so the only effect is counting background time toward "stable" — an
        // accepted trade-off for this prompt.
        _stableTimer = Timer(Duration(seconds: _config.stableSessionSeconds), () {
          if (_vpnStore.vpnStatus == VpnConnectionStatus.connected) {
            _sessionStable = true;
            unawaited(recordSuccessfulSession());
          }
        });
      case VpnConnectionStatus.connecting:
        // A fresh attempt (or auto-reconnect): mark the attempt and wait for
        // `connected`. Stability resets; the attempt flag persists until the
        // session settles on `disconnected`.
        _sessionAttempted = true;
        _sessionStable = false;
        _stableTimer?.cancel();
      case VpnConnectionStatus.unknown:
        break;
      case VpnConnectionStatus.disconnecting:
        // Transitional; the session outcome is settled on `disconnected`.
        break;
      case VpnConnectionStatus.disconnected:
        _stableTimer?.cancel();
        final teardown = _vpnStore.disconnectReason;
        // Transitional; the following `connecting` resets the session.
        if (teardown == VpnDisconnectReason.reconnect) {
          break;
        }
        if (_sessionStable) {
          // A successful, stable session has completed — per the ticket the
          // eligibility check runs now, while disconnected (never while
          // connected/connecting). App-initiated teardowns fall through here so
          // the suppression is reported rather than passing silently.
          unawaited(evaluate());
        } else if (_sessionAttempted && teardown == VpnDisconnectReason.user) {
          // An attempt ended without reaching stability: either connected then
          // dropped early, or a connection error that never established. Both
          // count as an unclean recent session (ticket: "no disconnects or
          // connection errors in the last 3 sessions"). The cumulative
          // successful-connections counter is deliberately left untouched.
          unawaited(recordSessionOutcome(success: false));
        }
        _sessionAttempted = false;
        _sessionStable = false;
    }
  }

  /// Record a stable, successful session: bump the connection counter and push
  /// a success outcome. Eligibility is evaluated when the session *completes*
  /// (on disconnect), not here, so the prompt never surfaces while connected.
  @action
  Future<void> recordSuccessfulSession() async {
    await _prefs.setReviewSuccessfulConnections(_prefs.getReviewSuccessfulConnections() + 1);
    await recordSessionOutcome(success: true);
  }

  /// Append a session outcome, keeping only the window the eligibility check
  /// needs (the most recent [ReviewPromptConfig.cleanSessionsRequired]).
  @action
  Future<void> recordSessionOutcome({required bool success}) async {
    final window = _config.cleanSessionsRequired;
    final outcomes = [..._prefs.getReviewRecentSessionOutcomes(), success];
    final trimmed = outcomes.length > window
        ? outcomes.sublist(outcomes.length - window)
        : outcomes;
    await _prefs.setReviewRecentSessionOutcomes(trimmed);
  }

  /// Run eligibility, then suppression. Fires the matching analytics events and
  /// sets [pendingPrompt] when the prompt should be shown.
  @action
  Future<void> evaluate() async {
    if (pendingPrompt) {
      return;
    }
    if (!isEligible) {
      return;
    }
    await _analytics.logEvent(AnalyticsEvent.reviewPromptEligible);

    final reason = await _blockedReason();
    if (reason != null) {
      await _analytics.logEvent(
        AnalyticsEvent.reviewPromptSuppressed,
        parameters: {'reason': reason},
      );
      return;
    }
    pendingPrompt = true;
  }

  /// What blocks the prompt right now, or null if nothing does.
  Future<String?> _blockedReason() async {
    final reason = suppressionReason;
    if (reason != null) {
      return reason;
    }
    // No point starting the flow if we can't ultimately open the native review.
    if (!await _canShowNativeReview()) {
      return 'native_review_unavailable';
    }
    return suppressionReason; // Re-check: the probe above is async.
  }

  // ─── Eligibility ─────────────────────────────────────────────────────────

  // Not @computed: this derives from SharedPreferences (non-observable), so a
  // memoized computed would go stale as the counters grow and only refresh on
  // restart. A plain getter re-reads the live values on every evaluate.
  bool get isEligible =>
      _isOldEnough &&
      _prefs.getReviewAppOpenCount() >= _config.minAppOpens &&
      _prefs.getReviewSuccessfulConnections() >= _config.minConnections &&
      _hasCleanRecentSessions;

  bool get _isOldEnough {
    final installDay = _prefs.getAppInstallDay();
    if (installDay == null) {
      return false;
    }
    final ageMinutes = (_nowMs - installDay) / Duration.millisecondsPerMinute;
    return ageMinutes >= _config.minAccountAgeMinutes;
  }

  bool get _hasCleanRecentSessions {
    final required = _config.cleanSessionsRequired;
    if (required <= 0) {
      return true;
    }
    final outcomes = _prefs.getReviewRecentSessionOutcomes();
    final recent = outcomes.length >= required
        ? outcomes.sublist(outcomes.length - required)
        : outcomes;
    return recent.length >= required && recent.every((it) => it);
  }

  // ─── Suppression ───────────────────────────────────────────────────────────

  /// A machine-readable reason the prompt is blocked, or `null` if clear.
  /// Only meaningful when [isEligible] is `true`.
  ///
  /// Evaluated at a session end — the teardown reasons name the disconnect that
  /// just completed.
  ///
  /// Not @computed: it reads SharedPreferences and VPN status that aren't all
  /// MobX observables, so a memoized value could go stale. See [isEligible].
  String? get suppressionReason {
    if (!_config.enabled) {
      return 'disabled';
    }
    if (!_authSessionStore.isAuthenticated) {
      return 'unauthenticated';
    }
    if (_subscriptionStore.isPaused) {
      return 'subscription_paused';
    }
    final teardown = _vpnStore.disconnectReason;
    if (teardown.isAppInitiated) {
      return teardown == VpnDisconnectReason.logout ? 'logout' : 'app_disconnect';
    }
    if (_vpnStore.vpnStatus == VpnConnectionStatus.connecting) {
      return 'vpn_connecting';
    }
    if (_vpnStore.vpnStatus == VpnConnectionStatus.connected) {
      return 'vpn_connected';
    }
    if (_didCrashRecently()) {
      return 'recent_crash';
    }
    if (_isCooldownActive) {
      return 'cooldown_active';
    }
    if (_isYearlyCapReached) {
      return 'yearly_cap';
    }
    if (_wasNativeReviewOpenedRecently) {
      return 'native_review_recent';
    }
    return null;
  }

  bool get _isCooldownActive {
    final until = _prefs.getReviewCooldownUntil();
    return until != null && _nowMs < until;
  }

  bool get _isYearlyCapReached {
    final cap = _config.yearlyCap;
    // A cap of 0 disables the limit (consistent with the other "0 = off" knobs),
    // rather than meaning "never show".
    return cap > 0 && _recentShownTimestamps().length >= cap;
  }

  /// Prompt-display timestamps within the trailing 365 days.
  List<int> _recentShownTimestamps() {
    final yearAgo = _nowMs - 365 * Duration.millisecondsPerDay;
    return _prefs.getReviewPromptShownTimestamps().where((it) => it >= yearAgo).toList();
  }

  bool get _wasNativeReviewOpenedRecently {
    final openedAt = _prefs.getReviewNativeReviewOpenedAt();
    if (openedAt == null) {
      return false;
    }
    return _nowMs - openedAt < _config.cooldownPositiveMinutes * Duration.millisecondsPerMinute;
  }

  // ─── Modal action handlers ──────────────────────────────────────────────────

  /// Called when the prompt was eligible but a blocking flow (onboarding,
  /// paywall/checkout, subscription, cancellation, …) is on top of the home
  /// screen at show time. Clears [pendingPrompt] and records the suppression;
  /// it will be re-evaluated after the next completed session.
  @action
  Future<void> onSuppressedByActiveFlow() async {
    pendingPrompt = false;
    await _analytics.logEvent(
      AnalyticsEvent.reviewPromptSuppressed,
      parameters: {'reason': 'flow_active'},
    );
  }

  /// The satisfaction modal has been displayed. Records the display against the
  /// yearly cap and clears [pendingPrompt]. Also writes a baseline (dismissal)
  /// cooldown immediately: it guarantees that abandoning the flow at any stage
  /// (or killing the app) still defers the prompt, and closes the re-entrancy
  /// window where a session completing while the dialog is open could enqueue a
  /// second prompt. Terminal actions overwrite it with their specific duration.
  @action
  Future<void> onShown() async {
    pendingPrompt = false;
    await _analytics.logEvent(AnalyticsEvent.reviewPromptShown);
    await _prefs.setReviewPromptShownTimestamps([..._recentShownTimestamps(), _nowMs]);
    await _setCooldown(_config.cooldownDismissMinutes);
  }

  /// User tapped "Yes" — opens the positive (leave-a-review) modal next.
  @action
  Future<void> onSatisfactionYes() =>
      _analytics.logEvent(AnalyticsEvent.reviewPromptPositiveClicked);

  /// User tapped "No" — the support/feedback flow opens. Starts the negative
  /// cooldown.
  @action
  Future<void> onSatisfactionNo() async {
    await _analytics.logEvent(AnalyticsEvent.reviewPromptNegativeClicked);
    await _analytics.logEvent(AnalyticsEvent.feedbackFlowOpened);
    await _startCooldown(_config.cooldownNegativeMinutes);
  }

  /// User tapped "Leave a review" — the native store prompt opens. Records the
  /// native-review timestamp and starts the positive cooldown.
  @action
  Future<void> onLeaveReview() async {
    await _analytics.logEvent(AnalyticsEvent.nativeReviewPromptOpened);
    await _prefs.setReviewNativeReviewOpenedAt(_nowMs);
    await _startCooldown(_config.cooldownPositiveMinutes);
  }

  /// User dismissed the prompt ("Not now", close, or tap-away). Starts the
  /// short dismissal cooldown.
  @action
  Future<void> onDismiss() async {
    await _analytics.logEvent(AnalyticsEvent.reviewPromptDismissed);
    await _startCooldown(_config.cooldownDismissMinutes);
  }

  /// Clears all persisted review-prompt state. QA-only, exposed through the QA
  /// toolbox so the flow can be re-tested without reinstalling.
  @action
  Future<void> resetState() async {
    pendingPrompt = false;
    await _prefs.resetReviewPromptState();
  }

  /// Persists the cooldown without emitting analytics — used for the baseline
  /// cooldown set when the prompt is shown.
  Future<void> _setCooldown(int minutes) =>
      _prefs.setReviewCooldownUntil(_nowMs + minutes * Duration.millisecondsPerMinute);

  /// Persists the cooldown for an explicit user action and emits the event.
  Future<void> _startCooldown(int minutes) async {
    await _setCooldown(minutes);
    await _analytics.logEvent(AnalyticsEvent.reviewPromptCooldownStarted);
  }
}
