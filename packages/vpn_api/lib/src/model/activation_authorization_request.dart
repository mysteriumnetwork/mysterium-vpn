//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'activation_authorization_request.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ActivationAuthorizationRequest {
  /// Returns a new [ActivationAuthorizationRequest] instance.
  ActivationAuthorizationRequest({
    required this.responseType,
    required this.clientId,
    required this.requestId,
  });

  @JsonKey(
    name: r'response_type',
    required: true,
    includeIfNull: false,
  )
  final ActivationAuthorizationRequestResponseTypeEnum responseType;

  @JsonKey(
    name: r'client_id',
    required: true,
    includeIfNull: false,
  )
  final ActivationAuthorizationRequestClientIdEnum clientId;

  @JsonKey(
    name: r'request_id',
    required: true,
    includeIfNull: false,
  )
  final String requestId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivationAuthorizationRequest &&
          other.responseType == responseType &&
          other.clientId == clientId &&
          other.requestId == requestId;

  @override
  int get hashCode => responseType.hashCode + clientId.hashCode + requestId.hashCode;

  factory ActivationAuthorizationRequest.fromJson(Map<String, dynamic> json) =>
      _$ActivationAuthorizationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ActivationAuthorizationRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

enum ActivationAuthorizationRequestResponseTypeEnum {
  @JsonValue(r'activation_none')
  activationNone(r'activation_none');

  const ActivationAuthorizationRequestResponseTypeEnum(this.value);

  final String value;

  @override
  String toString() => value;
}

enum ActivationAuthorizationRequestClientIdEnum {
  @JsonValue(r'web')
  web(r'web'),
  @JsonValue(r'app')
  app(r'app'),
  @JsonValue(r'extension')
  extension_(r'extension');

  const ActivationAuthorizationRequestClientIdEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
