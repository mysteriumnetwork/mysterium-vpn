import 'package:vpn_api/vpn_api.dart';

/// Reads the personalized News Center feed and tracks which items the user has
/// read. Backed by `RestNewsCenterService` (the `vpn_api` News Center endpoint
/// for the feed, local storage for read state — the API does not carry read
/// state).
abstract class NewsCenterService {
  /// The personalized list of items for the user (`GET /newscenter/inbox`).
  Future<List<NewscenterInboxListResponseItem>> getFeed();

  /// Ids of items the user has already read.
  Set<int> readIds();

  /// Records [id] as read.
  Future<void> markRead(int id);

  /// Clears all persisted read state (QA helper).
  Future<void> clearRead();
}
