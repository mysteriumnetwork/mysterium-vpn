import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/repositories/news_center/news_center_repository.dart';
import 'package:mysterium_vpn/services/data/local/shared_preferences_service.dart';
import 'package:vpn_api/vpn_api.dart';

/// [NewsCenterRepository] backed by the `vpn_api` News Center endpoint
/// (`GET /newscenter/inbox`) for the feed and [SharedPreferenceService] for
/// read state (which is not part of the API payload).
class RestNewsCenterRepository implements NewsCenterRepository {
  RestNewsCenterRepository({
    required Newscenter api,
    required SharedPreferenceService prefs,
    required String Function() originCountry,
    required String osType,
    required String appVersion,
  }) : _api = api,
       _prefs = prefs,
       _originCountry = originCountry,
       _osType = osType,
       _appVersion = appVersion;

  final Newscenter _api;
  final SharedPreferenceService _prefs;

  /// The user's origin country, read per-request (it can change).
  final String Function() _originCountry;
  final String _osType;
  final String _appVersion;

  @override
  Future<List<NewsItem>> getFeed() async {
    final response = await _api.inboxList(
      originCountry: _originCountry(),
      osType: _osType,
      appVersion: _appVersion,
    );
    return (response.data?.messages ?? const []).map(_toNewsItem).toList();
  }

  static NewsItem _toNewsItem(NewscenterInboxListResponseItem item) => NewsItem(
    id: item.id.toInt(),
    title: item.title,
    summary: item.summary,
    category: switch (item.category) {
      NewscenterCategory.offer => NewsCategory.offer,
      NewscenterCategory.news => NewsCategory.news,
      NewscenterCategory.incident => NewsCategory.incident,
    },
    webViewUrl: item.webViewUrl,
    createdAt: item.createdAt,
    updatedAt: item.updatedAt,
  );

  @override
  Set<int> readIds() => _prefs.getNewsCenterReadIds();

  @override
  Future<void> markRead(int id) async =>
      _prefs.setNewsCenterReadIds(_prefs.getNewsCenterReadIds()..add(id));

  @override
  Future<void> clearRead() async => _prefs.setNewsCenterReadIds(const {});
}
