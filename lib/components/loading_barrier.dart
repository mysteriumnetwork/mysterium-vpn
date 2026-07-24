import 'package:flutter/material.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class LoadingBarrier extends StatelessWidget {
  const LoadingBarrier({required this.color, this.child, this.radius = 30, super.key});

  final Color color;
  final Widget? child;
  final double radius;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => SizedBox(
      height: constraints.maxHeight,
      child: Stack(
        children: <Widget>[
          SizedBox(
            height: constraints.maxHeight,
            child: ModalBarrier(dismissible: false, color: color.withValues(alpha: 0.8)),
          ),
          child ??
              Center(
                child: LoadingIndicator.message(
                  S.current.LoggingYouIn,
                  size: radius,
                  color: Theme.of(context).palette.iconBrandSecondary,
                ),
              ),
        ],
      ),
    ),
  );
}
