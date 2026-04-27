import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart' hide Palette;
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
              child: LoadingIndicator.message(
                LocaleKeys.LoggingYouIn.tr(),
                size: radius,
                color: Theme.of(context).palette.iconBrandSecondary,
              ),
            ),
      ],
    ).height(constraints.maxHeight),
  );
}
