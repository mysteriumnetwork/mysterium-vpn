import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:styled_widget/styled_widget.dart';

class Flag extends StatelessWidget {
  final String country;

  const Flag({super.key, required this.country});
  @override
  Widget build(BuildContext context) {
    final flag = getCountryFlag(country);
    return flag == null ? const SizedBox.shrink() : SvgIcon(asset: flag).clipOval();
  }
}
