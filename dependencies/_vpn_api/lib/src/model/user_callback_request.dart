//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'user_callback_request.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserCallbackRequest {
  /// Returns a new [UserCallbackRequest] instance.
  UserCallbackRequest({
    required this.gatewayId,
    this.payload,
    this.transactionId,
  });

  @JsonKey(
    name: r'gateway_id',
    required: true,
    includeIfNull: false,
  )
  final UserCallbackRequestGatewayIdEnum gatewayId;

  /// Purchase token from Google or Apple (deprecated) receipt data
  @JsonKey(
    name: r'payload',
    required: false,
    includeIfNull: false,
  )
  final String? payload;

  /// Transaction ID from Apple
  @JsonKey(
    name: r'transaction_id',
    required: false,
    includeIfNull: false,
  )
  final String? transactionId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserCallbackRequest &&
          other.gatewayId == gatewayId &&
          other.payload == payload &&
          other.transactionId == transactionId;

  @override
  int get hashCode =>
      gatewayId.hashCode +
      (payload == null ? 0 : payload.hashCode) +
      (transactionId == null ? 0 : transactionId.hashCode);

  factory UserCallbackRequest.fromJson(Map<String, dynamic> json) =>
      _$UserCallbackRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UserCallbackRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

enum UserCallbackRequestGatewayIdEnum {
  @JsonValue(r'apple')
  apple(r'apple'),
  @JsonValue(r'google')
  google(r'google');

  const UserCallbackRequestGatewayIdEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
