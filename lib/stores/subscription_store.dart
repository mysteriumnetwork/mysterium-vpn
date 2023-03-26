import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/store_not_available.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/models/purchasable_product.dart';
import 'package:mysterium_vpn/models/subscription.dart';
import 'package:mysterium_vpn/models/subscription_config.dart';
import 'package:mysterium_vpn/models/subscription_request.dart';
import 'package:mysterium_vpn/services/local_db_service.dart';
import 'package:mysterium_vpn/services/subscription/subscription_service.dart';
import 'package:mysterium_vpn/stores/auth_store.dart';

// Include generated file
part 'subscription_store.g.dart';

// ignore: library_private_types_in_public_api
class SubscriptionStore = _SubscriptionStore with _$SubscriptionStore;

abstract class _SubscriptionStore with Store {
  _SubscriptionStore({
    required InAppPurchase inAppPurchase,
    required SubscriptionService subscriptionService,
    required AuthStore authStore,
    required LocalDBService localDb,
  })  : _inAppPurchase = inAppPurchase,
        _subscriptionService = subscriptionService,
        _authStore = authStore,
        _localDb = localDb {
    initStore();
  }

  late StreamSubscription<List<PurchaseDetails>> _purchaseStream;

  final InAppPurchase _inAppPurchase;
  final SubscriptionService _subscriptionService;
  final AuthStore _authStore;
  final LocalDBService _localDb;

  @observable
  ObservableFuture<SubscriptionConfig>? isAvailableFuture;

  @observable
  ObservableFuture<Subscription>? subscriptionFuture;

  @readonly
  Subscription? _subscription;

  @computed
  bool? get isSubscribed => _subscription?.active;

  @readonly
  StoreState _isAvailable = StoreState.loading;

  @readonly
  String? _purchasedProductId;

  @readonly
  SubscriptionConfig? _subscriptionConfig;

  @readonly
  PurchaseStatus? _isSubscribing;

  @readonly
  ObservableList<PurchasableProduct> _products = ObservableList<PurchasableProduct>.of([]);

  @action
  Future<void> initStore() async {
    autorun((_) {
      if (_authStore.authData != null) {
        final purchaseUpdated = _inAppPurchase.purchaseStream;
        fetchSubscription();
        _purchaseStream = purchaseUpdated.listen(
          _onPurchaseUpdate,
          onDone: _updateStreamOnDone,
          onError: _updateStreamOnError,
        );
        getSubscriptionsConfig();
        _subscriptionService.clearPendingTransactions();
        _purchasedProductId = _subscriptionService.getSubscriptionPlan();
      }
    });
  }

  @action
  Future<void> fetchSubscription() async {
    subscriptionFuture = ObservableFuture(_subscriptionService.fetchSubscriptionDetails());
    _subscription = await subscriptionFuture;
  }

  @action
  Future<void> getSubscriptionsConfig() async {
    try {
      isAvailableFuture = ObservableFuture(_subscriptionService.fetchSubscriptionConfig());
      _subscriptionConfig = await isAvailableFuture;
      _isAvailable = StoreState.available;
      getProductsDetails();
    } on StoreNotAvailableException catch (_) {
      _isAvailable = StoreState.notAvailable;
    } on Exception catch (_) {
      rethrow;
    }
  }

  @action
  void getProductsDetails() {
    try {
      if (_subscriptionConfig != null) {
        _products =
            ObservableList.of(_subscriptionService.getProductsDetails(_subscriptionConfig!));
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @action
  Future<void> subscribeToPackage(String productId) async {
    try {
      _isSubscribing = PurchaseStatus.pending;
      final item = await _subscriptionService.createSubscriptionRequest(
        SubscriptionRequest(gatewayId: getPlatformGateway(), planId: productId),
      );
      await _subscriptionService.subscribeToPackage(
        productDetails: item,
        purchasedProductId: _purchasedProductId,
        userId: _authStore.authData!.userId,
      );

      _purchasedProductId = productId;
    } on Exception catch (e) {
      _isSubscribing = PurchaseStatus.canceled;

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
    _purchaseStream.cancel();
  }

  @action
  void _updateStreamOnError(error) {
    _purchaseStream.cancel();
  }

  @action
  Future<void> _handlePurchase(PurchaseDetails purchaseDetails) async {
    final index = _products.indexWhere((element) => element.id == _purchasedProductId);
    _isSubscribing = purchaseDetails.status;

    if (purchaseDetails.status == PurchaseStatus.error ||
        purchaseDetails.status == PurchaseStatus.canceled) {
      if (index != -1) {
        _products[index].status = ProductStatus.purchasable;
      }
      if (purchaseDetails.status == PurchaseStatus.canceled) {
        _subscriptionService.clearPendingTransactions();
      }
      return;
    }

    if (purchaseDetails.status == PurchaseStatus.pending) {
      if (index != -1) {
        _products[index].status = ProductStatus.pending;
      }
      return;
    }
    _subscription = await _verifyPurchase(_purchasedProductId ?? '', purchaseDetails);
    _purchasedProductId = _localDb.getSubscriptionPlan();
    _products[index].status =
        _subscription?.active ?? false ? ProductStatus.purchased : ProductStatus.purchasable;

    if (purchaseDetails.status == PurchaseStatus.purchased) {
      if (index != -1) {
        for (final product in _products) {
          product.status = product.productDetails.id == purchaseDetails.productID
              ? ProductStatus.purchased
              : ProductStatus.purchasable;
        }
      }
    }

    if (purchaseDetails.pendingCompletePurchase) {
      _inAppPurchase.completePurchase(purchaseDetails);
    }
  }

  @action
  Future<Subscription> _verifyPurchase(String productId, PurchaseDetails purchaseDetails) async {
    final result = await _subscriptionService.verifyPurchase(
      source: purchaseDetails.verificationData.source,
      verificationData: purchaseDetails.verificationData.serverVerificationData,
      productId: productId,
      purchaseId: purchaseDetails.purchaseID ?? '',
    );
    return result;
  }

  void dispose() {
    _purchaseStream.cancel();
  }
}
