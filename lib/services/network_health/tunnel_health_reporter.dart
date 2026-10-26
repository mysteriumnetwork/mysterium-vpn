import 'package:dio/dio.dart';
import 'package:mysterium_vpn/services/network_health/tunnel_health_report_queue.dart';
import 'package:talker/talker.dart';
import 'package:vpn_api/vpn_api.dart';

/// What prompted a broken-node report. `auto` is the resume-time health check;
/// `user` is reserved for a manual report action that does not exist yet.
enum TunnelHealthTrigger { auto, user }

/// Reports a node the health check found broken.
///
/// Callers supply only what they know about the session; the implementation
/// fills in the ambient device, network and app context.
abstract class TunnelHealthReporter {
  Future<void> report({
    required String sessionId,
    required String hash,
    required String destinationCountry,
    required TunnelHealthTrigger trigger,
  });

  /// Retries anything an earlier failure left queued.
  Future<void> flushPending();
}

/// Posts to `/connection/report-broken-node` via the generated client.
class RestTunnelHealthReporter implements TunnelHealthReporter {
  const RestTunnelHealthReporter({
    required Connection api,
    required Talker logger,
    required TunnelHealthReportQueue queue,
    required DateTime Function() clock,
    required Future<String> Function() publicKey,
    required String Function() deviceId,
    required String Function() originCountry,
    required Future<String> Function() internetType,
    required this.osType,
    required this.appVersion,
  }) : _api = api,
       _logger = logger,
       _queue = queue,
       _clock = clock,
       _publicKey = publicKey,
       _deviceId = deviceId,
       _originCountry = originCountry,
       _internetType = internetType;

  final Connection _api;
  final Talker _logger;
  final TunnelHealthReportQueue _queue;
  final DateTime Function() _clock;
  final Future<String> Function() _publicKey;
  final String Function() _deviceId;
  final String Function() _originCountry;
  final Future<String> Function() _internetType;
  final String osType;
  final String appVersion;

  @override
  Future<void> report({
    required String sessionId,
    required String hash,
    required String destinationCountry,
    required TunnelHealthTrigger trigger,
  }) async {
    // Independent lookups — secure storage and a platform channel.
    final context = await Future.wait([_publicKey(), _internetType()]);

    // Every field is required and non-nullable: the backend contract has no
    // `omitempty`, so an unknown value is sent as '' rather than omitted.
    final request = ReportBrokenNodeRequest(
      sessionId: sessionId,
      hash: hash,
      publicKey: context[0],
      deviceId: _deviceId(),
      destinationCountry: destinationCountry,
      originCountry: _originCountry(),
      osType: osType,
      internetType: context[1],
      appVersion: appVersion,
      trigger: switch (trigger) {
        TunnelHealthTrigger.auto => ReportBrokenNodeRequestTriggerEnum.auto,
        TunnelHealthTrigger.user => ReportBrokenNodeRequestTriggerEnum.user,
      },
    );

    await _send(request);
  }

  @override
  Future<void> flushPending() async {
    final pending = await _queue.drain(now: _clock());
    for (final queued in pending) {
      try {
        // Carries the original timestamp so a requeue keeps the report's age;
        // otherwise a report retried often enough never reaches _maxAge.
        await _send(queued.request, queuedAt: queued.queuedAt);
      } catch (e) {
        // Keep going: drain() already emptied the queue, so abandoning the
        // loop here would discard every report after the first failure.
        // A transport failure re-queues inside _send; anything else is a
        // rejection that would fail identically next time.
        _logger.warning('Queued report for ${queued.request.sessionId} still failing: $e');
      }
    }
  }

  /// Queues only transport failures. A backend answer means the request
  /// arrived and was rejected on its merits, so retrying it unchanged would
  /// fail the same way forever.
  ///
  /// [queuedAt] is set when replaying an already-queued report, to preserve its
  /// original age.
  Future<void> _send(ReportBrokenNodeRequest request, {DateTime? queuedAt}) async {
    try {
      await _api.reportBrokenNode(reportBrokenNodeRequest: request);
      _logger.info('Reported broken node for session ${request.sessionId}');
    } on DioException catch (e) {
      // No response means nothing reached the backend, so a retry is worth
      // having. The interceptors wrap everything into ApiException, which is
      // why that type carries the response through rather than dropping it.
      if (e.response == null) {
        await _queue.add(request, now: _clock(), queuedAt: queuedAt);
      }
      rethrow;
    }
  }
}
