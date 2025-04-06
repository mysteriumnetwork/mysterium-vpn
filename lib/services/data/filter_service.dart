import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysterium_vpn/models/location.dart';

class FilterService {
  List<VPNLocation> filterLocations(
    List<VPNLocation> data, {
    String? keyword,
    bool shouldSortList = true,
  }) {
    final query = keyword?.toLowerCase().trim();

    var result = [...data];
    if (query != null && query.isNotEmpty) {
      result = data
          .where(
            (it) =>
                it.code.tr().toLowerCase().contains(query) || it.code.toLowerCase().contains(query),
          )
          .toList();
    }
    if (shouldSortList) {
      return result.sortedBy((it) => it.code.tr());
    } else {
      return result;
    }
  }
}
