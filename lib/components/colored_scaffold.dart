// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
// Project imports:

class ColoredScaffold extends StatelessWidget {
  const ColoredScaffold({
    required this.body,
    this.backgroundColor,
    this.extendBodyBehindAppBar = false,
    this.forceBackgroundColor = false,
    super.key,
  }) : assert(
          forceBackgroundColor == false || backgroundColor != null,
          'If forceBackgroundColor is true, backgroundColor must be provided',
        );

  final Widget body;
  final bool extendBodyBehindAppBar;
  final Color? backgroundColor;
  final bool forceBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor;
    if (forceBackgroundColor) {
      backgroundColor = this.backgroundColor!;
    } else {
      backgroundColor = checkMediaWidth(context, 750)
          ? Palette.darkBlue
          : this.backgroundColor ?? Theme.of(context).primaryColor;
    }
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      backgroundColor: backgroundColor,
      body: SafeArea(
        top: !extendBodyBehindAppBar,
        bottom: false,
        child: body,
      ),
    );
  }
}
