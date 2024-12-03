part of 'hooks.dart';

void Function({
  PurchasableProduct? Function()? findProduct,
}) useHandleSubscribe() {
  final context = useContext();

  final sessionStore = useProvider(authSessionStorePOD);
  final subscriptionStore = useProvider(subscriptionStorePOD);
  final environmentStore = useProvider(environmentPOD);

  final accessToken = useComputedValue(() => sessionStore.accessToken, [sessionStore]);
  final subscription = useComputedValue(() => subscriptionStore.subscription, [subscriptionStore]);
  final billingPage = useComputedValue(
    () => environmentStore.values.billingPage,
    [environmentStore],
  );

  return useCallback(
    ({
      PurchasableProduct? Function()? findProduct,
    }) {
      handleOnBillingPage(
        billingPage: billingPage,
        context: context,
        gateway: subscription?.gateway,
        subscriptionActive: subscription?.active ?? false,
        accessToken: accessToken,
        onManageSubscription: findProduct == null
            ? null
            : () {
                final product = findProduct();
                if (product != null) {
                  subscriptionStore.subscribeToPackage(product: product.productDetails);
                }
              },
      );
    },
    [
      billingPage,
      subscription?.gateway,
      subscription?.active,
      accessToken,
      subscriptionStore,
    ],
  );
}
