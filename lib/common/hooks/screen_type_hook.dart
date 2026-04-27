import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

ScreenType useScreenType() {
  final context = useContext();
  return ScreenType.of(context);
}
