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
import 'package:mysterium_vpn/stores/analytics_store.dart';
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
    required AnalyticsStore analyticsStore,
  })  : _inAppPurchase = inAppPurchase,
        _subscriptionService = subscriptionService,
        _authStore = authStore,
        _localDb = localDb,
        _analyticsStore = analyticsStore {
    initStore();
  }

  late StreamSubscription<List<PurchaseDetails>> _purchaseStream;

  final InAppPurchase _inAppPurchase;
  final SubscriptionService _subscriptionService;
  final AuthStore _authStore;
  final LocalDBService _localDb;
  final AnalyticsStore _analyticsStore;

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
  PurchaseStatus? _purchaseStatus;

  @readonly
  PurchaseDetails? _lastPurchase;

  @readonly
  ObservableList<PurchasableProduct> _products = ObservableList<PurchasableProduct>.of([]);

  @action
  Future<void> initStore() async {
    autorun((_) {
      if (_authStore.authData != null) {
        final purchaseUpdated = _inAppPurchase.purchaseStream;
        _purchasedProductId = _localDb.getSubscriptionPlan();
        fetchSubscription().whenComplete(getSubscriptionsConfig);
        _purchaseStream = purchaseUpdated.listen(
          _onPurchaseUpdate,
          onDone: _updateStreamOnDone,
          onError: _updateStreamOnError,
        );
        _subscriptionService.clearPendingTransactions();
      }
    });
  }

  @action
  Future<void> fetchSubscription() async {
    subscriptionFuture = ObservableFuture(_subscriptionService.fetchSubscriptionDetails());
    _subscription = await subscriptionFuture;
    if (_subscription?.planId != null) {
      _localDb.setSubscriptionPlan(_subscription!.planId!);
      _purchasedProductId = _subscription!.planId;
    }
  }

  @action
  Future<void> getSubscriptionsConfig() async {
    try {
      isAvailableFuture = ObservableFuture(_subscriptionService.fetchSubscriptionConfig());
      _subscriptionConfig = await isAvailableFuture;
      await getProductsDetails();
      _isAvailable = StoreState.available;
    } on StoreNotAvailableException catch (_) {
      _isAvailable = StoreState.notAvailable;
    } on Exception catch (_) {
      rethrow;
    }
  }

  @action
  Future<void> getProductsDetails() async {
    try {
      if (_subscriptionConfig != null) {
        _products = ObservableList.of(
          await _subscriptionService.getProductsDetails(
            _subscriptionConfig!,
            _purchasedProductId,
          ),
        );
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
      _purchaseStatus = PurchaseStatus.pending;
      final item = _products.firstWhere((element) => element.id == productId).productDetails;
      _subscriptionService.createSubscriptionRequest(
        SubscriptionRequest(gatewayId: getPlatformGateway(), planId: productId),
      );
      await _subscriptionService.subscribeToPackage(
        productDetails: item,
        purchasedProductId: _purchasedProductId,
        userId: _authStore.authData!.userId,
      );

      _purchasedProductId = productId;
      if (_purchasedProductId != null && _purchasedProductId == productId) {
        _analyticsStore.setManageSubscription(
          paymentGateway: getPlatformGateway(),
          planPrice: item.rawPrice,
          planType: productId,
        );
      } else {
        _analyticsStore.setPaymentInitiated(
          paymentGateway: getPlatformGateway(),
          planPrice: item.rawPrice,
          planType: productId,
        );
      }
    } on Exception catch (e) {
      _purchaseStatus = PurchaseStatus.error;

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

    if (purchaseDetails.status == PurchaseStatus.error ||
        purchaseDetails.status == PurchaseStatus.canceled) {
      if (index != -1) {
        _products[index].status = ProductStatus.purchasable;
      }
      if (purchaseDetails.status == PurchaseStatus.canceled) {
        _subscriptionService.clearPendingTransactions();
      }
      _purchaseStatus = purchaseDetails.status;
      return;
    }

    if (purchaseDetails.status == PurchaseStatus.pending) {
      if (index != -1) {
        _products[index].status = ProductStatus.pending;
      }
      return;
    }
    _subscription = await verifyPurchase(_purchasedProductId ?? '', purchaseDetails);

    if (purchaseDetails.status == PurchaseStatus.purchased && (_subscription?.active ?? false)) {
      if (index != -1) {
        for (final product in _products) {
          product.status = product.planDetails.id == _purchasedProductId
              ? ProductStatus.purchased
              : ProductStatus.purchasable;
        }
      }
    }

    if (purchaseDetails.pendingCompletePurchase) {
      _analyticsStore.setPaymentSuccessful(
        paymentGateway: getPlatformGateway(),
        planPrice: _products[index].productDetails.rawPrice,
        planType: _purchasedProductId ?? '',
        transactionId: purchaseDetails.verificationData.serverVerificationData,
        transactionDate: purchaseDetails.transactionDate ?? '',
      );
      _inAppPurchase.completePurchase(purchaseDetails);
    }
    _lastPurchase = purchaseDetails;
    _purchaseStatus = purchaseDetails.status;
  }

  @action
  Future<Subscription?> verifyPurchase(String productId, PurchaseDetails purchaseDetails) async {
    final result = await _subscriptionService.verifyPurchase(
      source: purchaseDetails.verificationData.source,
      verificationData: purchaseDetails.verificationData.serverVerificationData,
      planId: productId,
      purchaseId: purchaseDetails.purchaseID ?? '',
    );
    return result;
  }

  @action
  Future<void> retryVerificationProcess() async {
    if (_lastPurchase != null && _purchasedProductId != null) {
      _purchaseStatus = PurchaseStatus.pending;
      _subscription = await _subscriptionService.verifyPurchase(
        source: _lastPurchase!.verificationData.source,
        verificationData: _lastPurchase!.verificationData.serverVerificationData,
        planId: _purchasedProductId!,
        purchaseId: _lastPurchase!.purchaseID ?? '',
      );
      _purchaseStatus = PurchaseStatus.purchased;
    }
  }

  void dispose() {
    _purchaseStream.cancel();
  }
}
