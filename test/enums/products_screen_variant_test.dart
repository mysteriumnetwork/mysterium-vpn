import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' show FutureStatus;
import 'package:mysterium_vpn/common/enums/products_screen_variant.dart';

void main() {
  group('resolveProductsScreenVariant', () {
    ProductsScreenVariant resolve({
      FutureStatus subscriptionStatus = FutureStatus.fulfilled,
      bool hasActiveSub = false,
      FutureStatus configStatus = FutureStatus.fulfilled,
      bool isOnMaxPlan = false,
      bool isStoreSubOnForeignPlatform = false,
      bool useWebFlow = false,
    }) => resolveProductsScreenVariant(
      subscriptionStatus: subscriptionStatus,
      hasActiveSub: hasActiveSub,
      configStatus: configStatus,
      isOnMaxPlan: isOnMaxPlan,
      isStoreSubOnForeignPlatform: isStoreSubOnForeignPlatform,
      useWebFlow: useWebFlow,
    );

    test('loading while subscription future is pending', () {
      expect(resolve(subscriptionStatus: FutureStatus.pending), ProductsScreenVariant.loading);
    });

    test('loading while active sub waits for config', () {
      expect(
        resolve(hasActiveSub: true, configStatus: FutureStatus.pending),
        ProductsScreenVariant.loading,
      );
    });

    test('maxPlan wins over management screens', () {
      expect(
        resolve(isOnMaxPlan: true, isStoreSubOnForeignPlatform: true, useWebFlow: true),
        ProductsScreenVariant.maxPlan,
      );
    });

    test('manageOnStore before web flow', () {
      expect(
        resolve(isStoreSubOnForeignPlatform: true, useWebFlow: true),
        ProductsScreenVariant.manageOnStore,
      );
    });

    test('manageOnWeb when web flow', () {
      expect(resolve(useWebFlow: true), ProductsScreenVariant.manageOnWeb);
    });

    test('defaultUpgrade otherwise', () {
      expect(resolve(), ProductsScreenVariant.defaultUpgrade);
    });
  });
}
