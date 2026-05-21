part of 'home_products_tab.dart';

class _ManageOnWebView extends HookConsumerWidget {
  const _ManageOnWebView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final subscriptionStore = ref.watch(subscriptionStorePOD);
    final handleSubscribe = useHandleSubscribe();

    return Observer(
      builder: (context) {
        final hasActiveSub = subscriptionStore.subscriptionFuture.value?.active ?? false;

        final ctaButton = ButtonPrimary(
          onPressed: () => handleSubscribe(manageSubscription: hasActiveSub),
          decoration: ButtonDecoration(decorationColor: theme.palette.bgBrandPrimary),
          leading: const Icon(UntitledUI.link_external_02, size: 20),
          child: Text(
            hasActiveSub ? LocaleKeys.manageOnWebBtn.tr() : LocaleKeys.subscribeOnWebBtn.tr(),
          ),
        );

        return _ProductsBrowsingView(
          subtitle: hasActiveSub
              ? LocaleKeys.productsManageSubtitle.tr()
              : LocaleKeys.productsSubscribeWebSubtitle.tr(),
          alertMessage: hasActiveSub
              ? LocaleKeys.productsActivePlanWebSyncAlert.tr()
              : LocaleKeys.productsSubscribeWebAlert.tr(),
          action: ctaButton,
        );
      },
    );
  }
}
