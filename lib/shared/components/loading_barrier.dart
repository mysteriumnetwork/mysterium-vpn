import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/shared/components/loading_indicator.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:styled_widget/styled_widget.dart';

class LoadingBarrier extends StatelessWidget {
  const LoadingBarrier({required this.color, this.child, this.radius = 30, super.key});

  final Color color;
  final Widget? child;
  final double radius;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => Stack(
      children: <Widget>[
        ModalBarrier(
          dismissible: false,
          color: color.withValues(alpha: 0.8),
        ).height(constraints.maxHeight),
        child ??
            Center(
              child: LoadingIndicator(
                radius: radius,
                message: LocaleKeys.LoggingYouIn.tr(),
                messageColor: Palette.pink,
              ),
            ),
      ],
    ).height(constraints.maxHeight),
  );
}
