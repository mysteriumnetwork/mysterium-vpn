import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:styled_widget/styled_widget.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    this.message,
    this.radius,
    this.strokeWidth = 3.5,
    this.messageColor,
    this.indicatorColor,
    super.key,
  });
  final String? message;
  final double? radius;
  final double strokeWidth;
  final Color? messageColor;
  final Color? indicatorColor;
  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitSpinningLines(
            color: indicatorColor ?? Palette.pink,
            size: radius ?? 30,
          ),
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
      ).center();
}
