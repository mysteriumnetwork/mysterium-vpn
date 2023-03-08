import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/error_widget.dart';
import 'package:mysterium_vpn/components/header_title.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';
import 'package:mysterium_vpn/views/subscription/product_list.dart';
import 'package:styled_widget/styled_widget.dart';

class SubscriptionForm extends HookConsumerWidget {
  const SubscriptionForm({required this.store, super.key});
  final SubscriptionStore store;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedProduct = useState(store.purchasedProductId ?? kPopularPlan);

    return Column(
      children: [
        HeaderTitle(
          text: LocaleKeys.selectPackage.tr(),
        ).padding(bottom: getMediaHeight(context) * 0.02),
        Observer(
          builder: (context) {
            final featureStatus = store.productsDetailsFuture?.status;

            if (featureStatus == FutureStatus.pending) {
              return LoadingIndicator(
                message: LocaleKeys.gettingYourPlan.tr(),
              );
            } else if (featureStatus == FutureStatus.rejected) {
              return RetryOnErrorWidget(
                error: LocaleKeys.unableToGetPlans.tr(),
                onRetry: store.getProductsDetails,
              );
            } else if (store.products.isEmpty) {
              return RetryOnErrorWidget(
                error: LocaleKeys.productsNotAvailable.tr(),
                onRetry: store.getProductsDetails,
              );
            }
            return Column(
              children: [
                SubscriptionProductsList(
                  products: store.products,
                  selectedProduct: selectedProduct,
                ).padding(bottom: getMediaHeight(context) * 0.03),
                EasyText(
                  LocaleKeys.freeTrialTittle.tr(),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ).padding(bottom: getMediaHeight(context) * 0.005),
                EasyText(
                  LocaleKeys.freeTrialDesc.tr(),
                  maxLines: 3,
                  textAlign: TextAlign.center,
                ).padding(bottom: getMediaHeight(context) * 0.025),
                EasyButton(
                  useSystemColor: false,
                  color: store.isSubscribing ? Theme.of(context).disabledColor : Palette.purple,
                  onPressed: store.isSubscribing
                      ? null
                      : () {
                          if (selectedProduct.value.isNotEmpty) {
                            store.subscribeToPackage(selectedProduct.value);
                          }
                        },
                  text: store.purchasedProductId != null
                      ? selectedProduct.value == store.purchasedProductId
                          ? LocaleKeys.manageBtn.tr()
                          : LocaleKeys.changeSubPlan.tr()
                      : LocaleKeys.startTrialBtn.tr(),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
