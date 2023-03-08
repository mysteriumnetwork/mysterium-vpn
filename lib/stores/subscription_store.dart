import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/models/purchasable_product.dart';
import 'package:mysterium_vpn/services/api/subscription_service.dart';

// Include generated file
part 'subscription_store.g.dart';

// ignore: library_private_types_in_public_api
class SubscriptionStore = _SubscriptionStore with _$SubscriptionStore;

abstract class _SubscriptionStore with Store {
  _SubscriptionStore({
    required InAppPurchase inAppPurchase,
    required SubscriptionService subscriptionService,
  })  : _inAppPurchase = inAppPurchase,
        _subscriptionService = subscriptionService {
    final purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: _updateStreamOnDone,
      onError: _updateStreamOnError,
    );
    checkAvailability();
    _purchasedProductId = subscriptionService.getSubscriptionPlan();
  }

  late StreamSubscription<List<PurchaseDetails>> _subscription;

  final InAppPurchase _inAppPurchase;
  final SubscriptionService _subscriptionService;

  @observable
  ObservableFuture<bool> isAvailableFuture = ObservableFuture.value(false);

  @observable
  ObservableFuture<List<PurchasableProduct>>? productsDetailsFuture;

  @computed
  bool get hasProductsDetailsResults => productsDetailsFuture?.status == FutureStatus.fulfilled;

  @readonly
  StoreState _isAvailable = StoreState.loading;

  @readonly
  String? _purchasedProductId;

  @readonly
  bool _isSubscribing = false;

  @readonly
  ObservableList<PurchasableProduct> _products = ObservableList<PurchasableProduct>.of([]);

  @action
  Future<void> checkAvailability() async {
    isAvailableFuture = ObservableFuture(
      Future.delayed(const Duration(seconds: 2), _inAppPurchase.isAvailable),
    );
    final res = await isAvailableFuture;
    if (res) {
      getProductsDetails();
    }
    _isAvailable = res ? StoreState.available : StoreState.notAvailable;
  }

  @action
  Future<void> getProductsDetails() async {
    try {
      productsDetailsFuture = ObservableFuture(_subscriptionService.getProductsDetails());

      final res = await productsDetailsFuture;

      _products = ObservableList.of(res!);
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @action
  Future<void> subscribeToPackage(String productId) async {
    try {
      final item = _products.firstWhere(
        (element) => element.id == productId,
        orElse: () => throw PackageNotFoundException(),
      );
      _isSubscribing = true;
      final response = await _subscriptionService.subscribeToPackage(
        productDetails: item.productDetails,
        purchasedProductId: _purchasedProductId,
      );
      debugPrint(response.toString());
    } on Exception catch (e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
    }
  }

  @action
  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach(_handlePurchase);
  }

  @action
  void _updateStreamOnDone() {
    _subscription.cancel();
  }

  @action
  void _updateStreamOnError(error) {
    if (kDebugMode) {
      print(error);
    }
  }

  @action
  Future<void> _handlePurchase(PurchaseDetails purchaseDetails) async {
    final index = _products.indexWhere((element) => element.id == purchaseDetails.productID);
    _isSubscribing = purchaseDetails.status == PurchaseStatus.pending;

    if (purchaseDetails.status == PurchaseStatus.error ||
        purchaseDetails.status == PurchaseStatus.canceled) {
      _products[index].status = ProductStatus.purchasable;
      return;
    }

    if (purchaseDetails.status == PurchaseStatus.pending) {
      if (index != -1) {
        _products[index].status = ProductStatus.pending;
      }
      return;
    }
    final validPurchase = await _verifyPurchase(purchaseDetails);

    if (!validPurchase) {
      _products[index].status = ProductStatus.purchasable;
      return;
    }
    if (purchaseDetails.status == PurchaseStatus.purchased) {
      if (index != -1) {
        for (final product in _products) {
          product.status = product.productDetails.id == purchaseDetails.productID
              ? ProductStatus.purchased
              : ProductStatus.purchasable;
        }
        _purchasedProductId = purchaseDetails.productID;
      }
    }

    if (purchaseDetails.pendingCompletePurchase) {
      _inAppPurchase.completePurchase(purchaseDetails);
    }
  }

  @action
  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    final result = await _subscriptionService.verifyPurchase(
      source: purchaseDetails.verificationData.source,
      verificationData: purchaseDetails.verificationData.serverVerificationData,
      productId: purchaseDetails.productID,
      purchaseId: purchaseDetails.purchaseID ?? '',
    );
    return result;
  }

  void dispose() {
    _subscription.cancel();
  }
}
