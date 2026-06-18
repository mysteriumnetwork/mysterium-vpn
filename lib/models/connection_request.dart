import 'package:flutter/foundation.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/ip_info.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/models/user_intent.dart';

/// Derives backend connection params from a user selection and intent.
@immutable
class ConnectionRequest {
  const ConnectionRequest({this.location, this.intent});

  /// Explicit user selection (country or city). Null for intent-only / best-server.
  final VPNLocation? location;
  final UserIntent? intent;

  bool get isNearest => intent == UserIntent.nearestLocation;

  bool get requiresCluster => intent?.requiresCluster ?? false;

  /// A country (or no explicit location) leaves city null so the backend can
  /// rotate across the country; only an explicit city pins a city.
  String? get city => (isNearest || (location?.isCountry ?? true)) ? null : location?.id;

  String? country(IPInfo? realIpInfo) => isNearest ? realIpInfo?.country : location?.countryCode;

  /// [nearestFallback] is consumed only for the nearest intent. Keep the gate here.
  IPType? ipType(IPType? nearestFallback) =>
      location?.ipType ?? (isNearest ? nearestFallback : null);
}
