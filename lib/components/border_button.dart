// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
// Project imports:

class BorderButton extends StatelessWidget {
  const BorderButton({Key? key, this.color, required this.child, required this.onPressed})
      : super(key: key);

  final Widget child;
  final VoidCallback onPressed;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
              side: MaterialStateProperty.all<BorderSide>(
                BorderSide(color: color ?? Palette.black, width: 1.5),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
        child: child,
      ),
    );
  }
}
