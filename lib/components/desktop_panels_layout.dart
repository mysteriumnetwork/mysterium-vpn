import 'package:flutter/material.dart';

class DesktopPanelsLayout extends StatelessWidget {
  const DesktopPanelsLayout({
    required this.leftPanel,
    required this.rightPanel,
    this.leftPanelFlex = 3,
    this.rightPanelFlex = 5,
    super.key,
  });

  final Widget leftPanel;
  final Widget rightPanel;
  final int leftPanelFlex;
  final int rightPanelFlex;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Flexible(flex: leftPanelFlex, child: leftPanel),
      Flexible(flex: rightPanelFlex, child: rightPanel),
    ],
  );
}
