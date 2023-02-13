import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:styled_widget/styled_widget.dart';

class Header extends StatelessWidget {
  const Header({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return EasyText(
      text,
      fontSize: 20,
      fontWeight: FontWeight.w900,
    ).fittedBox().padding(vertical: 20);
  }
}
