// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:styled_widget/styled_widget.dart';
// Project imports:

class SvgIcon extends StatelessWidget {
  const SvgIcon({
    required this.asset,
    super.key,
    this.width,
    this.height,
  });

  final String asset;
  final double? width;
  final double? height;
  @override
  Widget build(BuildContext context) => Directionality(
        textDirection: TextDirection.ltr,
        child: SvgPicture.asset(
          asset,
          matchTextDirection: true,
          width: width,
          height: height,
        ),
      ).center();
}
