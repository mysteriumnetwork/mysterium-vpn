// Flutter imports:
import 'package:flutter/material.dart';
// Project imports:
import 'package:mysterium_vpn/common/ui/ui.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

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
  Widget build(BuildContext context) {
    final palette = Theme.of(context).palette;
    final background = checkMediaWidth(context, 750)
        ? palette.bgSidePanel
        : backgroundColor ?? palette.bgPrimary;
    return Scaffold(
      backgroundColor: background,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      // Bottom inset is owned by whatever sits there (nav bar, modal footers).
      body: SafeArea(top: !extendBodyBehindAppBar, bottom: false, child: body),
    );
  }
}
