import 'package:vpn_api/vpn_api.dart';

/// Feed item fixture. [id] drives the title/summary text the widget tests match
/// on, so `newsItem(1)` renders as "Title 1" / "Message 1".
NewscenterInboxListResponseItem newsItem(
  int id, {
  NewscenterCategory category = NewscenterCategory.news,
  String? webViewUrl,
  DateTime? createdAt,
}) => NewscenterInboxListResponseItem(
  id: id,
  category: category,
  title: 'Title $id',
  summary: 'Message $id',
  createdAt: createdAt ?? DateTime.now().subtract(const Duration(minutes: 5)),
  webViewUrl: webViewUrl ?? 'https://mysterium.network/news/$id',
);
