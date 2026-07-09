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
          child: Text(hasActiveSub ? S.current.manageOnWebBtn : S.current.subscribeOnWebBtn),
        );

        return _ProductsBrowsingView(
          subtitle: hasActiveSub
              ? S.current.productsManageSubtitle
              : S.current.productsSubscribeWebSubtitle,
          alertMessage: hasActiveSub
              ? S.current.productsActivePlanWebSyncAlert
              : S.current.productsSubscribeWebAlert,
          action: ctaButton,
        );
      },
    );
  }
}
