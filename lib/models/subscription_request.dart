// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_request.freezed.dart';
part 'subscription_request.g.dart';

@freezed
class SubscriptionRequest with _$SubscriptionRequest {
  factory SubscriptionRequest({
    @JsonKey(name: 'gateway_id') required String gatewayId,
    @JsonKey(name: 'plan_id') required String planId,
  }) = _SubscriptionRequest;

  factory SubscriptionRequest.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionRequestFromJson(json);
}
