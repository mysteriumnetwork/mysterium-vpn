import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/views/subscription/subscription_form.dart';

class SubscriptionButton extends StatelessWidget {
  const SubscriptionButton({
    required this.onPressed,
    required this.isLoading,
    required this.subsFormStatus,
    required this.selectedProductId,
    required this.purchasedProductId,
    super.key,
  });

  final Function(SubscriptionFormStatus status) onPressed;
  final bool isLoading;
  final SubscriptionFormStatus subsFormStatus;
  final String selectedProductId;
  final String? purchasedProductId;
  @override
  Widget build(BuildContext context) => EasyButton(
        width: getMediaWidth(context) * 0.8,
        useSystemColor: false,
        color: isLoading ? Theme.of(context).disabledColor : Palette.purple,
        onPressed: isLoading ? null : () => onPressed(subsFormStatus),
        child: isLoading
            ? const LoadingIndicator(
                radius: 20,
                strokeWidth: 1.5,
              )
            : EasyText(
                subsFormStatus == SubscriptionFormStatus.manage
                    ? selectedProductId == purchasedProductId
                        ? LocaleKeys.manageBtn.tr()
                        : LocaleKeys.changeSubPlan.tr()
                    : subsFormStatus == SubscriptionFormStatus.expired
                        ? LocaleKeys.renewSubsBtn.tr()
                        : LocaleKeys.startTrialBtn.tr(),
                color: Palette.white,
              ),
      );
}
