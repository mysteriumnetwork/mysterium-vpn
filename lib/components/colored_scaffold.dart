// Flutter imports:
import 'package:flutter/material.dart';
// Project imports:
import 'package:mysterium_vpn/common/layout_builders/edge_to_edge_handler.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';

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
    return EdgeToEdgeScaffold(
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      backgroundColor: backgroundColor,
      body: body,
    );
  }
}
