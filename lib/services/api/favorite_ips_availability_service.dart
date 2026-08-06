import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:vpn_api/vpn_api.dart';

/// Checks which favorite IPs are currently usable, keyed by IP address.
// ignore: one_member_abstracts
abstract class FavoriteIpsAvailabilityService {
  Future<Map<String, bool>> checkAvailability(List<String> ips);
}

/// Calls `POST /connection/ips-availability`.
///
/// Uses a raw Dio call because the generated client maps this endpoint's 200
/// response to the wrong schema (proxy credentials) — see the spec upstream.
/// The request body still uses the generated [IpsAvailabilityRequest].
class RestFavoriteIpsAvailabilityService implements FavoriteIpsAvailabilityService {
  const RestFavoriteIpsAvailabilityService(this._dio);

  final Dio _dio;

  @override
  Future<Map<String, bool>> checkAvailability(List<String> ips) async {
    final response = await _dio.post<Object>(
      '/connection/ips-availability',
      data: IpsAvailabilityRequest(ips: ips).toJson(),
    );
    return parseIpsAvailability(response.data, ips);
  }
}

/// Lenient parser for the availability response. Accepts an ip→bool map
/// (top-level or under `ips`), a list of available IPs, or a list of
/// `{ip, available}` objects. Unrecognized bodies treat every requested IP
/// as available so a contract change never bricks the favorites list.
@visibleForTesting
Map<String, bool> parseIpsAvailability(Object? body, List<String> requested) {
  final payload = body is Map && body['ips'] != null ? body['ips'] : body;

  if (payload is Map) {
    final entries = payload.entries.where((it) => it.value is bool);
    if (entries.isNotEmpty) {
      return {for (final entry in entries) entry.key.toString(): entry.value as bool};
    }
  }

  if (payload is List) {
    if (payload.every((it) => it is String)) {
      final available = payload.cast<String>().toSet();
      return {for (final ip in requested) ip: available.contains(ip)};
    }
    final result = <String, bool>{};
    for (final item in payload) {
      if (item is Map && item['ip'] is String) {
        result[item['ip'] as String] = item['available'] == true;
      }
    }
    if (result.isNotEmpty) {
      return result;
    }
  }

  return {for (final ip in requested) ip: true};
}
