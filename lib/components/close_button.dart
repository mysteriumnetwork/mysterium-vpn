import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';

class CloseButton extends StatelessWidget {
  const CloseButton({this.onPressed, this.implicit = true, super.key});

  final VoidCallback? onPressed;
  final bool implicit;

  @override
  Widget build(BuildContext context) {
    final router = Beamer.of(context);
    final onPressed = this.onPressed ?? ((implicit && router.canBeamBack) ? router.beamBack : null);

    if (implicit && onPressed == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [SvgIconButton(asset: Asset.icons.closeDark, onPressed: onPressed)],
      ),
    );
  }
}
