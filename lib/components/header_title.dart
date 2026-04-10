import 'package:flutter/material.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:styled_widget/styled_widget.dart';

class HeaderTitle extends StatelessWidget {
  const HeaderTitle({required this.text, super.key, this.color});

  final String text;
  final Color? color;
  @override
  Widget build(BuildContext context) => EasyText(
    text,
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: color,
  ).fittedBox().padding(vertical: getMediaHeight(context) * .025);
}
