import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/handle_subscribe_to_product_hook.dart';
import 'package:mysterium_vpn/common/hooks/plan_data_hook.dart';
import 'package:mysterium_vpn/common/utils/design_system_theme.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/pages/subscription_plans_modal_page.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/subscription/subscription_status_container.dart';
import 'package:mysterium_vpn/views/subscription/widgets/subscription_privacy_and_terms.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

Future<void> showSubscriptionUpgradeModalPage(BuildContext context) async {
  ProviderScope.containerOf(context, listen: false)
      .read(analyticsStorePOD)
      .logScreenViewed('subscription_upgrade_modal')
      .ignore();
  await showModal(
    context,
    builder: (context) => Theme(
      data: DesignSystemTheme.of(context),
      child: _SubscriptionUpgradeModalPage(
        onShowAllPlansPressed: () => showSubscriptionPlansModalPage(context),
      ),
    ),
  );
}

class _SubscriptionUpgradeModalPage extends HookConsumerWidget {
  const _SubscriptionUpgradeModalPage({required this.onShowAllPlansPressed});

  final VoidCallback onShowAllPlansPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(subscriptionPlansStorePOD);

    final theme = Theme.of(context);
    final scrollController = useScrollController();

    void handleSeeAllPlans() {
      Navigator.of(context).pop();
      onShowAllPlansPressed();
    }

    return ModalScaffold(
      autoApplyPadding: false,
      body: SubscriptionStatusContainer(
        child: Observer(
          builder: (context) {
            final product = store.bestValueProducts.lastOrNull;
            if (product == null) {
              return const Center(
                child: LoadingIndicator(),
              );
            }
            return HookBuilder(
              builder: (context) {
                final planData = usePlanData(product, otherProduct: store.purchasedProduct);
                final handleSubscribe = useHandleSubscribeToProduct();
                Future<void> handlePurchase() async {
                  await handleSubscribe(product.id);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        padding: ModalPadding.insets(
                          context,
                          add: EdgeInsets.symmetric(
                            vertical: theme.spacing.xl,
                            horizontal: theme.spacing.md,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 340),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ModalHeader(
                                  emblem: const DecoratedIcon(icon: UntitledUI.stars_02),
                                  title: LocaleKeys.subscriptionUpgradeModalTitle
                                      .tr(args: [planData.name]),
                                  description: LocaleKeys.subscriptionUpgradeModalDescription.tr(),
                                ),
                                SizedBox(height: theme.spacing.xl2),
                                PlanCard.features(
                                  mode: PlanCardMode.highlight,
                                  data: planData,
                                  features: store
                                      .findConfig(product)
                                      .previewFeatures
                                      .map((it) => it.tr())
                                      .toList(),
                                ),
                                SizedBox(height: theme.spacing.xl3),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: Icon(
                                          UntitledUI.currency_dollar_circle,
                                          size: 16,
                                          color: theme.palette.iconTertiary,
                                        ),
                                      ),
                                      CharacterSpan.space(),
                                      TextSpan(text: LocaleKeys.subscriptionPlanMoneyBack.tr()),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                  style: theme.textStyles.textXs.regular.copyWith(
                                    color: theme.palette.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    ModalFooter(
                      children: [
                        ButtonPrimary(
                          onPressed: handlePurchase,
                          child: Text(LocaleKeys.subscriptionUpgradeCTA.tr(args: [planData.name])),
                        ),
                        ButtonTertiary(
                          onPressed: handleSeeAllPlans,
                          child: Text(LocaleKeys.subscriptionUpgradeSeeAllPlans.tr()),
                        ),
                        const SubscriptionPrivacyAndTerms(),
                      ],
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
