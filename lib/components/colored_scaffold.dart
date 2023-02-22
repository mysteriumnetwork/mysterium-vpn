// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
// Project imports:

class ColoredScaffold extends StatelessWidget {
  const ColoredScaffold({
    required this.body,
    this.backgroundColor,
    super.key,
  });

  final Widget body;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) => Scaffold(
        extendBody: true,
        backgroundColor:
            checkMediaWidth(context, 750) ? Palette.darkBlue : Theme.of(context).primaryColor,
        body: SafeArea(
          bottom: false,
          child: body,
        ),
      );
}
