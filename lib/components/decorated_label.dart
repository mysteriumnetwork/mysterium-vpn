import 'package:flutter/widgets.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:styled_widget/styled_widget.dart';

class DecoratedLabel extends StatelessWidget {
  const DecoratedLabel({
    required this.text,
    this.color = Palette.purple,
    this.radius = 20,
    super.key,
  });

  final String text;
  final Color color;
  final double radius;
  @override
  Widget build(BuildContext context) => EasyText(text, color: Palette.white)
      .padding(horizontal: 8, vertical: 2)
      .decorated(color: color, borderRadius: BorderRadius.all(Radius.circular(radius)));
}
