import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';

part 'favorite_ip.freezed.dart';

part 'favorite_ip.g.dart';

/// A saved favorite IP shortcut. Stored app-side per user; identified by [ip].
@freezed
abstract class FavoriteIp with _$FavoriteIp {
  const factory FavoriteIp({
    required String ip,
    required String countryCode,
    required String city,
    required IPType ipType,
    required DateTime savedAt,
    // Display name captured at save time; empty for entries persisted before
    // the field existed (the country code is translated as a fallback).
    @Default('') String countryName,
    // Id of the location the user had picked when saving — the city id for a
    // city-level connection, the country code for a country-level one. Empty
    // for entries persisted before the field existed (treated as country).
    @Default('') String locationId,
  }) = _FavoriteIp;

  factory FavoriteIp.fromJson(Map<String, dynamic> json) => _$FavoriteIpFromJson(json);
}
