part of 'hooks.dart';

bool useSubscriptionActive() {
  final store = useProvider(subscriptionStorePOD);
  return useComputedValue(
    () => store.subscription?.active ?? false,
    [store],
  );
}
