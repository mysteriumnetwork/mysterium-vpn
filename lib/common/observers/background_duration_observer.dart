import 'package:flutter/widgets.dart';

/// Reports how long the app spent away from the foreground. Mix in alongside
/// [WidgetsBindingObserver]; the host still owns `addObserver`.
///
/// Any non-`resumed` state starts the clock, first one wins. Gating on a
/// previous `paused` never matches — `ServicesBinding` expands
/// `paused -> resumed` into `hidden -> inactive -> resumed`, and on desktop
/// `paused` may never arrive at all.
///
/// A brief `inactive` is reported as a short duration, not ignored: callers
/// apply their own minimum.
mixin BackgroundDurationObserver on WidgetsBindingObserver {
  DateTime? _backgroundedAt;

  /// Overridable so tests can simulate long absences without waiting.
  DateTime Function() get clock => DateTime.now;

  /// The app came back from the background. [backgroundedFor] is how long it
  /// was away.
  ///
  /// Deliberately does not fire at cold start, where Flutter delivers a bare
  /// `resumed` with no preceding state: startup paths do their own fetching,
  /// and firing here as well just duplicates it.
  void onReturnedToForeground(Duration backgroundedFor);

  /// The app left the foreground. Only fires on the first non-`resumed` state.
  void onLeftForeground() {}

  /// Seeds the clock for an observer registered after startup.
  ///
  /// No lifecycle callback is replayed on registration, so an observer added
  /// from deferred init while the app is already backgrounded would look
  /// foregrounded until a full cycle completes. Does not call
  /// [onLeftForeground]: nothing was started yet, so there is nothing to undo.
  void seedBackgroundState(AppLifecycleState? state) {
    if (_backgroundedAt == null && state != null && state != AppLifecycleState.resumed) {
      _backgroundedAt = clock();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        if (_backgroundedAt == null) {
          _backgroundedAt = clock();
          onLeftForeground();
        }
      case AppLifecycleState.resumed:
        final backgroundedAt = _backgroundedAt;
        _backgroundedAt = null;
        if (backgroundedAt != null) {
          onReturnedToForeground(clock().difference(backgroundedAt));
        }
      case AppLifecycleState.detached:
        break;
    }
  }
}
