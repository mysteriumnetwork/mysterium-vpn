import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:in_app_purchase_storekit/store_kit_2_wrappers.dart';

part 'product_offer.freezed.dart';
part 'product_offer.g.dart';

@freezed
abstract class ProductOffer with _$ProductOffer {
  factory ProductOffer({
    required String id,
    required bool isIntroductory,
    required double price,
    required OfferDuration durationUnit,
    required int durationValue,
  }) = _ProductOffer;

  factory ProductOffer.fromJson(Map<String, dynamic> json) => _$ProductOfferFromJson(json);

  factory ProductOffer.fromAppStore(SK2SubscriptionOffer offer) => ProductOffer(
        id: offer.id ?? 'default',
        isIntroductory: offer.type == SK2SubscriptionOfferType.introductory,
        price: offer.price,
        durationUnit: OfferDuration.fromAppStore(offer.period.unit),
        durationValue: offer.period.value,
      );
}

enum OfferDuration {
  day,
  week,
  month,
  year;

  static OfferDuration fromAppStore(SK2SubscriptionPeriodUnit unit) {
    switch (unit) {
      case SK2SubscriptionPeriodUnit.day:
        return OfferDuration.day;
      case SK2SubscriptionPeriodUnit.week:
        return OfferDuration.week;
      case SK2SubscriptionPeriodUnit.month:
        return OfferDuration.month;
      case SK2SubscriptionPeriodUnit.year:
        return OfferDuration.year;
    }
  }
}
