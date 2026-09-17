import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';

part 'news_item.freezed.dart';

/// A News Center feed item as the app uses it, mapped from the API response at
/// the service boundary so the UI never sees `vpn_api` types.
@freezed
abstract class NewsItem with _$NewsItem {
  const factory NewsItem({
    required int id,
    required String title,
    required String summary,
    required NewsCategory category,
    required String webViewUrl,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _NewsItem;
}
