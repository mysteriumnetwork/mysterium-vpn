// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'promotional_banner.freezed.dart';
part 'promotional_banner.g.dart';

@freezed
abstract class PromotionalBanner with _$PromotionalBanner {
  factory PromotionalBanner({
    required String id,
    required String title,
    String? iconUrl,
    Map<String, String>? localizedTitles,
    String? redirectUrl,
    DateTime? startDate,
    DateTime? endDate,
  }) = _PromotionalBanner;
  factory PromotionalBanner.fromJson(Map<String, dynamic> json) =>
      _$PromotionalBannerFromJson(json);
}

extension PromotionalBannerX on PromotionalBanner {
  String getLocalizedTitle(String locale) => localizedTitles?[locale] ?? title;
}
