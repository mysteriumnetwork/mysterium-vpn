import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_2_wrappers.dart';
import 'package:mysterium_vpn/common/utils/comparator_utils.dart';

part 'product_offer.freezed.dart';
part 'product_offer.g.dart';

@freezed
abstract class ProductOffer with _$ProductOffer {
  factory ProductOffer({
    required String id,
    required double price,
    required double fullPrice,
    required OfferDuration durationUnit,
    required int durationValue,
  }) = _ProductOffer;

  const ProductOffer._();

  factory ProductOffer.fromJson(Map<String, dynamic> json) => _$ProductOfferFromJson(json);

  factory ProductOffer.fromAppStore(SK2SubscriptionOffer offer, AppStoreProduct2Details details) =>
      ProductOffer(
        // we cannot have proper filter with null ID because ConfigCat doesn't support null values, and all appstore intro offers have null IDs
        id: offer.id ?? 'default',
        price: offer.price,
        durationUnit: OfferDuration.fromAppStore(offer.period.unit),
        durationValue: offer.period.value,
        fullPrice: details.rawPrice,
      );

  factory ProductOffer.fromGooglePlay(SubscriptionOfferDetailsWrapper offer) {
    final id = offer.offerId ?? 'default';
    final phase = offer.pricingPhases.firstOrNull;
    if (phase == null) {
      throw ArgumentError('Google Play offer has no pricing phases: $offer');
    }
    final price = phase.priceAmountMicros / 1e6;
    final (value, unitLetter) = _parseGooglePlayPeriod(phase.billingPeriod);
    final durationUnit = OfferDuration.fromGooglePlay(unitLetter);
    return ProductOffer(
      id: id,
      price: price,
      durationUnit: durationUnit,
      durationValue: value,
      fullPrice: offer.pricingPhases
              .sortedByCompare((it) => it.priceAmountMicros, compareNums)
              .last
              .priceAmountMicros /
          1e6,
    );
  }

  double get discount {
    if (fullPrice <= 0) {
      return 0;
    }
    return (fullPrice - price) / fullPrice;
  }

  int get discountPercent => (discount * 100).round();
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

  static OfferDuration fromGooglePlay(String unit) {
    switch (unit) {
      case 'D':
        return OfferDuration.day;
      case 'W':
        return OfferDuration.week;
      case 'M':
        return OfferDuration.month;
      case 'Y':
        return OfferDuration.year;
      default:
        throw ArgumentError('Unknown duration unit: $unit');
    }
  }
}

final _gpPeriodRegex = RegExp(r'^P(\d+)([DWMY])$');

(int, String) _parseGooglePlayPeriod(String raw) {
  final m = _gpPeriodRegex.firstMatch(raw);
  if (m == null) {
    throw ArgumentError('Invalid Google Play period: $raw');
  }
  final value = int.parse(m.group(1)!);
  final unitLetter = m.group(2)!;
  return (value, unitLetter);
}
