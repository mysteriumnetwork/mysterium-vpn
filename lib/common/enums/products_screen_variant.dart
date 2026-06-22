import 'package:mobx/mobx.dart' show FutureStatus;

/// The mutually-exclusive screens the Products tab can render. Mirrors the
/// branch order in `HomeProductsTab`. Logged as `screen_variant` (snake_case).
enum ProductsScreenVariant { loading, maxPlan, manageOnStore, manageOnWeb, defaultUpgrade }

/// Pure resolver for [ProductsScreenVariant] so the rendered variant and the
/// logged variant cannot diverge. Branch order matches `HomeProductsTab.build`.
ProductsScreenVariant resolveProductsScreenVariant({
  required FutureStatus subscriptionStatus,
  required bool hasActiveSub,
  required FutureStatus configStatus,
  required bool isOnMaxPlan,
  required bool isStoreSubOnForeignPlatform,
  required bool useWebFlow,
}) {
  final waitingForConfig = hasActiveSub && configStatus == FutureStatus.pending;
  if (subscriptionStatus == FutureStatus.pending || waitingForConfig) {
    return ProductsScreenVariant.loading;
  }
  if (isOnMaxPlan) {
    return ProductsScreenVariant.maxPlan;
  }
  if (isStoreSubOnForeignPlatform) {
    return ProductsScreenVariant.manageOnStore;
  }
  if (useWebFlow) {
    return ProductsScreenVariant.manageOnWeb;
  }
  return ProductsScreenVariant.defaultUpgrade;
}
