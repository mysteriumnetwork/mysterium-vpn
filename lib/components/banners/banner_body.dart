import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/banners/banner.dart';
import 'package:mysterium_vpn/components/easy_text.dart';

class BannerBody extends StatelessWidget {
  const BannerBody({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) => EasyText(
    text,
    fontSize: 12,
    maxLines: 3,
    textAlign: TextAlign.center,
    color: BannerStyle.of(context).foregroundColor,
  );
}
