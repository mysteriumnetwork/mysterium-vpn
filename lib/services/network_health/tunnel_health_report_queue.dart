import 'dart:convert';

import 'package:mysterium_vpn/common/enums/storage_keys.dart';
import 'package:mysterium_vpn/services/data/local/shared_preferences_service.dart';
import 'package:talker/talker.dart';
import 'package:vpn_api/vpn_api.dart';

/// How long a queued report stays worth sending. A report about a session the
/// user left days ago tells the backend little.
const _maxAge = Duration(days: 3);

/// Cap on queued reports, oldest dropped first. The queue only grows while
/// reports cannot be delivered, so a runaway queue means a persistent problem,
/// not a backlog worth keeping.
const _maxEntries = 20;

/// Holds broken-node reports that could not be delivered.
///
/// The report travels over the authenticated API connection, which is **not**
/// excluded from the tunnel route — so a report about a degraded tunnel is sent
/// through that same degraded tunnel and will usually fail. Without a queue the
/// reports worth having are exactly the ones lost.
class TunnelHealthReportQueue {
  const TunnelHealthReportQueue(this._prefs, this._logger);

  final SharedPreferenceService _prefs;
  final Talker _logger;

  /// Queues [request], replacing any earlier entry for the same session.
  ///
  /// [queuedAt] carries the original timestamp when a drained report is being
  /// put back. Without it every retry would reset the clock and a report
  /// retried often enough would outlive [_maxAge] indefinitely.
  Future<void> add(
    ReportBrokenNodeRequest request, {
    required DateTime now,
    DateTime? queuedAt,
  }) async {
    final entries = _read(now: now)
      ..removeWhere((it) => it.request.sessionId == request.sessionId)
      ..add(_Entry(request: request, queuedAt: queuedAt ?? now));

    while (entries.length > _maxEntries) {
      entries.removeAt(0);
    }
    await _write(entries);
    _logger.info('Queued broken node report for ${request.sessionId} (${entries.length} pending)');
  }

  /// Hands back everything still worth sending and empties the queue.
  ///
  /// Entries are removed before the caller tries to send them: a failed send
  /// re-queues through [add], so a permanently undeliverable report cannot pin
  /// the queue open.
  Future<List<QueuedReport>> drain({required DateTime now}) async {
    final entries = _read(now: now);
    if (entries.isEmpty) {
      return const [];
    }
    await _write(const []);

    return entries.map((it) => QueuedReport(it.request, it.queuedAt)).toList();
  }

  List<_Entry> _read({required DateTime now}) {
    final raw = _prefs.getStringList(StorageKeys.tunnelHealthPendingReports.name) ?? const [];

    return raw
        .map((it) => _Entry.tryParse(it, _logger))
        .nonNulls
        .where((it) => now.difference(it.queuedAt) < _maxAge)
        .toList();
  }

  Future<void> _write(List<_Entry> entries) async {
    await _prefs.setStringList(
      StorageKeys.tunnelHealthPendingReports.name,
      entries.map((it) => jsonEncode(it.toJson())).toList(),
    );
  }
}

/// A drained report and when it first failed, so a requeue can keep its age.
class QueuedReport {
  const QueuedReport(this.request, this.queuedAt);

  final ReportBrokenNodeRequest request;
  final DateTime queuedAt;
}

class _Entry {
  const _Entry({required this.request, required this.queuedAt});

  static _Entry? tryParse(String raw, Talker logger) {
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final request = json['request'] as Map<String, dynamic>;
      final queuedAt = json['queuedAt'] as int;

      return _Entry(
        request: ReportBrokenNodeRequest.fromJson(request),
        queuedAt: DateTime.fromMillisecondsSinceEpoch(queuedAt),
      );
    } catch (e) {
      // A shape change between app versions must not wedge the queue.
      logger.warning('Dropping unreadable queued report: $e');
      return null;
    }
  }

  final ReportBrokenNodeRequest request;
  final DateTime queuedAt;

  Map<String, dynamic> toJson() => {
    'request': request.toJson(),
    'queuedAt': queuedAt.millisecondsSinceEpoch,
  };
}
