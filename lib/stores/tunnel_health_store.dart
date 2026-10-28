import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/observers/background_duration_observer.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/remote_config/remote_config_store.dart';
import 'package:mysterium_vpn/stores/vpn_protocol_store.dart';
import 'package:mysterium_vpn/stores/vpn_store.dart';
import 'package:talker/talker.dart';

part 'tunnel_health_store.g.dart';

const _statsTimeout = Duration(seconds: 3);
const _aliveRxFloor = 512;

// ignore: library_private_types_in_public_api
class TunnelHealthStore = _TunnelHealthStore with _$TunnelHealthStore;

/// Checks on resume whether the tunnel is degraded relative to a path that
/// bypasses it, and raises a one-shot prompt per VPN session.
abstract class _TunnelHealthStore with Store, WidgetsBindingObserver, BackgroundDurationObserver {
  _TunnelHealthStore(
    this._probe,
    this._reporter,
    this._vpnStore,
    this._protocolStore,
    this._config,
    this._analytics,
    this._logger,
    this._isAuthenticated, {
    DateTime Function()? clock,
    Duration confirmDelay = const Duration(seconds: 3),
    void Function(VoidCallback)? schedule,
  }) : _clock = clock ?? DateTime.now,
       _confirmDelay = confirmDelay,
       // Injectable: a plain `test()` never pumps a frame, so a real
       // post-frame callback would never fire and the tests would hang.
       _schedule = schedule ?? _postFrame {
    WidgetsBinding.instance.addObserver(this);
    _logger.debug('Tunnel health store constructed, lifecycle observer registered');
    // Built once per signed-in session, which is the only retry a queued
    // report gets after a force quit — the resume check needs five minutes in
    // the background first, and the queue expires entries after three days.
    unawaited(_flush());
  }

  static void _postFrame(VoidCallback callback) {
    // scheduleFrame because addPostFrameCallback does not request one. A
    // desktop window regaining focus with nothing to repaint would otherwise
    // leave the check queued until some unrelated redraw came along.
    WidgetsBinding.instance
      ..addPostFrameCallback((_) => callback())
      ..scheduleFrame();
  }

  final TunnelHealthProbe _probe;
  final TunnelHealthReporter _reporter;
  final VpnStore _vpnStore;
  final VpnProtocolStore _protocolStore;
  final RemoteConfigStore _config;
  final AnalyticsStore _analytics;
  final Talker _logger;

  /// Signed-in state. Probing and flushing both need a session: the probes are
  /// pointless on the login screen, and a flush there drains the queue only to
  /// have every report rejected as unauthenticated and dropped.
  final bool Function() _isAuthenticated;
  final DateTime Function() _clock;

  @override
  DateTime Function() get clock => _clock;
  final Duration _confirmDelay;
  final void Function(VoidCallback) _schedule;

  final Set<String> _reportedSessions = {};
  final Set<String> _dialogShownSessions = {};

  bool _disposed = false;

  /// Queued but not started, and started: mutually exclusive.
  bool _scheduled = false;
  bool _running = false;

  /// Bumped on leaving the foreground, to retire a post-frame callback that
  /// cannot be cancelled and no frame will run while backgrounded.
  int _generation = 0;

  /// A check earned but retired before it ran; the next resume is usually far
  /// too short to earn another, so the debt carries.
  bool _owed = false;

  /// Test seam: the in-flight check, so tests can await it without sleeping.
  @visibleForTesting
  Future<void> pendingCheck = Future<void>.value();

  @visibleForTesting
  bool get isDisposed => _disposed;

  /// Bumped once per degraded verdict worth prompting about. A counter, not a
  /// flag — see UdpBlockedSuggestionStore for why.
  @observable
  int degradationEpoch = 0;

  /// The session [degradationEpoch] last described. Plain field, not observable:
  /// the view reads it inside the reaction on the counter, never as a trigger.
  String? degradedSession;

  /// Bumped on every confirmed no-network verdict. Drives the snackbar.
  @observable
  int noNetworkEpoch = 0;

  /// Whether the dialog can offer a refresh, or only advise a country switch.
  ///
  /// A pool of 0 means the node count is unknown, not that there is nothing to
  /// refresh to, so only a known pool of exactly 1 hides the action.
  @computed
  bool get canRefreshIp => _vpnStore.connectedIpPoolCount != 1;

  /// Releases a check that was queued but never ran — without this, no frame
  /// after a resume would latch it for the rest of the process.
  @override
  void onLeftForeground() {
    _owed = _owed || _scheduled;
    _scheduled = false;
    _generation++;
  }

  @override
  void onReturnedToForeground(Duration backgroundedFor) => _maybeCheck(backgroundedFor);

  void _maybeCheck(Duration inactiveFor) {
    final settings = _config.tunnelHealthConfig;
    // Each gate says why it declined: a silent skip is indistinguishable from
    // a check that ran and found nothing.
    if (_disposed || !settings.enabled) {
      _logger.debug('Tunnel health skipped: ${_disposed ? 'disposed' : 'flag disabled'}');
      return;
    }
    if (!_isAuthenticated()) {
      _logger.debug('Tunnel health skipped: signed out');
      return;
    }
    final seconds = settings.minBackgroundSeconds;
    if (seconds <= 0) {
      _logger.debug('Tunnel health skipped: minBackgroundSeconds is 0, which disables it');
      return;
    }
    if (!_owed && inactiveFor < Duration(seconds: seconds)) {
      _logger.debug(
        'Tunnel health skipped: backgrounded ${inactiveFor.inSeconds}s, needs ${seconds}s',
      );
      return;
    }
    if (_scheduled || _running) {
      _logger.debug('Tunnel health skipped: a check is already in flight');
      return;
    }
    _logger.debug('Tunnel health check starting after ${inactiveFor.inSeconds}s backgrounded');
    _owed = false;
    _scheduled = true;
    // Post-frame so the warm-start frame paints before any network work.
    final completer = Completer<void>();
    final generation = _generation;
    pendingCheck = completer.future;
    _schedule(() {
      _scheduled = false;
      // Retired: a later resume queued its own callback, which measures now.
      if (generation != _generation) {
        completer.complete();
        return;
      }
      // A logout in the deferred frame would otherwise probe a dead VpnStore.
      if (_disposed) {
        completer.complete();
        return;
      }
      // Not just at the gate: two resumes can queue two callbacks.
      if (_running) {
        completer.complete();
        return;
      }
      _running = true;
      _run().whenComplete(() {
        _running = false;
        completer.complete();
      });
    });
  }

  Future<void> _run() async {
    // A reconnect mid-check must not spend the new session's report on the
    // old one's measurements.
    final startedOn = _gateKey;

    try {
      final first = await _evaluate();
      _logVerdict(first);
      unawaited(_flush());
      switch (first.verdict) {
        // The overwhelmingly common outcome; logging it would make this the
        // highest-volume event in the app.
        case TunnelHealthVerdict.healthy:
          return;
        case TunnelHealthVerdict.inconclusive:
        case TunnelHealthVerdict.bypassUnavailable:
          _logSuppressed(first.verdict.name);
          return;
        case TunnelHealthVerdict.degraded:
        case TunnelHealthVerdict.noNetwork:
          break;
      }

      await Future<void>.delayed(_confirmDelay);
      if (_disposed) {
        return;
      }
      // Only the degraded path needs a tunnel; noNetwork is valid either way.
      if (first.verdict == TunnelHealthVerdict.degraded && !_vpnStore.isConnected) {
        return;
      }

      final second = await _evaluate();
      _logVerdict(second, confirming: true);
      // The confirming probe can take seconds; a logout in that window must not
      // attribute analytics to a session the user already left.
      if (_disposed) {
        return;
      }
      if (_gateKey != startedOn) {
        _logSuppressed('session changed mid-check');
        return;
      }
      if (second.verdict != first.verdict) {
        _logSuppressed('unconfirmed');
        return;
      }

      if (second.verdict == TunnelHealthVerdict.noNetwork) {
        _onNoNetwork(controlReachable: second.sample.controlReachable);
        return;
      }
      _onDegraded(second);
    } catch (e, stack) {
      _logger.warning('Tunnel health check failed: $e\n$stack');
    }
  }

  /// Ungated on purpose: there is no session id to key on while disconnected,
  /// and the confirm step already filters blips.
  @action
  void _onNoNetwork({required bool controlReachable}) {
    _analytics.logEvent(
      AnalyticsEvent.tunnelHealthNoNetwork,
      parameters: {
        'connected': _vpnStore.isConnected,
        // A control IP that has moved turns every degraded tunnel into this
        // verdict; without the flag that is indistinguishable from a genuine
        // outage in the dashboard.
        'control_reachable': controlReachable,
      },
    );
    noNetworkEpoch++;
  }

  Future<_Evaluation> _evaluate() async {
    final connected = _vpnStore.isConnected;
    final exitIp = _vpnStore.vpnConnection?.connectionIP;

    // Only the connected path ever consults the counters, so with no tunnel up
    // both reads are a platform round-trip for a value nothing reads.
    final before = connected ? await _readStats() : null;
    final settings = _config.tunnelHealthConfig;
    final sample = await _probe.probe(exitIp: exitIp, controlIps: settings.controlIps);
    final after = connected ? await _readStats() : null;

    final tx = _bytes(before, after, upload: true);
    final rx = _bytes(before, after, upload: false);

    return (
      verdict: classifyTunnelHealth(
        sample: sample,
        tunnelCarriedData: _carriedData(tx, rx),
        degradedFloorMs: settings.degradedFloorMs,
        latencyRatioPercent: settings.latencyRatioPercent,
        connected: connected,
      ),
      sample: sample,
      txDelta: tx,
      rxDelta: rx,
      handshake: after?.latestHandshake,
    );
  }

  Future<TunnelStats?> _readStats() async {
    try {
      return await _vpnStore.tunnelStatistics().timeout(_statsTimeout);
    } catch (e) {
      _logger.warning('Tunnel stats unavailable for health check: $e');
      return null;
    }
  }

  int? _bytes(TunnelStats? before, TunnelStats? after, {required bool upload}) {
    if (before == null || after == null) {
      return null;
    }
    return upload
        ? after.totalUpload - before.totalUpload
        : after.totalDownload - before.totalDownload;
  }

  /// Whether the counters prove the tunnel moved data back. Only ever used to
  /// suppress a verdict. A negative delta means they reset mid-probe (a
  /// reconnect), which proves nothing either way.
  bool _carriedData(int? tx, int? rx) => tx != null && rx != null && tx >= 0 && rx >= _aliveRxFloor;

  /// Keys both the report and the dialog gate. Derived in one place so the
  /// two can never drift apart and silently break the once-per-session rule.
  String? get _gateKey {
    final connection = _vpnStore.vpnConnection;
    final key = connection?.sessionId ?? connection?.connectionIP;
    // The connection is briefly created with an empty IP, and recording '' in
    // the shown/reported sets would suppress every later connection observed
    // in that same transient state.
    return (key?.isNotEmpty ?? false) ? key : null;
  }

  @action
  void _onDegraded(_Evaluation evaluation) {
    final connection = _vpnStore.vpnConnection;
    final sessionId = connection?.sessionId;
    final gateKey = _gateKey;

    _analytics.logEvent(AnalyticsEvent.tunnelHealthDegraded, parameters: _params(evaluation));

    if (sessionId != null && _reportedSessions.add(sessionId)) {
      unawaited(
        _reporter
            .report(
              sessionId: sessionId,
              hash: connection?.hash ?? '',
              destinationCountry: connection?.location.countryCode ?? '',
              trigger: TunnelHealthTrigger.auto,
            )
            .catchError((Object e) => _logger.warning('Broken node report failed: $e')),
      );
    }

    // Claimed here rather than when the view opens the dialog: it can sit in
    // the dialog queue behind another one, and a second degradation meanwhile
    // would otherwise pass this gate and prompt twice for one session.
    if (gateKey != null && _dialogShownSessions.add(gateKey)) {
      // Recorded before the counter so the reaction can read it, and so the
      // view can tell whether the connection it is about to describe is still
      // the one that was diagnosed.
      degradedSession = gateKey;
      degradationEpoch++;
    }
  }

  /// Whether [session] is still the connection this store is attached to.
  /// The dialog can queue behind another one, by which point the session it
  /// describes may have been replaced or deliberately disconnected.
  bool isCurrentSession(String? session) => session != null && session == _gateKey;

  /// Called by the view once the dialog is actually on screen. The session was
  /// already claimed when the prompt was queued; this only records that it was
  /// shown.
  void onDialogShown() => _analytics.logEvent(AnalyticsEvent.tunnelHealthDialogShown);

  void onAction({required bool refreshed}) => _analytics.logEvent(
    AnalyticsEvent.tunnelHealthAction,
    parameters: {'action': refreshed ? 'refresh' : 'close'},
  );

  /// A healthy verdict raises nothing and logs no analytics, so without this
  /// there is no way to tell a passing check from one that never ran.
  ///
  /// Addresses are dev-only: `CrashlyticsLoggerObserver` forwards every Talker
  /// log to Crashlytics breadcrumbs regardless of level, and the direct leg
  /// returns the user's real public IP — that being the whole point of it.
  void _logVerdict(_Evaluation e, {bool confirming = false}) {
    final connection = _vpnStore.vpnConnection;
    final addresses = kDebugMode || Env.flavor.isDev
        ? 'sessionId=${connection?.sessionId} '
              'exitIp=${connection?.connectionIP} '
              'tunnelledIp=${e.sample.tunnelled.ip} '
              'directIp=${e.sample.direct.ip} '
        : '';

    _logger.info(
      'Tunnel health${confirming ? ' (confirm)' : ''}: ${e.verdict.name} '
      'tunnelled=${_leg(e.sample.tunnelled)} '
      'direct=${_leg(e.sample.direct)} '
      '$addresses'
      'hasHash=${connection?.hash?.isNotEmpty ?? false} '
      'bypassVerified=${e.sample.bypassVerified} '
      'controlReachable=${e.sample.controlReachable} '
      'tx=${e.txDelta ?? '-'} rx=${e.rxDelta ?? '-'}',
    );
  }

  /// A bare "fail" hides whether the leg timed out, could not resolve, or was
  /// refused — which are very different problems.
  String _leg(TunnelHealthLeg leg) =>
      leg.elapsed != null ? '${leg.elapsed!.inMilliseconds}ms' : 'FAIL(${leg.error})';

  void _logSuppressed(String reason) =>
      _analytics.logEvent(AnalyticsEvent.tunnelHealthSuppressed, parameters: {'reason': reason});

  // Nulls are dropped: the analytics sink stringifies values, so a missing
  // leg would otherwise ship the literal "null" for the field you most want.
  Map<String, dynamic> _params(_Evaluation e) => {
    'verdict': e.verdict.name,
    'tunnelled_ms': ?e.sample.tunnelled.elapsed?.inMilliseconds,
    'direct_ms': ?e.sample.direct.elapsed?.inMilliseconds,
    'tx_delta': ?e.txDelta,
    'rx_delta': ?e.rxDelta,
    'handshake_age_s': ?_handshakeAge(e.handshake),
    'protocol': _protocolStore.protocol.name,
    'ip_type': ?_vpnStore.vpnConnection?.location.ipType.name,
  };

  int? _handshakeAge(DateTime? handshake) =>
      handshake == null ? null : _clock().difference(handshake).inSeconds;

  /// Retries queued reports. Needs a session: without one the queue drains
  /// only for every report to be rejected as unauthenticated and dropped.
  Future<void> _flush() async {
    if (_disposed || !_isAuthenticated()) {
      return;
    }
    try {
      await _reporter.flushPending();
    } catch (e) {
      _logger.warning('Flushing queued reports failed: $e');
    }
  }

  void dispose() {
    _disposed = true;
    WidgetsBinding.instance.removeObserver(this);
    _reportedSessions.clear();
    _dialogShownSessions.clear();
  }
}

typedef _Evaluation = ({
  TunnelHealthVerdict verdict,
  TunnelHealthSample sample,
  int? txDelta,
  int? rxDelta,
  DateTime? handshake,
});
