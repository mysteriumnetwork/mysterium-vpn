import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';

class Brand extends StatelessWidget {
  const Brand({this.height, super.key});

  final double? height;

  @override
  Widget build(BuildContext context) =>
      Center(child: Asset.logo.logoStacked(context).svg(height: height));
}
