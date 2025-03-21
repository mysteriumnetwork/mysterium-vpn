// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
// Project imports:

class ColoredScaffold extends StatelessWidget {
  const ColoredScaffold({
    required this.body,
    this.backgroundColor,
    this.extendBodyBehindAppBar = false,
    super.key,
  });

  final Widget body;
  final bool extendBodyBehindAppBar;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) => Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        backgroundColor: checkMediaWidth(context, 750)
            ? Palette.darkBlue
            : backgroundColor ?? Theme.of(context).primaryColor,
        body: SafeArea(
          top: !extendBodyBehindAppBar,
          bottom: false,
          child: body,
        ),
      );
}
