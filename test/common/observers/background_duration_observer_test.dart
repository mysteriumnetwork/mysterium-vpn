import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/observers/background_duration_observer.dart';

class _Probe with WidgetsBindingObserver, BackgroundDurationObserver {
  _Probe(this._now);

  DateTime _now;
  final List<Duration> returns = [];
  int departures = 0;

  @override
  DateTime Function() get clock =>
      () => _now;

  void advance(Duration by) => _now = _now.add(by);

  @override
  void onReturnedToForeground(Duration backgroundedFor) => returns.add(backgroundedFor);

  @override
  void onLeftForeground() => departures++;
}

void main() {
  late _Probe probe;

  setUp(() => probe = _Probe(DateTime.utc(2026, 10, 15, 12)));

  void dispatch(List<AppLifecycleState> states) => states.forEach(probe.didChangeAppLifecycleState);

  test('reports the gap across the chain a real device emits', () {
    dispatch([AppLifecycleState.paused]);
    probe.advance(const Duration(minutes: 30));
    // ServicesBinding expands paused -> resumed into these three.
    dispatch([AppLifecycleState.hidden, AppLifecycleState.inactive, AppLifecycleState.resumed]);

    expect(probe.returns, [const Duration(minutes: 30)]);
  });

  test('works on desktop, where paused may never arrive', () {
    dispatch([AppLifecycleState.inactive]);
    probe.advance(const Duration(minutes: 30));
    dispatch([AppLifecycleState.resumed]);

    expect(probe.returns, [const Duration(minutes: 30)]);
  });

  test('the first departure wins, so the chain does not restart the clock', () {
    dispatch([AppLifecycleState.inactive]);
    probe.advance(const Duration(minutes: 30));
    dispatch([AppLifecycleState.hidden, AppLifecycleState.paused]);
    probe.advance(const Duration(minutes: 5));
    dispatch([AppLifecycleState.resumed]);

    expect(probe.returns, [const Duration(minutes: 35)]);
    expect(probe.departures, 1);
  });

  test('a cold start reports no return, so startup fetches are not doubled', () {
    // Flutter delivers a bare `resumed` with no preceding state.
    dispatch([AppLifecycleState.resumed]);

    expect(probe.returns, isEmpty);
  });

  test('a brief interruption is reported, not swallowed', () {
    dispatch([AppLifecycleState.inactive]);
    probe.advance(const Duration(seconds: 2));
    dispatch([AppLifecycleState.resumed]);

    // Callers apply their own minimum; the observer only measures.
    expect(probe.returns, [const Duration(seconds: 2)]);
  });

  test('a second cycle measures independently', () {
    dispatch([AppLifecycleState.paused]);
    probe.advance(const Duration(minutes: 10));
    dispatch([AppLifecycleState.resumed, AppLifecycleState.paused]);
    probe.advance(const Duration(minutes: 3));
    dispatch([AppLifecycleState.resumed]);

    expect(probe.returns, [const Duration(minutes: 10), const Duration(minutes: 3)]);
  });

  test('detached neither starts nor stops the clock', () {
    dispatch([AppLifecycleState.detached]);
    probe.advance(const Duration(minutes: 10));
    dispatch([AppLifecycleState.resumed]);

    expect(probe.returns, isEmpty);
  });
}
