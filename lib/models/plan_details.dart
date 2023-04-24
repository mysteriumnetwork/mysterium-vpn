// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'plan_details.freezed.dart';
part 'plan_details.g.dart';

@freezed
class PlanDetails with _$PlanDetails {
  factory PlanDetails({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'interval') required Interval enabled,
    @JsonKey(name: 'price') required Price price,
    @JsonKey(name: 'supported_gateways') required List<String> supportedGateways,
    @JsonKey(name: 'apple_product_id') required String appleProductId,
    @JsonKey(name: 'google_product_id') required String googleProductId,
  }) = _PlanDetails;

  factory PlanDetails.fromJson(Map<String, dynamic> json) => _$PlanDetailsFromJson(json);
}

@freezed
class Price with _$Price {
  factory Price({
    @JsonKey(name: 'EUR') required double euro,
    @JsonKey(name: 'USD') required double usd,
  }) = _Price;

  factory Price.fromJson(Map<String, dynamic> json) => _$PriceFromJson(json);
}

@freezed
class Interval with _$Interval {
  factory Interval({
    required String unit,
    required double amount,
  }) = _Interval;

  factory Interval.fromJson(Map<String, dynamic> json) => _$IntervalFromJson(json);
}
