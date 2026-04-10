import 'package:collection/collection.dart';
import 'package:mysterium_vpn/core/constants/constants.dart';
import 'package:mysterium_vpn/models/models.dart';

class FilterService {
  static String currentLocale = kFallbackLocale.languageCode;

  List<VPNLocation> filterLocations(
    List<VPNLocation> data, {
    required String locale,
    String? keyword,
    bool shouldSortList = false,
  }) {
    final query = keyword?.normalized ?? '';

    var result = [...data];
    if (query.isNotEmpty) {
      result = data.map((it) => query.matched(it, locale)).nonNulls.toList();
    }

    if (shouldSortList) {
      result = result.sortedBy((it) => it.translations[locale] ?? it.id);
    }

    return result;
  }
}

extension _QueryExtension on String {
  String get normalized => trim().toLowerCase();

  VPNLocation? matched(VPNLocation location, String locale) {
    if (isEmpty) {
      return location;
    }

    final code = location.id.normalized;
    final name = location.translations[locale]?.normalized;

    if (location.children != null) {
      final children = location.children!.map((it) => matched(it, locale)).nonNulls.toList();
      if (children.isNotEmpty) {
        return location.copyWith(children: children);
      }
    }

    if ((name?.contains(this) ?? false) || code.contains(this)) {
      return location;
    }

    return null;
  }
}
