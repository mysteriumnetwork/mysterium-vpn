//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'marketing_permissions_request.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MarketingPermissionsRequest {
  /// Returns a new [MarketingPermissionsRequest] instance.
  MarketingPermissionsRequest({
    required this.consent,
  });

  /// User's consent for marketing communications
  @JsonKey(
    name: r'consent',
    required: true,
    includeIfNull: false,
  )
  final bool consent;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MarketingPermissionsRequest && other.consent == consent;

  @override
  int get hashCode => consent.hashCode;

  factory MarketingPermissionsRequest.fromJson(Map<String, dynamic> json) =>
      _$MarketingPermissionsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MarketingPermissionsRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
