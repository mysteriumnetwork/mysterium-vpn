import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:styled_widget/styled_widget.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({this.message, this.radius, this.strokeWidth = 3.5, super.key});
  final String? message;
  final double? radius;
  final double strokeWidth;
  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (message != null)
            EasyText(
              message!,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              maxLines: 2,
              textAlign: TextAlign.center,
            ).padding(bottom: 15),
          CircularProgressIndicator(
            color: Palette.pink,
            strokeWidth: strokeWidth,
          ).width(radius ?? 30).height(radius ?? 30),
        ],
      ).center();
}
