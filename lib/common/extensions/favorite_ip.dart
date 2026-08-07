import 'package:flutter/widgets.dart';
import 'package:mysterium_vpn/common/extensions/ip_type.dart';
import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
import 'package:mysterium_vpn/models/models.dart';

extension FavoriteIpExtensions on FavoriteIp {
  /// Whether the user had a country (rather than a city) picked when saving.
  /// Legacy entries without a [FavoriteIp.locationId] count as country picks.
  bool get isCountryPick => locationId.isEmpty || locationId == countryCode;

  /// The location a connect attempt targets — the picked city, or the country
  /// for country picks; the exact node is selected by the backend via
  /// `target_ip`.
  VPNLocation get location => VPNLocation(
    id: isCountryPick ? countryCode : locationId,
    ipType: ipType,
    translations: const {},
    countryCode: countryCode,
  );

  /// Country display name: the one captured at save time, else the translated
  /// (lowercased) country code for entries persisted before
  /// [FavoriteIp.countryName].
  String displayName(BuildContext context) => countryName.isNotEmpty
      ? countryName
      : VPNLocation.fromCode(countryCode.toLowerCase(), ipType).getName(context);

  /// Localized pill label for the saved-IP card: the bare IP-type name
  /// ("Residential" / "Datacenter"), without the "IP" suffix used elsewhere.
  String get badgeLabel => ipType.localizedLabel;
}
