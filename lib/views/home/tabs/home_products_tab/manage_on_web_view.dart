part of 'home_products_tab.dart';

class _ManageOnWebView extends HookConsumerWidget {
  const _ManageOnWebView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final handleSubscribe = useHandleSubscribe();

    final manageButton = ButtonPrimary(
      onPressed: () => handleSubscribe(manageSubscription: true),
      decoration: ButtonDecoration(decorationColor: theme.palette.bgBrandPrimary),
      leading: const Icon(UntitledUI.link_external_02, size: 20),
      child: Text(LocaleKeys.manageOnWebBtn.tr()),
    );

    return _ProductsBrowsingView(
      subtitle: LocaleKeys.productsManageSubtitle.tr(),
      alertMessage: LocaleKeys.productsActivePlanWebSyncAlert.tr(),
      action: manageButton,
    );
  }
}
