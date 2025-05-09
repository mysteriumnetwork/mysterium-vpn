import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';

class SubscriptionButton extends StatelessWidget {
  const SubscriptionButton({
    required this.onPressed,
    required this.isLoading,
    required this.label,
    super.key,
  });

  final VoidCallback onPressed;
  final bool isLoading;
  final String label;

  @override
  Widget build(BuildContext context) => isLoading
      ? const SizedBox(
          child: LoadingIndicator(
            radius: 20,
            strokeWidth: 1.5,
          ),
        )
      : EasyButton(
          useSystemColor: false,
          color: isLoading ? Theme.of(context).disabledColor : Palette.purple,
          onPressed: isLoading ? null : onPressed,
          text: label,
        );
}
