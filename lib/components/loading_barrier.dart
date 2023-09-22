import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';

class LoadingBarrier extends StatelessWidget {
  const LoadingBarrier({required this.color, this.child, this.radius = 30, super.key});

  final Color color;
  final Widget? child;
  final double radius;
  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          ModalBarrier(
            dismissible: false,
            color: color.withOpacity(0.8),
          ),
          child ??
              Center(
                child: LoadingIndicator(
                  radius: radius,
                  strokeWidth: 3,
                  message: LocaleKeys.LoggingYouIn.tr(),
                  messageColor: Palette.pink,
                ),
              ),
        ],
      );
}
