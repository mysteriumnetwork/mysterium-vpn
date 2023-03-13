import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/routes.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
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
    final isMounted = useIsMounted();
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
                ReactionBuilder(
                  builder: (context) => reaction((_) => store.isSubscribing, (result) {
                    if (result == false && isMounted()) {
                      context.beamToNamed(Routes.emailCommunications.toRoute);
                    }
                  }),
                  child: EasyButton(
                    width: getMediaWidth(context) * 0.8,
                    useSystemColor: false,
                    color: store.isSubscribing ? Theme.of(context).disabledColor : Palette.purple,
                    onPressed: store.isSubscribing
                        ? null
                        : () async {
                            if (selectedProduct.value.isNotEmpty) {
                              store.subscribeToPackage(selectedProduct.value);
                            }
                          },
                    child: !store.isSubscribing
                        ? EasyText(
                            store.purchasedProductId != null
                                ? selectedProduct.value == store.purchasedProductId
                                    ? LocaleKeys.manageBtn.tr()
                                    : LocaleKeys.changeSubPlan.tr()
                                : LocaleKeys.startTrialBtn.tr(),
                            color: Palette.white,
                          )
                        : const LoadingIndicator(
                            radius: 20,
                            strokeWidth: 1.5,
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    ).scrollable().padding(horizontal: 20);
  }
}
