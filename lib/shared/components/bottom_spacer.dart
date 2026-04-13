import 'package:flutter/material.dart';

class BottomSpacer extends StatelessWidget {
  const BottomSpacer({super.key, this.height = 16});

  final double height;

  @override
  Widget build(BuildContext context) =>
      SizedBox(height: MediaQuery.of(context).padding.bottom.clamp(height, double.infinity));
}
