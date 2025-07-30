import 'package:collection/collection.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/models/location.dart';

class FilterService {
  static String currentLocale = kFallbackLocale.languageCode;

  List<VPNLocation> filterLocations(
    List<VPNLocation> data, {
    required String locale,
    String? keyword,
    bool shouldSortList = true,
  }) {
    final query = keyword?.toLowerCase().trim();

    var result = [...data];
    if (query != null && query.isNotEmpty) {
      result = data.where(
        (it) {
          final code = it.id.toLowerCase();
          final name = it.translations[locale]?.toLowerCase();
          return (name?.contains(query) ?? false) || code.contains(query);
        },
      ).toList();
    }
    if (shouldSortList) {
      return result.sortedBy((it) => it.translations[locale] ?? it.id);
    } else {
      return result;
    }
  }

  List<VPNLocation> filterRecentLocations(
    List<VPNLocation> data, {
    required String keyword,
    required String locale,
    required Set<VPNLocation> availableLocations,
  }) {
    final availableRecents = data.where(availableLocations.contains).toList();
    return filterLocations(
      availableRecents,
      keyword: keyword,
      shouldSortList: false,
      locale: locale,
    );
  }
}
