import 'package:easy_localization/easy_localization.dart';
import 'package:mysterium_vpn/models/location.dart';

class FilterService {
  List<VPNLocation> filterLocations(
    List<VPNLocation> data, {
    String? keyword,
  }) {
    final query = keyword?.toLowerCase().trim();
    if (query == null || query.isEmpty) {
      return data;
    }

    return data
        .where(
          (it) =>
              it.code.tr().toLowerCase().contains(query) || it.code.toLowerCase().contains(query),
        )
        .toList();
  }
}
