import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';

class LoadingBarrier extends StatelessWidget {
  const LoadingBarrier({required this.color, super.key});

  final Color color;
  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          Opacity(
            opacity: 0.9,
            child: ModalBarrier(dismissible: false, color: color),
          ),
          Center(
            child: LoadingIndicator(
              radius: 30,
              strokeWidth: 3,
              message: LocaleKeys.LoggingYouIn.tr(),
              messageColor: Palette.pink,
            ),
          ),
        ],
      );
}
