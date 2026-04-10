import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:styled_widget/styled_widget.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    this.message,
    this.radius = 20,
    this.messageColor,
    this.indicatorColor = Palette.pink,
    super.key,
  });
  final String? message;
  final double radius;
  final Color? messageColor;
  final Color indicatorColor;
  @override
  Widget build(BuildContext context) => message != null
      ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitSpinningLines(color: indicatorColor, size: radius),
            if (message != null)
              EasyText(
                message!,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                maxLines: 2,
                textAlign: TextAlign.center,
                color: messageColor,
              ).padding(top: 10),
          ],
        ).center()
      : SpinKitSpinningLines(
          color: indicatorColor,
          size: radius,
        ).constrained(maxHeight: radius, maxWidth: radius);
}
