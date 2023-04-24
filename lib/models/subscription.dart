// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription.freezed.dart';
part 'subscription.g.dart';

@freezed
class Subscription with _$Subscription {
  factory Subscription({
    required bool active,
    @JsonKey(name: 'plan_id') required String? planId,
    @JsonKey(name: 'gateway') required String? gateway,
  }) = _Subscription;

  factory Subscription.fromJson(Map<String, dynamic> json) => _$SubscriptionFromJson(json);
}
