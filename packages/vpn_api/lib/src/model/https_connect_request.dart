//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'https_connect_request.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class HttpsConnectRequest {
  /// Returns a new [HttpsConnectRequest] instance.
  HttpsConnectRequest({
    this.countryOriginate,
    this.country,
    this.ipType,
    this.resetConnection,
    this.osType,
  });

  @JsonKey(
    name: r'country_originate',
    required: false,
    includeIfNull: false,
  )
  final String? countryOriginate;

  @JsonKey(
    name: r'country',
    required: false,
    includeIfNull: false,
  )
  final String? country;

  @JsonKey(
    name: r'ip_type',
    required: false,
    includeIfNull: false,
  )
  final String? ipType;

  /// Request a new IP
  @JsonKey(
    name: r'reset_connection',
    required: false,
    includeIfNull: false,
  )
  final bool? resetConnection;

  @JsonKey(
    name: r'os_type',
    required: false,
    includeIfNull: false,
  )
  final String? osType;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HttpsConnectRequest &&
          other.countryOriginate == countryOriginate &&
          other.country == country &&
          other.ipType == ipType &&
          other.resetConnection == resetConnection &&
          other.osType == osType;

  @override
  int get hashCode =>
      (countryOriginate == null ? 0 : countryOriginate.hashCode) +
      (country == null ? 0 : country.hashCode) +
      (ipType == null ? 0 : ipType.hashCode) +
      (resetConnection == null ? 0 : resetConnection.hashCode) +
      (osType == null ? 0 : osType.hashCode);

  factory HttpsConnectRequest.fromJson(Map<String, dynamic> json) =>
      _$HttpsConnectRequestFromJson(json);

  Map<String, dynamic> toJson() => _$HttpsConnectRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
