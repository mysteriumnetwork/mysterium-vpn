import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:styled_widget/styled_widget.dart';

class HeaderTitle extends StatelessWidget {
  const HeaderTitle({
    Key? key,
    required this.text,
    this.color,
  }) : super(key: key);

  final String text;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return EasyText(
      text,
      fontSize: 20,
      fontWeight: FontWeight.w900,
      color: color,
    ).fittedBox().padding(vertical: 20);
  }
}
