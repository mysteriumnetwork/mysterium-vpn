import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/style.dart';

class DraggableIndicator extends StatelessWidget {
  const DraggableIndicator({this.onTap, this.size = const Size(45, 10), super.key});

  final Size size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => RawMaterialButton(
    elevation: 0,
    hoverElevation: 1,
    focusElevation: 2,
    highlightElevation: 2,
    onPressed: onTap,
    constraints: BoxConstraints.tight(size),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.height / 2)),
    fillColor: Palette.lightBlack,
  );
}
