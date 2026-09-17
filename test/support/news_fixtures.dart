import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/models.dart';

/// Feed item fixture. [id] drives the title/summary text the widget tests match
/// on, so `newsItem(1)` renders as "Title 1" / "Message 1".
NewsItem newsItem(
  int id, {
  NewsCategory category = NewsCategory.news,
  String? webViewUrl,
  DateTime? createdAt,
}) => NewsItem(
  id: id,
  category: category,
  title: 'Title $id',
  summary: 'Message $id',
  createdAt: createdAt ?? DateTime.now().subtract(const Duration(minutes: 5)),
  webViewUrl: webViewUrl ?? 'https://mysterium.network/news/$id',
);
