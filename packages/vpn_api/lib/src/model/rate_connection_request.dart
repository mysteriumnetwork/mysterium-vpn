//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'rate_connection_request.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RateConnectionRequest {
  /// Returns a new [RateConnectionRequest] instance.
  RateConnectionRequest({
    required this.country,
    required this.ipType,
    required this.publicKey,
    this.feedback,
    this.reasons = '',
    required this.mode,
  });

  /// Country code where the connection is made from
  @JsonKey(
    name: r'country',
    required: true,
    includeIfNull: false,
  )
  final String country;

  @JsonKey(
    name: r'ip_type',
    required: true,
    includeIfNull: false,
  )
  final String ipType;

  @JsonKey(
    name: r'public_key',
    required: true,
    includeIfNull: false,
  )
  final String publicKey;

  /// Feedback about the connection
  @JsonKey(
    name: r'feedback',
    required: false,
    includeIfNull: false,
  )
  final String? feedback;

  /// Reasons for the feedback
  @JsonKey(
    defaultValue: '',
    name: r'reasons',
    required: false,
    includeIfNull: false,
  )
  final String? reasons;

  /// Mode of the feedback
  @JsonKey(
    name: r'mode',
    required: true,
    includeIfNull: false,
  )
  final RateConnectionRequestModeEnum mode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RateConnectionRequest &&
          other.country == country &&
          other.ipType == ipType &&
          other.publicKey == publicKey &&
          other.feedback == feedback &&
          other.reasons == reasons &&
          other.mode == mode;

  @override
  int get hashCode =>
      country.hashCode +
      ipType.hashCode +
      publicKey.hashCode +
      (feedback == null ? 0 : feedback.hashCode) +
      reasons.hashCode +
      mode.hashCode;

  factory RateConnectionRequest.fromJson(Map<String, dynamic> json) =>
      _$RateConnectionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RateConnectionRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

/// Mode of the feedback
enum RateConnectionRequestModeEnum {
  /// Mode of the feedback
  @JsonValue(r'like')
  like(r'like'),

  /// Mode of the feedback
  @JsonValue(r'dislike')
  dislike(r'dislike');

  const RateConnectionRequestModeEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
