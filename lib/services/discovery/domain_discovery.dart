import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/discovery/block_signal.dart';
import 'package:mysterium_vpn/services/discovery/discovery_config.dart';
import 'package:mysterium_vpn/services/discovery/discovery_verifier.dart';
import 'package:talker/talker.dart';

/// Reports a discovery state change; synchronous so `record` never waits on it.
typedef DiscoveryReporter = void Function(AnalyticsEvent event, Map<String, dynamic> parameters);

enum _Probe { healthy, blocked, silent, unhealthy }

class DomainDiscovery {
  DomainDiscovery({
    required String? Function(String) read,
    required Future<bool> Function(String, String) write,
    Dio? client,
    Talker? logger,
    Future<bool> Function()? online,
    DiscoveryTuning Function()? tuning,
    DiscoveryReporter? report,
    this.verifier = const DiscoveryVerifier(),
    DateTime Function()? now,
    this.browserHosts = const {},
    this.resolveTimeout = defaultResolveTimeout,
    this.sources = const [
      'https://static-resources-hub.github.io/config.json',
      'https://raw.githubusercontent.com/static-resources-hub/static-resources-hub.github.io/main/config.json',
    ],
  }) : _read = read,
       _write = write,
       _client = client ?? Dio(),
       _logger = logger,
       _online = online ?? (() async => true),
       _tuning = tuning,
       _report = report,
       _now = now ?? DateTime.now;

  static const cacheKey = 'domain_discovery_v1';
  static const probeTimeout = Duration(seconds: 3);
  static const defaultResolveTimeout = Duration(seconds: 6);

  /// Longest a link tap may wait on discovery.
  final Duration resolveTimeout;

  final String? Function(String) _read;
  final Future<bool> Function(String, String) _write;
  final Dio _client;
  final Talker? _logger;
  final Future<bool> Function() _online;
  final DiscoveryTuning Function()? _tuning;
  final DiscoveryReporter? _report;
  final DateTime Function() _now;
  final Set<String> browserHosts;
  final List<String> sources;
  final DiscoveryVerifier verifier;
  final _records = <String, _DomainRecord>{};
  final _warmed = <String, DateTime>{};
  final _exhausted = <String>{};
  DiscoveryConfig? _config;
  DateTime? _lastAttempt;
  int _refreshFailures = 0;
  Future<void>? _refreshing;
  Future<void> _writing = Future.value();
  Future<void>? _loading;
  bool _closed = false;

  // Read live: the store memoises the decode, and a kill switch must not lag.
  DiscoveryTuning get settings => _tuning?.call() ?? const DiscoveryTuning();

  bool get enabled => settings.enabled;

  Duration get cooldown => settings.cooldown;

  Duration get refreshInterval => settings.refreshInterval;

  Duration get checkInterval => settings.checkInterval;

  Future<bool> _isOnline() async {
    try {
      return await _online();
    } on Exception {
      return true;
    }
  }

  bool supports(Uri uri) => uri.scheme == 'https' && uri.port == 443;

  Future<List<Uri>> cachedCandidates(Uri original) async {
    if (!enabled || !supports(original)) {
      return [original];
    }
    await _load();
    final alternatives = _config?.mappings[original.host];
    if (alternatives == null || alternatives.isEmpty) {
      return [original];
    }
    final hosts = {original.host, ...alternatives}.toList();
    final record = _records[original.origin];
    final now = _now();
    int rank(String host) {
      if (record?.failed[host]?.isAfter(now) ?? false) {
        return 3;
      }
      if (host == original.host) {
        return 0;
      }
      return host == record?.preferred ? 1 : 2;
    }

    final ordered = hosts.indexed.toList()
      ..sort((a, b) {
        final comparison = rank(a.$2).compareTo(rank(b.$2));
        return comparison == 0 ? a.$1.compareTo(b.$1) : comparison;
      });
    return ordered.map((host) => original.replace(host: host.$2)).toList();
  }

  Future<List<Uri>> candidatesAfterFailure(Uri original) async {
    if (!enabled) {
      return [original];
    }
    await _load();
    if (!_closed && supports(original)) {
      await (_refreshing ??= _refresh().whenComplete(() => _refreshing = null));
    }
    return cachedCandidates(original);
  }

  /// Whether anything is known to be blocked. Cross-origin on purpose: a
  /// blocked API is taken as evidence that the web host is blocked too.
  bool get degraded => enabled && _records.values.any(_evidence);

  Future<void> record(
    Uri original,
    Uri candidate, {
    required bool success,
    String reason = 'unknown',
  }) async {
    if (!enabled || !supports(original)) {
      return;
    }
    await _load();
    final origin = original.origin;
    // The path every request of an unblocked user takes: nothing to remember.
    if (success && candidate.host == original.host && !_records.containsKey(origin)) {
      return;
    }
    // Without a network a failure says nothing about blocking.
    if (!success && !await _isOnline()) {
      return;
    }
    // Only a loaded config can prove a host has no alternatives.
    final alternatives = _config?.mappings[original.host];
    if (_config != null && (alternatives == null || alternatives.isEmpty)) {
      if (_records.remove(origin) != null) {
        await _save();
      }
      return;
    }
    if (success) {
      _exhausted.remove(origin);
    }
    final now = _now();
    final record = _records.putIfAbsent(origin, _DomainRecord.new);
    // Presence, not expiry: a cooldown that lapsed unanswered is the same episode.
    final wasFailing = record.failed.isNotEmpty;
    final hadPreferred = record.preferred != null;
    final cooling = record.failed.length;
    record.failed.removeWhere((_, until) => !until.isAfter(now));
    var changed = record.failed.length != cooling;
    if (success) {
      // Only ever a fallback: the original sorts first anyway.
      final preferred = candidate.host == original.host ? null : candidate.host;
      changed = changed || record.preferred != preferred;
      record.preferred = preferred;
      final cleared = record.failed.remove(candidate.host) != null;
      changed = changed || cleared;
    } else if (!record.failed.containsKey(candidate.host)) {
      // An existing cooldown does not slide.
      record.failed[candidate.host] = now.add(cooldown);
      changed = true;
    }
    _reportTransition(
      original,
      record,
      wasFailing: wasFailing,
      hadPreferred: hadPreferred,
      reason: reason,
    );
    if (changed) {
      await _save();
    }
  }

  bool _failing(_DomainRecord record) => record.failed.values.any((until) => until.isAfter(_now()));

  bool _evidence(_DomainRecord record) => record.preferred != null || _failing(record);

  void _reportTransition(
    Uri original,
    _DomainRecord record, {
    required bool wasFailing,
    required bool hadPreferred,
    required String reason,
  }) {
    final report = _report;
    if (report == null) {
      return;
    }
    final kind = browserHosts.contains(original.host) ? 'web' : 'api';
    final host = original.host;
    if (!wasFailing && _failing(record)) {
      report(AnalyticsEvent.domainBlockDetected, {'kind': kind, 'host': host, 'reason': reason});
    }
    if (!hadPreferred && record.preferred != null) {
      report(AnalyticsEvent.domainFailoverSucceeded, {
        'kind': kind,
        'host': host,
        'fallback': record.preferred,
      });
    }
    if ((wasFailing || hadPreferred) && !_evidence(record)) {
      report(AnalyticsEvent.domainDiscoveryRecovered, {'kind': kind, 'host': host});
    }
  }

  /// Every candidate was tried and none answered. Reported once per episode.
  Future<void> reportExhausted(Uri original, int candidates) async {
    if (candidates < 2 || _exhausted.contains(original.origin) || !await _isOnline()) {
      return;
    }
    _exhausted.add(original.origin);
    _report?.call(AnalyticsEvent.domainFailoverExhausted, {
      'kind': browserHosts.contains(original.host) ? 'web' : 'api',
      'host': original.host,
      'candidates': candidates,
    });
  }

  // A failed refresh retries in seconds: networks that block us block GitHub too.
  Duration get _refreshDelay {
    const backoff = [
      Duration(seconds: 30),
      Duration(minutes: 2),
      Duration(minutes: 8),
      Duration(minutes: 30),
    ];
    if (_refreshFailures == 0 || _refreshFailures > backoff.length) {
      return refreshInterval;
    }
    return backoff[_refreshFailures - 1];
  }

  Future<void> _refresh() async {
    final last = _lastAttempt;
    if (last != null && _now().difference(last) < _refreshDelay) {
      return;
    }
    if (!await _isOnline()) {
      return;
    }
    _lastAttempt = _now();
    for (final source in sources) {
      final token = CancelToken();
      _logger?.info('[discovery] Fetching configuration from ${Uri.parse(source).origin}');
      try {
        final fetched = await _fetchConfig(source, token).timeout(
          const Duration(seconds: 3),
          onTimeout: () {
            token.cancel('Discovery timeout');
            throw TimeoutException('Discovery timeout');
          },
        );
        if (fetched.version < (_config?.version ?? 0)) {
          throw const FormatException('Discovery configuration is older than the cached one');
        }
        _config = fetched;
        _logger?.info(
          '[discovery] Verified configuration from ${Uri.parse(source).origin}: '
          '${_config!.mappings.length} domain mappings',
        );
        _refreshFailures = 0;
        await _save();
        return;
      } on Exception catch (error) {
        _logger?.warning(
          '[discovery] Configuration fetch or verification failed for '
          '${Uri.parse(source).origin} (${error.runtimeType})',
        );
        // Preserve the previous configuration during discovery outages.
      }
      if (_closed) {
        return;
      }
    }
    _refreshFailures++;
    if (_config == null) {
      _report?.call(AnalyticsEvent.domainDiscoveryUnavailable, {'reason': 'sources_unreachable'});
    }
    _logger?.warning(
      '[discovery] Refresh failed; '
      '${_config == null ? 'no verified fallback configuration available' : 'keeping last verified configuration'}',
    );
  }

  Future<DiscoveryConfig> _fetchConfig(String source, CancelToken token) async {
    final response = await _client.get<ResponseBody>(
      source,
      options: Options(
        responseType: ResponseType.stream,
        followRedirects: false,
        validateStatus: (_) => true,
      ),
      cancelToken: token,
    );
    final body = response.data;
    if (response.statusCode != 200 || body == null) {
      await body?.stream.listen(null).cancel();
      throw const FormatException('Discovery requires HTTP 200');
    }
    final bytes = <int>[];
    await for (final chunk in body.stream) {
      if (bytes.length + chunk.length > 1 << 20) {
        token.cancel('Oversized discovery config');
        throw const FormatException('Discovery exceeds 1 MiB');
      }
      bytes.addAll(chunk);
    }
    return DiscoveryConfig.parse(utf8.decode(bytes), verifier: verifier, now: _now());
  }

  Future<void> _load() => _loading ??= _loadVerifiedCache();

  Future<void> _loadVerifiedCache() async {
    try {
      final raw = _read(cacheKey);
      if (raw == null || raw.length > 2 << 20) {
        return;
      }
      final json = jsonDecode(raw);
      if (json is! Map<String, dynamic>) {
        return;
      }
      final config = json['config'];
      if (config != null) {
        _config = await DiscoveryConfig.parse(
          jsonEncode(config),
          verifier: verifier,
          allowExpired: true,
          now: _now(),
        );
        _logger?.info(
          '[discovery] Loaded verified configuration from cache: '
          '${_config!.mappings.length} domain mappings'
          '${_config!.expiresAt.isAfter(_now()) ? '' : ' (expired; retained for offline recovery)'}',
        );
        final fetched = json['fetched_at'];
        if (fetched is String && _config!.expiresAt.isAfter(_now())) {
          _lastAttempt = DateTime.tryParse(fetched);
        }
      }
      final warmed = json['warmed'];
      if (warmed is Map<String, dynamic>) {
        for (final entry in warmed.entries) {
          final value = entry.value;
          final at = value is String ? DateTime.tryParse(value) : null;
          if (at != null) {
            _warmed[entry.key] = at;
          }
        }
      }
      final records = json['records'];
      if (records is Map<String, dynamic>) {
        for (final entry in records.entries) {
          final value = entry.value;
          if (value is! Map<String, dynamic>) {
            continue;
          }
          final record = _DomainRecord();
          final preferred = value['preferred'];
          if (preferred is String) {
            record.preferred = preferred;
          }
          final failures = value['failed'];
          if (failures is Map<String, dynamic>) {
            for (final failure in failures.entries) {
              final date = failure.value;
              final until = date is String ? DateTime.tryParse(date) : null;
              if (until != null) {
                record.failed[failure.key] = until;
              }
            }
          }
          _records[entry.key] = record;
        }
      }
    } on Exception catch (error) {
      _logger?.warning('[discovery] Ignoring invalid or unreadable cache (${error.runtimeType})');
      // Storage failures must not prevent requests.
    }
  }

  Future<void> _save() {
    final json = jsonEncode({
      'config': _config?.json,
      'fetched_at': _utc(_lastAttempt),
      'warmed': _warmed.map((host, at) => MapEntry(host, _utc(at))),
      'records': _records.map(
        (origin, record) => MapEntry(origin, {
          'preferred': record.preferred,
          'failed': record.failed.map((host, until) => MapEntry(host, _utc(until))),
        }),
      ),
    });
    return _writing = _writing.then((_) async {
      try {
        await _write(cacheKey, json);
      } on Exception catch (error) {
        _logger?.warning('[discovery] Could not persist cache (${error.runtimeType})');
        // Keep using in-memory state if persistence is unavailable.
      }
    });
  }

  // UTC, so a persisted instant survives a time-zone change.
  String? _utc(DateTime? at) => at?.toUtc().toIso8601String();

  bool _due(String host) {
    final last = _warmed[host];
    return last == null || _now().difference(last) >= checkInterval;
  }

  /// Health-checks the browser hosts off the critical path: the only detector
  /// of a blocked web host on a device whose API is fine.
  Future<void> warmBrowserHosts() async {
    if (!enabled || checkInterval == Duration.zero) {
      return;
    }
    await _load();
    if (!await _isOnline()) {
      return;
    }
    var checked = false;
    for (final host in browserHosts) {
      final original = Uri.https(host);
      if (_closed || !supports(original) || !_due(host)) {
        continue;
      }
      _warmed[host] = _now();
      checked = true;
      final outcome = await _probe(original);
      switch (outcome.kind) {
        case _Probe.healthy:
          await record(original, original, success: true);
        case _Probe.blocked:
          await recordBrowserFailure(original, original, reason: outcome.reason);
        case _Probe.silent:
          // Only a fallback answering tells dropped packets from a bad link.
          final fallback = await _healthyFallback(original);
          if (fallback != null) {
            await record(original, original, success: false, reason: outcome.reason);
            await record(original, fallback, success: true);
          }
        case _Probe.unhealthy:
          break;
      }
      if (outcome.kind != _Probe.healthy) {
        _logger?.warning(
          '[discovery] Browser host failed its background check: '
          '${original.origin} (${outcome.reason})',
        );
      }
    }
    if (checked) {
      await _save();
    }
  }

  Future<Uri?> _healthyFallback(Uri original) async {
    for (final candidate in await candidatesAfterFailure(original)) {
      if (candidate.host != original.host && (await _probe(candidate)).kind == _Probe.healthy) {
        return candidate;
      }
    }
    return null;
  }

  /// Reports a navigation failure seen outside this service. [target] is the
  /// URL that failed, recorded against [original]'s origin.
  Future<void> recordBrowserFailure(
    Uri original,
    Uri target, {
    String reason = 'webview_error',
  }) async {
    if (!enabled || !browserHosts.contains(original.host) || !supports(original)) {
      return;
    }
    await _load();
    if (!await _isOnline()) {
      return;
    }
    await candidatesAfterFailure(original);
    await record(original, target, success: false, reason: reason);
  }

  /// The browser URL to open: [original] unless something is known to be blocked.
  Future<Uri> resolveBrowserUrl(Uri original) async {
    if (!browserHosts.contains(original.host) || !supports(original)) {
      return original;
    }
    await _load();
    if (!degraded) {
      return original;
    }
    return _probeCandidates(original)
        .timeout(resolveTimeout, onTimeout: () => _lastResort(original));
  }

  Future<Uri> _probeCandidates(Uri original) async {
    final ranked = await cachedCandidates(original);
    // The primary is re-checked first once per interval, or it would never
    // win a link back; otherwise probing it first only buys a timeout.
    final recheck = checkInterval > Duration.zero && _due(original.host);
    if (recheck) {
      _warmed[original.host] = _now();
      unawaited(_save());
    }
    var candidates = recheck ? ranked : _fallbacksFirst(ranked, original);
    final tried = <String>{};
    var refreshed = false;
    while (candidates.isNotEmpty) {
      final candidate = candidates.removeAt(0);
      if (!tried.add(candidate.host)) {
        continue;
      }
      final outcome = await _probe(candidate);
      if (outcome.kind == _Probe.healthy) {
        await record(original, candidate, success: true);
        if (candidate.host != original.host) {
          _logger?.info(
            '[discovery] Browser fallback selected: ${original.origin} -> ${candidate.origin}',
          );
        }
        return candidate;
      }
      if (outcome.kind == _Probe.blocked) {
        await record(original, candidate, success: false, reason: outcome.reason);
      }
      _logger?.warning(
        '[discovery] Browser endpoint failed health check: ${candidate.origin} '
        '(${outcome.reason})',
      );
      if (!refreshed) {
        refreshed = true;
        candidates = _fallbacksFirst(await candidatesAfterFailure(original), original);
      }
    }
    await reportExhausted(original, tried.length);
    final chosen = _lastResort(original);
    _logger?.warning('[discovery] No healthy browser domain found; using ${chosen.origin}');
    return chosen;
  }

  // Never a host the signed config no longer lists: the URL may carry a token.
  Uri _lastResort(Uri original) {
    final preferred = _records[original.origin]?.preferred;
    final listed = _config?.mappings[original.host]?.contains(preferred) ?? false;
    return listed ? original.replace(host: preferred) : original;
  }

  List<Uri> _fallbacksFirst(List<Uri> ranked, Uri original) => [
    ...ranked.where((uri) => uri.host != original.host),
    ...ranked.where((uri) => uri.host == original.host),
  ];

  // Silent means no answer at all, which alone cannot tell a block from a bad link.
  Future<({_Probe kind, String reason})> _probe(Uri candidate) async {
    final token = CancelToken();
    try {
      final health = candidate.replace(
        path: '/api/v1/healthcheck',
        query: '',
        fragment: '',
        userInfo: '',
      );
      final response = await _client
          .get<Object?>(
            health.toString(),
            options: Options(followRedirects: false, validateStatus: (_) => true),
            cancelToken: token,
          )
          .timeout(
            probeTimeout,
            onTimeout: () {
              token.cancel('Health check timeout');
              throw TimeoutException('Health check timeout');
            },
          );
      final status = response.statusCode ?? 0;
      final data = response.data;
      if (status == 200 && data is Map<String, dynamic> && data['status'] == 'OK') {
        return (kind: _Probe.healthy, reason: responseLabel(status));
      }
      final blocked = blockedByResponse(status, response.headers);
      return (kind: blocked ? _Probe.blocked : _Probe.unhealthy, reason: responseLabel(status));
    } on DioException catch (error) {
      final blocked = blockedByTransport(error);
      return (kind: blocked ? _Probe.blocked : _Probe.silent, reason: transportLabel(error));
    } on Exception {
      return (kind: _Probe.silent, reason: 'timeout');
    }
  }

  void close() {
    _closed = true;
    _client.close(force: true);
  }
}

class _DomainRecord {
  String? preferred;
  final failed = <String, DateTime>{};
}
