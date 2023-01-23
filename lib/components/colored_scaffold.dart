// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
// Project imports:

class ColoredScaffold extends StatelessWidget {
  const ColoredScaffold({Key? key, required this.body, this.backgroundColor}) : super(key: key);

  final Widget body;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        backgroundColor: checkMediaWidth(context, 650) ? Palette.black : Theme.of(context).backgroundColor,
        body: SafeArea(
          bottom: false,
          child: body,
        ));
  }
}
