import 'dart:async';

import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class PerformanceMonitor with WidgetsBindingObserver {
  PerformanceMonitor._();
  static final PerformanceMonitor instance = PerformanceMonitor._();

  bool _activated = false;
  AppLifecycleState? _lastState;
  Trace? _warmStartTrace;

  Future<void> activate() async {
    if (_activated) {
      return;
    }
    _activated = true;
    await FirebasePerformance.instance.setPerformanceCollectionEnabled(!kDebugMode);
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> recordDeferredInit({
    required int firebaseInitMs,
    required int oneSignalInitMs,
    required int totalMs,
    Map<String, String> attributes = const {},
  }) async {
    try {
      final trace = FirebasePerformance.instance.newTrace('deferred_init');
      attributes.forEach(trace.putAttribute);
      await trace.start();
      trace
        ..setMetric('firebase_init_ms', firebaseInitMs)
        ..setMetric('onesignal_init_ms', oneSignalInitMs)
        ..setMetric('total_ms', totalMs);
      await trace.stop();
    } catch (_) {
      // Performance reporting must never fail the caller.
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final wasBackgrounded =
        _lastState == AppLifecycleState.paused || _lastState == AppLifecycleState.hidden;
    if (state == AppLifecycleState.resumed && wasBackgrounded) {
      unawaited(_traceWarmStart());
    }
    _lastState = state;
  }

  Future<void> _traceWarmStart() async {
    if (_warmStartTrace != null) {
      return;
    }
    try {
      final trace = FirebasePerformance.instance.newTrace('warm_start');
      await trace.start();
      _warmStartTrace = trace;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final t = _warmStartTrace;
        _warmStartTrace = null;
        await t?.stop();
      });
    } catch (_) {
      _warmStartTrace = null;
    }
  }
}
