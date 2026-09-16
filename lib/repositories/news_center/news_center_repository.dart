import 'package:mysterium_vpn/models/models.dart';

/// Reads the personalized News Center feed and tracks which items the user has
/// read. Backed by `RestNewsCenterRepository` (the `vpn_api` News Center endpoint
/// for the feed, local storage for read state — the API does not carry read
/// state).
abstract class NewsCenterRepository {
  /// The personalized list of items for the user (`GET /newscenter/inbox`).
  Future<List<NewsItem>> getFeed();

  /// Ids of items the user has already read.
  Set<int> readIds();

  /// Records [id] as read.
  Future<void> markRead(int id);

  /// Clears all persisted read state (QA helper).
  Future<void> clearRead();
}
