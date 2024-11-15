//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'create_google_subscription_request.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateGoogleSubscriptionRequest {
  /// Returns a new [CreateGoogleSubscriptionRequest] instance.
  CreateGoogleSubscriptionRequest({
    required this.gatewayId,
    required this.planId,
  });

  @JsonKey(
    name: r'gateway_id',
    required: true,
    includeIfNull: false,
  )
  final CreateGoogleSubscriptionRequestGatewayIdEnum gatewayId;

  @JsonKey(
    name: r'plan_id',
    required: true,
    includeIfNull: false,
  )
  final String planId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateGoogleSubscriptionRequest &&
          other.gatewayId == gatewayId &&
          other.planId == planId;

  @override
  int get hashCode => gatewayId.hashCode + planId.hashCode;

  factory CreateGoogleSubscriptionRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateGoogleSubscriptionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateGoogleSubscriptionRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

enum CreateGoogleSubscriptionRequestGatewayIdEnum {
  @JsonValue(r'google')
  google(r'google');

  const CreateGoogleSubscriptionRequestGatewayIdEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
