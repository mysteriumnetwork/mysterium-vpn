import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';

class FillContainer extends StatelessWidget {
  const FillContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
        flex: 2,
        child: Container(
          color: Palette.darkBlue,
        ));
  }
}
