import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';

ScreenType useScreenType() {
  final context = useContext();
  final query = MediaQuery.of(context);
  return getScreenType(query.size);
}
