import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/exceptions/store_not_available.dart';
import 'package:mysterium_vpn/common/utils/comparator_utils.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/models/purchasable_product.dart';
import 'package:mysterium_vpn/models/subscription.dart';
import 'package:mysterium_vpn/services/auth/auth_session_store.dart';
import 'package:mysterium_vpn/services/auth/auth_status.dart';
import 'package:mysterium_vpn/services/data/local/secured_storage_service.dart';
import 'package:mysterium_vpn/services/subscription/subscription_service.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:vpn_api/vpn_api.dart' as api;

// Include generated file
part 'subscription_store.g.dart';

// ignore: library_private_types_in_public_api
class SubscriptionStore = _SubscriptionStore with _$SubscriptionStore;

abstract class _SubscriptionStore with Store {
  _SubscriptionStore({
    required InAppPurchase inAppPurchase,
    required SubscriptionService subscriptionService,
    required AuthSessionStore authSessionStore,
    required AnalyticsStore analyticsStore,
  })  : _inAppPurchase = inAppPurchase,
        _subscriptionService = subscriptionService,
        _authSessionStore = authSessionStore,
        _analyticsStore = analyticsStore {
    initStore();
  }

  late StreamSubscription<List<PurchaseDetails>> _purchaseStream;

  final InAppPurchase _inAppPurchase;
  final SubscriptionService _subscriptionService;
  final AuthSessionStore _authSessionStore;
  final SecureStorageService _secureStorageService = SecureStorageService.instance;
  final AnalyticsStore _analyticsStore;

  @observable
  ObservableFuture<api.SubscriptionConfigResponse>? isAvailableFuture;

  @observable
  ObservableFuture<Subscription>? verifySubscriptionFuture;

  @observable
  ObservableFuture<Subscription>? subscriptionFuture;

  @readonly
  Subscription? _subscription;

  @readonly
  bool? _expired;

  @computed
  bool? get isSubscribed => _subscription?.active;

  @readonly
  StoreState _isAvailable = StoreState.loading;

  @readonly
  String? _purchasedProductId;

  @readonly
  api.SubscriptionConfigResponse? _subscriptionConfig;

  @readonly
  SubscriptionStatus? _subscriptonStatus;

  @readonly
  PurchaseDetails? _lastPurchase;

  @readonly
  ObservableList<PurchasableProduct> _products = ObservableList<PurchasableProduct>.of([]);

  @computed
  PurchasableProduct get monthlyProduct => _products.firstWhere((element) => element.duration == 1);

  @computed
  PurchasableProduct get highlightedProduct =>
      _products.sortedByCompare((it) => it.duration, compareNums).last;

  @computed
  bool get isLoading =>
      _subscriptonStatus == SubscriptionStatus.pending ||
      _subscriptonStatus == SubscriptionStatus.verifying;

  @action
  Future<void> initStore() async {
    when((status) => _authSessionStore.status == AuthStatus.authenticated, () {
      fetchSubscription().whenComplete(getSubscriptionsConfig);
    });
  }

  @action
  Future<bool> fetchSubscription() async {
    subscriptionFuture = ObservableFuture(_subscriptionService.fetchSubscriptionDetails());
    _subscription = await subscriptionFuture;
    _expired = _subscription?.expired;
    if (_subscription!.active && (_subscription!.planId?.isNotEmpty ?? false)) {
      _purchasedProductId = _subscription!.planId;
    }
    return _subscription!.active;
  }

  @action
  Future<bool> isSubscriptionActive() async {
    try {
      if (_subscription != null) {
        return _subscription!.active;
      } else if (subscriptionFuture?.status == FutureStatus.pending) {
        return (await subscriptionFuture)!.active;
      } else {
        return await fetchSubscription();
      }
    } catch (_) {
      return false;
    }
  }

  @action
  Future<void> getSubscriptionsConfig() async {
    if (Platform.isWindows || isAvailableFuture?.status == FutureStatus.pending) {
      return;
    }
    try {
      _isAvailable = StoreState.loading;
      isAvailableFuture = ObservableFuture(_subscriptionService.fetchSubscriptionConfig());
      _subscriptionConfig = await isAvailableFuture;
      await getProductsDetails();
      _isAvailable = StoreState.available;
      if (!Platform.isWindows) {
        final purchaseUpdated = _inAppPurchase.purchaseStream;
        _purchaseStream = purchaseUpdated.listen(
          _onPurchaseUpdate,
          onDone: _updateStreamOnDone,
          onError: _updateStreamOnError,
        );
        _subscriptionService.clearPendingTransactions();
      }
    } on NotAvailableException catch (_) {
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
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  @action
  Future<void> subscribeToPackage({required ProductDetails product}) async {
    try {
      _subscriptonStatus = SubscriptionStatus.pending;

      await _subscriptionService.subscribeToPackage(
        productDetails: product,
        purchasedProductId: ((_subscription?.active ?? false) && _subscription?.gateway == 'google')
            ? _products
                .firstWhereOrNull((element) => element.id == _purchasedProductId)
                ?.productDetails
                .id
            : null,
        userId: _authSessionStore.user!.userId,
      );
      _analyticsStore.logEvent(
        AnalyticsEvent.paymentConfirm,
        parameters: {
          'planType': product.id,
          'price': product.rawPrice.toString(),
          'item_ids': _products.map((e) => e.id).toList(),
        },
      );
    } catch (e) {
      _subscriptionService.clearPendingTransactions();
      if (await _subscriptionService.hasApplePendingPurchasingTransactions()) {
        _subscriptonStatus = SubscriptionStatus.pendingTransaction;
      } else {
        _subscriptonStatus = SubscriptionStatus.error;
      }
      _analyticsStore.logEvent(
        AnalyticsEvent.paymentError,
        parameters: {
          'planType': product.id,
          'price': product.rawPrice.toString(),
          'error': e.toString(),
        },
      );
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

  ///Available on devices running iOS 14 and iPadOS 14 and later.
  @action
  Future<void> redeemCode() async {
    if (!Platform.isIOS) {
      return;
    }
    _analyticsStore.logEvent(AnalyticsEvent.redeemOpen);
    InAppPurchase.instance
        .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>()
        .presentCodeRedemptionSheet();
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
      if (purchaseDetails.status == PurchaseStatus.canceled ||
          (purchaseDetails.status == PurchaseStatus.error &&
              purchaseDetails.error?.code == 'purchase_error')) {
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
      await verifyPurchase(
        product?.id ?? '',
        product?.productDetails.rawPrice.toString() ?? '',
        purchaseDetails,
      );
      _expired = _subscription?.expired;
      if (purchaseDetails.status == PurchaseStatus.purchased && (_subscription?.active ?? false)) {
        _purchasedProductId = _subscription?.planId;
        _analyticsStore.logEvent(
          AnalyticsEvent.paymentVerificationSuccess,
          parameters: {
            'planType': _purchasedProductId ?? _lastPurchase?.productID,
            'price': product?.productDetails.rawPrice.toString(),
          },
        );
        if (product != null) {
          for (final product in _products) {
            product.status = product.id == _purchasedProductId
                ? ProductStatus.purchased
                : ProductStatus.purchasable;
          }
        }
        _subscriptonStatus = SubscriptionStatus.purchased;
        await _secureStorageService.saveSubscriptionPaymentInfo(
          email: _authSessionStore.user!.username,
          activeUntil: _subscription!.activeUntil,
        );
      } else {
        _subscriptonStatus = SubscriptionStatus.notVerified;
      }

      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
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
  Future<void> verifyPurchase(
    String productId,
    String price,
    PurchaseDetails purchaseDetails,
  ) async {
    if (_subscriptonStatus == SubscriptionStatus.pending) {
      _subscriptonStatus = SubscriptionStatus.verifying;
    }
    try {
      verifySubscriptionFuture = ObservableFuture(
        _subscriptionService.verifyPurchase(
          serverVerificationData: purchaseDetails.verificationData.serverVerificationData,
          planId: productId,
          transactionId: purchaseDetails.purchaseID ?? '',
        ),
      );
      _subscription = await verifySubscriptionFuture;
      _analyticsStore.logEvent(
        AnalyticsEvent.paymentVerificationSuccess,
        parameters: {
          'planType': productId,
          'price': price,
        },
      );
    } catch (e) {
      _subscriptonStatus = SubscriptionStatus.verifyingError;
      _analyticsStore.logEvent(
        AnalyticsEvent.paymentVerificationError,
        parameters: {
          'planType': productId,
          'price': price,
          'error': e.toString(),
        },
      );
      rethrow;
    }
  }

  @action
  Future<void> retryVerificationProcess() async {
    if (_lastPurchase != null) {
      final product = _products
          .firstWhereOrNull((element) => element.productDetails.id == _lastPurchase!.productID);
      if (product == null) {
        return;
      }
      try {
        _subscriptonStatus = SubscriptionStatus.verifying;
        verifySubscriptionFuture = ObservableFuture(
          _subscriptionService.verifyPurchase(
            serverVerificationData: _lastPurchase!.verificationData.serverVerificationData,
            planId: product.id,
            transactionId: _lastPurchase!.purchaseID ?? '',
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

  Future<(bool, String?)> checkForExistingSubscription() async {
    try {
      if (_subscription?.active ?? false) {
        return (false, null);
      }
      final (String email, DateTime activeUntil) =
          await _secureStorageService.getSubscriptionPaymentInfo();
      if (email != _authSessionStore.user!.username && activeUntil.isAfter(DateTime.now())) {
        return (true, email);
      }
      return (false, null);
    } catch (e) {
      return (false, null);
    }
  }

  Future<void> manageSubscription() async {
    if (_subscription == null || !_subscription!.active) {
      throw const SubscriptionRequiredException();
    }
    if (_products.isEmpty) {
      await getSubscriptionsConfig();
    }
    final product = _products.firstWhereOrNull((element) => element.id == _subscription!.planId);
    if (product == null) {
      throw const SubscriptionRequiredException();
    }

    await subscribeToPackage(product: product.productDetails);
  }

  void dispose() {
    _purchaseStream.cancel();
  }
}
