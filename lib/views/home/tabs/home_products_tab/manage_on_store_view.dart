part of 'home_products_tab.dart';

/// Shown for an active mobile-store (Apple/Google) subscription opened on a
/// platform that can't manage it (e.g. an Apple sub on Windows). Store subs
/// can't move to web billing, so this directs the user back to the store the
/// subscription was purchased from rather than offering a web or in-app flow.
class _ManageOnStoreView extends HookConsumerWidget {
  const _ManageOnStoreView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionStore = ref.watch(subscriptionStorePOD);

    return Observer(
      builder: (context) {
        final gateway = subscriptionStore.subscriptionFuture.value?.gateway;
        final store = storeNameForGateway(gateway);

        return _ProductsBrowsingView(
          subtitle: S.current.productsExploreSubtitle,
          alertMessage: S.current.activeSubsPaidVia(store),
        );
      },
    );
  }
}
