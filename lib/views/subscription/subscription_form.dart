import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/enum.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/dialogs/retry_dialog.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/error_widget.dart';
import 'package:mysterium_vpn/components/header_title.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/services/local_db_service.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';
import 'package:mysterium_vpn/views/subscription/product_list.dart';
import 'package:styled_widget/styled_widget.dart';

enum SubscriptionFormStatus {
  freeTrial,
  expired,
  manage,
}

class SubscriptionForm extends HookConsumerWidget {
  const SubscriptionForm({required this.store, required this.localDb, super.key});
  final SubscriptionStore store;
  final LocalDBService localDb;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedProduct = useState(store.purchasedProductId ?? kPopularPlan);
    final isMounted = useIsMounted();
    final subsStatus = store.subscription?.active ?? false;

    final subsFormStatus = useMemoized(
      () => getSubscriptionFormStatus(
        active: subsStatus,
        purchaseProductId: store.purchasedProductId,
      ),
      [subsStatus],
    );
    return Column(
      children: [
        HeaderTitle(
          text: LocaleKeys.selectPackage.tr(),
        ).padding(bottom: getMediaHeight(context) * 0.02),
        Observer(
          builder: (context) {
            if (store.products.isEmpty) {
              return RetryOnErrorWidget(
                error: LocaleKeys.productsNotAvailable.tr(),
                onRetry: store.getSubscriptionsConfig,
              );
            }
            return Column(
              children: [
                SubscriptionProductsList(
                  products: store.products,
                  selectedProduct: selectedProduct,
                ).padding(bottom: getMediaHeight(context) * 0.03),
                EasyText(
                  subsFormStatus == SubscriptionFormStatus.manage
                      ? LocaleKeys.manageSubsTittle.tr()
                      : subsFormStatus == SubscriptionFormStatus.expired
                          ? LocaleKeys.subsExpiredTittle.tr()
                          : LocaleKeys.freeTrialTitle.tr(),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ).padding(bottom: getMediaHeight(context) * 0.005),
                EasyText(
                  subsFormStatus == SubscriptionFormStatus.manage
                      ? LocaleKeys.manageSubsDesc.tr()
                      : subsFormStatus == SubscriptionFormStatus.expired
                          ? LocaleKeys.subsExpiredDesc.tr()
                          : LocaleKeys.freeTrialDesc.tr(),
                  maxLines: 3,
                  textAlign: TextAlign.center,
                ).padding(bottom: getMediaHeight(context) * 0.025),
                ReactionBuilder(
                  builder: (context) => reaction((_) => store.purchaseStatus, (result) {
                    if (result == PurchaseStatus.purchased && isMounted()) {
                      if (subsStatus == false) {
                        shownRetryDialog(
                          onRetry: () async => store.retryVerificationProcess(),
                          context: context,
                          asset: Assets.subscription,
                          title: LocaleKeys.subscriptionVerificationFailed.tr(),
                          subtitle: LocaleKeys.failedToVerifySubs.tr(),
                        );
                      } else {
                        showSnackbar(
                          'Great news! Your subscription is now active. 🎉',
                          type: MessageType.success,
                        );
                        context.beamToReplacementNamed(Routes.home.toRoute);
                      }
                    }
                    if (result == PurchaseStatus.canceled) {
                      showSnackbar('Process Canceled.😕');
                    }
                    if (result == PurchaseStatus.error) {
                      showSnackbar(
                        'Something went wrong with your subscription. Please give it another try. 😕',
                      );
                    }
                  }),
                  child: EasyButton(
                    width: getMediaWidth(context) * 0.8,
                    useSystemColor: false,
                    color: store.purchaseStatus == PurchaseStatus.pending
                        ? Theme.of(context).disabledColor
                        : Palette.purple,
                    onPressed: store.purchaseStatus == PurchaseStatus.pending
                        ? null
                        : () async {
                            if (selectedProduct.value.isNotEmpty) {
                              store.subscribeToPackage(selectedProduct.value);
                            }
                          },
                    child: store.purchaseStatus == PurchaseStatus.pending
                        ? const LoadingIndicator(
                            radius: 20,
                            strokeWidth: 1.5,
                          )
                        : EasyText(
                            subsFormStatus == SubscriptionFormStatus.manage
                                ? selectedProduct.value == store.purchasedProductId
                                    ? LocaleKeys.manageBtn.tr()
                                    : LocaleKeys.changeSubPlan.tr()
                                : subsFormStatus == SubscriptionFormStatus.expired
                                    ? LocaleKeys.renewSubsBtn.tr()
                                    : LocaleKeys.startTrialBtn.tr(),
                            color: Palette.white,
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

SubscriptionFormStatus getSubscriptionFormStatus({
  required String? purchaseProductId,
  required bool active,
}) {
  if (purchaseProductId != null) {
    return active ? SubscriptionFormStatus.manage : SubscriptionFormStatus.expired;
  }
  return SubscriptionFormStatus.freeTrial;
}
