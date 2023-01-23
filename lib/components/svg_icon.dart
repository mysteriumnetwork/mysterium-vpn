// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:styled_widget/styled_widget.dart';
// Project imports:

class SvgIcon extends StatelessWidget {
  const SvgIcon({Key? key, required this.asset, required this.onPressed})
      : super(key: key);

  final String asset;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: SvgPicture.asset(
          asset,
          matchTextDirection: true,
        ),
      ).center(),
    );
  }
}
