import 'package:mysterium_vpn/common/enums/home_tab.dart';
import 'package:mysterium_vpn/generated/l10n.dart';

/// Presentation labels for [HomeTab]. Kept in the view layer so the enum stays
/// pure data and translation lives with the UI.
extension HomeTabLabels on HomeTab {
  String label() => switch (this) {
    HomeTab.map => S.current.navMap,
    HomeTab.locations => S.current.navLocations,
    HomeTab.products => S.current.navProducts,
    HomeTab.settings => S.current.settings,
  };
}
