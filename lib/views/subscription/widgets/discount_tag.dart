import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';

class DiscountTag extends HookConsumerWidget {
  const DiscountTag({
    required this.discountPercentage,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    this.colors = const [Color(0xffFF735F), Color(0xffFF40CA)],
    super.key,
  });

  final int discountPercentage;

  final EdgeInsets padding;
  final List<Color> colors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (discountPercentage <= 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colors.length == 1 ? colors.first : null,
        gradient: colors.length >= 2 ? LinearGradient(colors: colors) : null,
      ),
      child: EasyText(
        LocaleKeys.discountTag.tr(namedArgs: {'discount': '$discountPercentage%'}),
        fontSize: 12,
        color: Palette.white,
      ),
    );
  }
}
