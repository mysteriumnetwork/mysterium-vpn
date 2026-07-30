import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/generated/l10n.dart';

extension IPTypeLabel on IPType {
  /// Localized service-quality label shown in the UI.
  String get localizedLabel =>
      this == IPType.residential ? S.current.residential : S.current.highSpeed;
}
