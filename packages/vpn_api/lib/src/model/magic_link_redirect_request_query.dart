//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'magic_link_redirect_request_query.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MagicLinkRedirectRequestQuery {
  /// Returns a new [MagicLinkRedirectRequestQuery] instance.
  MagicLinkRedirectRequestQuery({
    required this.code,
    this.continueTo,
    this.redirectUrl,
  });

  @JsonKey(
    name: r'code',
    required: true,
    includeIfNull: false,
  )
  final String code;

  @JsonKey(
    name: r'continue_to',
    required: false,
    includeIfNull: false,
  )
  final String? continueTo;

  @JsonKey(
    name: r'redirect_url',
    required: false,
    includeIfNull: false,
  )
  final String? redirectUrl;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MagicLinkRedirectRequestQuery &&
          other.code == code &&
          other.continueTo == continueTo &&
          other.redirectUrl == redirectUrl;

  @override
  int get hashCode =>
      code.hashCode +
      (continueTo == null ? 0 : continueTo.hashCode) +
      (redirectUrl == null ? 0 : redirectUrl.hashCode);

  factory MagicLinkRedirectRequestQuery.fromJson(Map<String, dynamic> json) =>
      _$MagicLinkRedirectRequestQueryFromJson(json);

  Map<String, dynamic> toJson() => _$MagicLinkRedirectRequestQueryToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
