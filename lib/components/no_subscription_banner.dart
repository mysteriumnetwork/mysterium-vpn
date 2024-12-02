import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';

class NoSubscriptionBanner extends StatelessWidget {
  const NoSubscriptionBanner({
    required this.onSubscribePressed,
    super.key,
    this.constraints = const BoxConstraints(maxHeight: 84, maxWidth: 360),
  });

  final VoidCallback onSubscribePressed;

  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Palette.purple, width: 2),
          color: Palette.mediumBlack,
        ),
        child: ConstrainedBox(
          constraints: constraints,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  EasyText(
                    color: Colors.white,
                    LocaleKeys.noSubscriptionTitle.tr(),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  ElevatedButton(
                    onPressed: onSubscribePressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.purple,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      minimumSize: Size.zero,
                      foregroundColor: Palette.white,
                      visualDensity: VisualDensity.comfortable,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: EasyText(
                      LocaleKeys.noSubscriptionAction.tr(),
                      fontSize: 12,
                      color: Palette.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
