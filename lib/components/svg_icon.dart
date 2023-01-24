// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:styled_widget/styled_widget.dart';
// Project imports:

class SvgIcon extends StatelessWidget {
  const SvgIcon({Key? key, required this.asset}) : super(key: key);

  final String asset;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SvgPicture.asset(
        asset,
        matchTextDirection: true,
      ),
    ).center();
  }
}
