//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:vpn_api/src/model/connection_message_location.dart';
import 'package:json_annotation/json_annotation.dart';

part 'connection_message.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ConnectionMessage {
  /// Returns a new [ConnectionMessage] instance.
  ConnectionMessage({
    required this.location,
  });

  @JsonKey(
    name: r'location',
    required: true,
    includeIfNull: false,
  )
  final ConnectionMessageLocation location;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ConnectionMessage && other.location == location;

  @override
  int get hashCode => location.hashCode;

  factory ConnectionMessage.fromJson(Map<String, dynamic> json) =>
      _$ConnectionMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ConnectionMessageToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
