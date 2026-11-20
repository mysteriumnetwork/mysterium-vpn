import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/discovery/block_signal.dart';
import 'package:mysterium_vpn/services/discovery/discovery_config.dart';
import 'package:mysterium_vpn/services/discovery/discovery_verifier.dart';
import 'package:talker/talker.dart';

/// Reports a discovery state change. Deliberately synchronous and
/// fire-and-forget: `record` sits on the request path and must not wait on an
/// analytics sink.
typedef DiscoveryReporter = void Function(AnalyticsEvent event, Map<String, dynamic> parameters);

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

  /// Per-candidate health check budget.
  static const probeTimeout = Duration(seconds: 3);

  /// Ceiling on a whole browser-URL resolution, so a tap never stalls longer.
  static const browserResolveTimeout = Duration(seconds: 6);

  final String? Function(String) _read;
  final Future<bool> Function(String, String) _write;
  final Dio _client;
  final Talker? _logger;
  final Future<bool> Function() _online;
  final DiscoveryTuning Function()? _tuning;
  final DiscoveryReporter? _report;
  DiscoveryTuning _settings = const DiscoveryTuning();
  DateTime? _settingsReadAt;
  final DateTime Function() _now;
  final Set<String> browserHosts;
  final List<String> sources;
  final DiscoveryVerifier verifier;
  final _records = <String, _DomainRecord>{};
  final _warmed = <String, DateTime>{};
  DiscoveryConfig? _config;
  DateTime? _lastAttempt;
  int _refreshFailures = 0;
  Future<void>? _refreshing;
  Future<void> _writing = Future.value();
  Future<void>? _loading;
  bool _closed = false;

  /// Remote tunables, cached.
  ///
  /// An unobserved MobX `@computed` is not memoised, so reading the ConfigCat
  /// value re-runs `jsonDecode` every time. This sits on the request path, so
  /// it is read at most once a minute — well inside what a kill switch needs.
  DiscoveryTuning get settings {
    final read = _tuning;
    if (read == null) {
      return _settings;
    }
    final readAt = _settingsReadAt;
    if (readAt == null || _now().difference(readAt) >= const Duration(minutes: 1)) {
      _settings = read();
      _settingsReadAt = _now();
    }
    return _settings;
  }

  /// Master switch. When off the service is inert at every entry point, so an
  /// operator flips one field rather than hunting for the ones that still
  /// touch the network.
  bool get enabled => settings.enabled;

  Duration get cooldown => settings.cooldown;

  Duration get refreshInterval => settings.refreshInterval;

  Duration get checkInterval => settings.checkInterval;

  bool supports(Uri uri) => uri.scheme == 'https' && uri.port == 443;

  Future<List<Uri>> cachedCandidates(Uri original) async {
    if (!enabled || !supports(original)) {
      return [original];
    }
    await _load();
    final alternatives = _config?.mappings[original.host];
    if (alternatives == null || alternatives.isEmpty) {
      // The common case: no rebuilt Uri, so Dio keeps the string it already has.
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

  /// Whether anything is currently known to be blocked: an origin served by a
  /// fallback, or one still inside its cooldown.
  ///
  /// Deliberately cross-origin — a blocked API is taken as evidence that the
  /// web host is blocked too, which is what keeps the browser path off the
  /// critical path for everyone else.
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
    // Nothing to remember and nothing remembered: the path every request of an
    // unblocked user takes, so it allocates no record and grows no map.
    if (success && candidate.host == original.host && !_records.containsKey(origin)) {
      return;
    }
    // Only a loaded config can prove a host has no alternatives. Without one the
    // evidence has to be kept: a failure is what triggers the first fetch.
    final alternatives = _config?.mappings[original.host];
    if (_config != null && (alternatives == null || alternatives.isEmpty)) {
      if (_records.remove(origin) != null) {
        await _save();
      }
      return;
    }
    final now = _now();
    final record = _records.putIfAbsent(origin, _DomainRecord.new);
    // Captured before the sweep and compared after the mutation, so one call
    // reports at most one transition. Without this an origin under a continuous
    // block would sweep a lapsed cooldown and add a fresh one in the same call,
    // reporting a recovery and a block every cycle.
    // Presence, not unexpiredness: a cooldown that lapsed without any success
    // in between is the same episode continuing, because nothing ever proved
    // the host came back.
    final wasFailing = record.failed.isNotEmpty;
    final hadPreferred = record.preferred != null;
    final cooling = record.failed.length;
    record.failed.removeWhere((_, until) => !until.isAfter(now));
    var changed = record.failed.length != cooling;
    if (success) {
      // `preferred` only ever names a fallback. The original already sorts
      // first, so storing it here would say nothing — and would keep `degraded`
      // latched on for good.
      final preferred = candidate.host == original.host ? null : candidate.host;
      changed = changed || record.preferred != preferred;
      record.preferred = preferred;
      // Evaluated before the flag, not inside it: on the right of a `||` the
      // removal is skipped whenever something already changed, and a host that
      // just answered would keep its cooldown.
      final cleared = record.failed.remove(candidate.host) != null;
      changed = changed || cleared;
    } else if (!record.failed.containsKey(candidate.host)) {
      // A host already cooling down does not slide its own cooldown, so an
      // outage costs one write rather than one per request.
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
    if (!changed) {
      return;
    }
    await _save();
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

  /// Reports that every candidate for [original] was tried and none answered.
  /// Only the caller knows that, so it cannot come from [record].
  void reportExhausted(Uri original, int candidates) =>
      _report?.call(AnalyticsEvent.domainFailoverExhausted, {
        'kind': browserHosts.contains(original.host) ? 'web' : 'api',
        'host': original.host,
        'candidates': candidates,
      });

  /// How long to wait before the next fetch. A refresh that failed is retried
  /// in seconds rather than at the full interval: the networks that block our
  /// domains tend to block GitHub too, and an hour of silence there strands
  /// exactly the users this feature exists for.
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
    _lastAttempt = _now();
    for (final source in sources) {
      final token = CancelToken();
      _logger?.info('[discovery] Fetching configuration from ${Uri.parse(source).origin}');
      try {
        _config = await _fetchConfig(source, token).timeout(
          const Duration(seconds: 3),
          onTimeout: () {
            token.cancel('Discovery timeout');
            throw TimeoutException('Discovery timeout');
          },
        );
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
      // Blocked and unable to bootstrap: the one case where this feature has
      // nothing to offer, so it is the one worth alerting on.
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
      'fetched_at': _lastAttempt?.toIso8601String(),
      'warmed': _warmed.map((host, at) => MapEntry(host, at.toIso8601String())),
      'records': _records.map(
        (origin, record) => MapEntry(origin, {
          'preferred': record.preferred,
          'failed': record.failed.map((host, until) => MapEntry(host, until.toIso8601String())),
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

  /// Health-checks the browser hosts off the critical path.
  ///
  /// Two jobs: it is the only thing that notices a blocked web host on a device
  /// whose API is fine, and it is the only thing that puts an origin back on
  /// its primary once a network stops blocking.
  Future<void> warmBrowserHosts() async {
    if (!enabled || checkInterval == Duration.zero) {
      return;
    }
    await _load();
    // Checked before probing: an offline launch must not probe, fetch a config
    // and burn a backoff slot only to throw the answer away.
    if (!await _online()) {
      return;
    }
    var checked = false;
    for (final host in browserHosts) {
      final original = Uri.https(host);
      if (_closed || !supports(original)) {
        continue;
      }
      // Persisted, so the interval is wall-clock rather than per launch: ten
      // launches in an hour cost one check, not ten.
      final last = _warmed[host];
      if (last != null && _now().difference(last) < checkInterval) {
        continue;
      }
      _warmed[host] = _now();
      checked = true;
      final outcome = await _probe(original);
      if (outcome.success) {
        await record(original, original, success: true, reason: outcome.reason);
        continue;
      }
      if (!outcome.blocked) {
        // A slow or flaky link proves nothing; recording it would latch
        // `degraded` and put every later link tap on the probe path.
        _logger?.info(
          '[discovery] Browser host check inconclusive: ${original.origin} (${outcome.reason})',
        );
        continue;
      }
      _logger?.warning(
        '[discovery] Browser host failed its background check: '
        '${original.origin} (${outcome.reason})',
      );
      await recordBrowserFailure(original, original, reason: outcome.reason);
    }
    if (checked) {
      await _save();
    }
  }

  /// Reports a browser navigation failure observed outside this service, such
  /// as a WebView main-frame error. [target] is the URL that actually failed,
  /// which may be a fallback; it is recorded against [original]'s origin so the
  /// ranking that reads it sees it.
  Future<void> recordBrowserFailure(
    Uri original,
    Uri target, {
    String reason = 'webview_error',
  }) async {
    if (!enabled || !browserHosts.contains(original.host) || !supports(original)) {
      return;
    }
    await _load();
    if (!await _online()) {
      return;
    }
    await candidatesAfterFailure(original);
    await record(original, target, success: false, reason: reason);
  }

  /// The browser URL to open, which is the one passed in unless something is
  /// known to be blocked.
  Future<Uri> resolveBrowserUrl(Uri original) async {
    if (!browserHosts.contains(original.host) || !supports(original)) {
      return original;
    }
    await _load();
    if (!degraded) {
      // Nothing has failed, so the primary is the answer and no user action
      // waits on a probe.
      return original;
    }
    // Wall-clock, not the injected clock: this caps how long a tap can stall.
    final clock = Stopwatch()..start();
    final tried = <String>{};
    var candidates = _browserCandidates(await cachedCandidates(original), original);
    var refreshed = false;
    while (candidates.isNotEmpty && clock.elapsed < browserResolveTimeout) {
      final candidate = candidates.removeAt(0);
      if (!tried.add(candidate.host)) {
        continue;
      }
      final outcome = await _probe(candidate);
      if (outcome.success || outcome.blocked) {
        await record(original, candidate, success: outcome.success, reason: outcome.reason);
      }
      if (outcome.success) {
        if (candidate.host != original.host) {
          _logger?.info(
            '[discovery] Browser fallback selected: ${original.origin} -> ${candidate.origin}',
          );
        }
        return candidate;
      }
      _logger?.warning(
        '[discovery] Browser endpoint failed health check: ${candidate.origin} '
        '(${outcome.reason})',
      );
      if (!refreshed) {
        refreshed = true;
        // The loop's own `tried` guard skips anything already attempted.
        candidates = _browserCandidates(await candidatesAfterFailure(original), original);
      }
    }
    // After giving up, the last host known to work beats the one we came in
    // with — by now it is the likelier of the two to be blocked.
    final preferred = _records[original.origin]?.preferred;
    final chosen = preferred == null ? original : original.replace(host: preferred);
    reportExhausted(original, tried.length);
    _logger?.warning('[discovery] No healthy browser domain found; using ${chosen.origin}');
    return chosen;
  }

  /// Fallbacks first, the original last: once something is known to be blocked,
  /// probing the primary first only buys the user a timeout, and a fallback is
  /// our own infrastructure either way.
  List<Uri> _browserCandidates(List<Uri> ranked, Uri original) => [
    ...ranked.where((uri) => uri.host != original.host),
    ...ranked.where((uri) => uri.host == original.host),
  ];

  /// Health-checks one candidate. The blocked flag separates interference
  /// from an ordinary bad connection, so a slow link costs no cooldown.
  Future<({bool success, bool blocked, String reason})> _probe(Uri candidate) async {
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
      final healthy = status == 200 && data is Map<String, dynamic> && data['status'] == 'OK';
      return (
        success: healthy,
        blocked: blockedByResponse(status, response.headers),
        reason: responseLabel(status),
      );
    } on DioException catch (error) {
      return (
        success: false,
        blocked: blockingTransport.contains(error.type),
        reason: transportLabel(error.type),
      );
    } on Exception catch (error) {
      return (success: false, blocked: false, reason: error.runtimeType.toString());
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
