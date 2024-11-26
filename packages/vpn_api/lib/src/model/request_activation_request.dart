//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'request_activation_request.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RequestActivationRequest {
  /// Returns a new [RequestActivationRequest] instance.
  RequestActivationRequest({
    required this.id,
  });

  @JsonKey(
    name: r'id',
    required: true,
    includeIfNull: false,
  )
  final String id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is RequestActivationRequest && other.id == id;

  @override
  int get hashCode => id.hashCode;

  factory RequestActivationRequest.fromJson(Map<String, dynamic> json) =>
      _$RequestActivationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RequestActivationRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
