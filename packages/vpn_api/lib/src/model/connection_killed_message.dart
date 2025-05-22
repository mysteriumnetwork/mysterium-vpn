//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'connection_killed_message.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ConnectionKilledMessage {
  /// Returns a new [ConnectionKilledMessage] instance.
  ConnectionKilledMessage({
    required this.reason,
  });

  @JsonKey(
    name: r'reason',
    required: true,
    includeIfNull: false,
  )
  final ConnectionKilledMessageReasonEnum reason;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ConnectionKilledMessage && other.reason == reason;

  @override
  int get hashCode => reason.hashCode;

  factory ConnectionKilledMessage.fromJson(Map<String, dynamic> json) =>
      _$ConnectionKilledMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ConnectionKilledMessageToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

enum ConnectionKilledMessageReasonEnum {
  @JsonValue(r'disconnect_all')
  disconnectAll(r'disconnect_all'),
  @JsonValue(r'connection_limit')
  connectionLimit(r'connection_limit');

  const ConnectionKilledMessageReasonEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
