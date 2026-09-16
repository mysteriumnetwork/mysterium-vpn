import 'package:mysterium_vpn/common/enums/news_filter.dart';

/// Domain category for a News Center item, mapped from the API's
/// `NewscenterCategory` at the service boundary.
enum NewsCategory {
  offer,
  news,
  incident;

  /// The feed filter that selects exactly this category.
  NewsFilter get filter => switch (this) {
    NewsCategory.offer => NewsFilter.offers,
    NewsCategory.news => NewsFilter.news,
    NewsCategory.incident => NewsFilter.incidents,
  };
}
