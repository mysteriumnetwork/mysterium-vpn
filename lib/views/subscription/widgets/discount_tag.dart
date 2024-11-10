import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/easy_text.dart';

class DiscountTag extends StatelessWidget {
  const DiscountTag({
    required this.discountLabel,
    super.key,
  });
  final String discountLabel;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xffFF735F),
              Color(0xffFF40CA),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: EasyText(
          discountLabel,
          fontSize: 12,
        ),
      );
}
