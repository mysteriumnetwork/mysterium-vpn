import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mysterium_vpn/services/discovery/discovery_config.dart';
import 'package:mysterium_vpn/services/discovery/discovery_verifier.dart';
import 'package:talker/talker.dart';

class DomainDiscovery {
  DomainDiscovery({
    required String? Function(String) read,
    required Future<bool> Function(String, String) write,
    Dio? client,
    Talker? logger,
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
       _now = now ?? DateTime.now;

  static const cacheKey = 'domain_discovery_v1';
  static const refreshInterval = Duration(hours: 1);
  static const cooldown = Duration(minutes: 30);
  final String? Function(String) _read;
  final Future<bool> Function(String, String) _write;
  final Dio _client;
  final Talker? _logger;
  final DateTime Function() _now;
  final Set<String> browserHosts;
  final List<String> sources;
  final DiscoveryVerifier verifier;
  final _records = <String, _DomainRecord>{};
  DiscoveryConfig? _config;
  DateTime? _lastAttempt;
  Future<void>? _refreshing;
  Future<void> _writing = Future.value();
  Future<void>? _loading;
  bool _closed = false;

  bool supports(Uri uri) => uri.scheme == 'https' && uri.port == 443;

  Future<List<Uri>> cachedCandidates(Uri original) async {
    if (!supports(original)) {
      return [original];
    }
    await _load();
    final hosts = {original.host, ...?_config?.mappings[original.host]}.toList();
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
    await _load();
    if (!_closed && supports(original)) {
      await (_refreshing ??= _refresh().whenComplete(() => _refreshing = null));
    }
    return cachedCandidates(original);
  }

  Future<void> record(Uri original, Uri candidate, {required bool success}) async {
    if (!supports(original)) {
      return;
    }
    await _load();
    final record = _records.putIfAbsent(original.origin, _DomainRecord.new);
    record.failed.removeWhere((_, until) => !until.isAfter(_now()));
    if (success) {
      record.preferred = candidate.host;
      record.failed.remove(candidate.host);
    } else {
      record.failed[candidate.host] = _now().add(cooldown);
    }
    await _save();
  }

  Future<void> _refresh() async {
    final last = _lastAttempt;
    if (last != null && _now().difference(last) < refreshInterval) {
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

  Future<Uri> resolveBrowserUrl(Uri original) async {
    if (!browserHosts.contains(original.host) || !supports(original)) {
      return original;
    }
    final tried = <String>{};
    var candidates = await cachedCandidates(original);
    var refreshed = false;
    while (candidates.isNotEmpty) {
      final candidate = candidates.removeAt(0);
      if (!tried.add(candidate.host)) {
        continue;
      }
      final token = CancelToken();
      var success = false;
      var reason = 'unexpected health response';
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
              options: Options(followRedirects: false),
              cancelToken: token,
            )
            .timeout(
              const Duration(seconds: 5),
              onTimeout: () {
                token.cancel('Health check timeout');
                throw TimeoutException('Health check timeout');
              },
            );
        reason = 'HTTP ${response.statusCode}';
        final data = response.data;
        success =
            response.statusCode == 200 && data is Map<String, dynamic> && data['status'] == 'OK';
      } on Exception catch (error) {
        reason = error is DioException ? error.type.name : error.runtimeType.toString();
        success = false;
      }
      await record(original, candidate, success: success);
      if (success) {
        if (candidate.host != original.host) {
          _logger?.info(
            '[discovery] Browser fallback selected: ${original.origin} -> ${candidate.origin}',
          );
        }
        return candidate;
      }
      _logger?.warning(
        '[discovery] Browser endpoint failed health check: ${candidate.origin} ($reason)',
      );
      if (!refreshed) {
        candidates = await candidatesAfterFailure(original);
        refreshed = true;
      }
    }
    _logger?.warning('[discovery] No healthy browser domain found; returning ${original.origin}');
    return original;
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
