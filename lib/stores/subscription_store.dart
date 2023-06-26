import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
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
  ObservableFuture<Subscription>? verifySubscriptionFuture;

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

  @observable
  String selectedProductId = kPopularPlan;

  @readonly
  SubscriptionConfig? _subscriptionConfig;

  @readonly
  SubscriptionStatus? _subscriptonStatus;

  @readonly
  PurchaseDetails? _lastPurchase;

  @readonly
  ObservableList<PurchasableProduct> _products = ObservableList<PurchasableProduct>.of([]);
  @readonly
  double _originalPrice = 0;

  @action
  Future<void> initStore() async {
    autorun((_) {
      if (_authStore.authData != null) {
        final purchaseUpdated = _inAppPurchase.purchaseStream;
        _purchasedProductId = _localDb.getSubscriptionPlan();
        selectedProductId = _purchasedProductId ?? kPopularPlan;
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
      if (isAvailableFuture?.status == FutureStatus.pending) {
        return;
      }

      isAvailableFuture = ObservableFuture(_subscriptionService.fetchSubscriptionConfig());
      _subscriptionConfig = await isAvailableFuture;
      await getProductsDetails();
      _isAvailable = StoreState.available;
    } on StoreNotAvailableException catch (_) {
      _isAvailable = StoreState.notAvailable;
    } catch (_) {
      _isAvailable = StoreState.notAvailable;
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
        _originalPrice = _products.firstWhere((e) => e.id == kMonthlyPlan).productDetails.rawPrice;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  @action
  Future<void> subscribeToPackage() async {
    try {
      _subscriptonStatus = SubscriptionStatus.pending;
      final item =
          _products.firstWhere((element) => element.id == selectedProductId).productDetails;
      _subscriptionService.createSubscriptionRequest(
        SubscriptionRequest(gatewayId: getPlatformGateway(), planId: selectedProductId),
      );
      await _subscriptionService.subscribeToPackage(
        productDetails: item,
        purchasedProductId: ((_subscription?.active ?? false) && _subscription?.gateway == 'google')
            ? _products
                .firstWhereOrNull((element) => element.id == _purchasedProductId)
                ?.productDetails
                .id
            : null,
        userId: _authStore.authData!.userId,
      );

      if (_purchasedProductId != null && _purchasedProductId == selectedProductId) {
        _analyticsStore.setManageSubscription(
          paymentGateway: getPlatformGateway(),
          planPrice: item.rawPrice,
          planType: selectedProductId,
        );
      } else {
        _analyticsStore.setPaymentInitiated(
          paymentGateway: getPlatformGateway(),
          planPrice: item.rawPrice,
          planType: selectedProductId,
        );
      }
    } on Exception catch (e) {
      _subscriptonStatus = SubscriptionStatus.error;

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
    final product = _products
        .firstWhereOrNull((element) => element.productDetails.id == purchaseDetails.productID);

    if (purchaseDetails.status == PurchaseStatus.error ||
        purchaseDetails.status == PurchaseStatus.canceled) {
      if (product != null) {
        product.status = ProductStatus.purchasable;
      }
      if (purchaseDetails.status == PurchaseStatus.canceled) {
        _subscriptionService.clearPendingTransactions();
      }
      _subscriptonStatus = getSubscriptionStatus(purchaseDetails.status);

      return;
    }

    if (purchaseDetails.status == PurchaseStatus.pending) {
      if (product != null) {
        product.status = ProductStatus.pending;
      }
      return;
    }
    try {
      await verifyPurchase(product?.productDetails.id ?? '', purchaseDetails);

      if (purchaseDetails.status == PurchaseStatus.purchased && (_subscription?.active ?? false)) {
        _purchasedProductId = _subscription?.planId;
        if (product != null) {
          for (final product in _products) {
            product.status = product.planDetails.id == _purchasedProductId
                ? ProductStatus.purchased
                : ProductStatus.purchasable;
          }
          _analyticsStore.setPaymentSuccessful(
            paymentGateway: getPlatformGateway(),
            planPrice: product.productDetails.rawPrice,
            planType: _purchasedProductId ?? '',
            transactionId: purchaseDetails.verificationData.serverVerificationData,
            transactionDate: purchaseDetails.transactionDate ?? '',
          );
        }
        _subscriptonStatus = SubscriptionStatus.purchased;
      } else {
        _subscriptonStatus = SubscriptionStatus.notVerified;
      }

      if (purchaseDetails.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchaseDetails);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      _lastPurchase = purchaseDetails;
    }
  }

  @action
  Future<void> verifyPurchase(String productId, PurchaseDetails purchaseDetails) async {
    if (_subscriptonStatus == SubscriptionStatus.pending) {
      _subscriptonStatus = SubscriptionStatus.verifying;
    }
    try {
      verifySubscriptionFuture = ObservableFuture(
        _subscriptionService.verifyPurchase(
          gatewayId: getPlatformGateway(),
          paymentToken: purchaseDetails.verificationData.serverVerificationData,
          planId: productId,
          purchaseId: purchaseDetails.purchaseID ?? '',
        ),
      );
      _subscription = await verifySubscriptionFuture;
    } catch (_) {
      _subscriptonStatus = SubscriptionStatus.verifyingError;
      rethrow;
    }
  }

  @action
  Future<void> retryVerificationProcess() async {
    if (_lastPurchase != null && _purchasedProductId != null) {
      try {
        _subscriptonStatus = SubscriptionStatus.verifying;
        verifySubscriptionFuture = ObservableFuture(
          _subscriptionService.verifyPurchase(
            gatewayId: getPlatformGateway(),
            paymentToken: _lastPurchase!.verificationData.serverVerificationData,
            planId: _purchasedProductId!,
            purchaseId: _lastPurchase!.purchaseID ?? '',
          ),
        );

        _subscription = await verifySubscriptionFuture;
        _subscriptonStatus = _subscription?.active ?? false
            ? SubscriptionStatus.purchased
            : SubscriptionStatus.notVerified;
      } catch (e) {
        _subscriptonStatus = SubscriptionStatus.verifyingError;
      }
    }
  }

  void dispose() {
    _purchaseStream.cancel();
  }
}
