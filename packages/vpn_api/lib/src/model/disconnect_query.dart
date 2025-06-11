//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'disconnect_query.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DisconnectQuery {
  /// Returns a new [DisconnectQuery] instance.
  DisconnectQuery({
    required this.publicKey,
  });

  /// Public key of the Wireguard connection
  @JsonKey(
    name: r'public_key',
    required: true,
    includeIfNull: false,
  )
  final String publicKey;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is DisconnectQuery && other.publicKey == publicKey;

  @override
  int get hashCode => publicKey.hashCode;

  factory DisconnectQuery.fromJson(Map<String, dynamic> json) => _$DisconnectQueryFromJson(json);

  Map<String, dynamic> toJson() => _$DisconnectQueryToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
