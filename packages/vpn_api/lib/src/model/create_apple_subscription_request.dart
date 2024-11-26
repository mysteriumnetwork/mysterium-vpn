//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'create_apple_subscription_request.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateAppleSubscriptionRequest {
  /// Returns a new [CreateAppleSubscriptionRequest] instance.
  CreateAppleSubscriptionRequest({
    required this.gatewayId,
    required this.planId,
  });

  @JsonKey(
    name: r'gateway_id',
    required: true,
    includeIfNull: false,
  )
  final CreateAppleSubscriptionRequestGatewayIdEnum gatewayId;

  @JsonKey(
    name: r'plan_id',
    required: true,
    includeIfNull: false,
  )
  final String planId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateAppleSubscriptionRequest &&
          other.gatewayId == gatewayId &&
          other.planId == planId;

  @override
  int get hashCode => gatewayId.hashCode + planId.hashCode;

  factory CreateAppleSubscriptionRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateAppleSubscriptionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateAppleSubscriptionRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

enum CreateAppleSubscriptionRequestGatewayIdEnum {
  @JsonValue(r'apple')
  apple(r'apple');

  const CreateAppleSubscriptionRequestGatewayIdEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
