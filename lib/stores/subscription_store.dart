import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/exceptions/store_not_available.dart';
import 'package:mysterium_vpn/common/extensions/observable_future_extensions.dart';
import 'package:mysterium_vpn/common/utils/comparator_utils.dart';
import 'package:mysterium_vpn/models/models.dart';
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
    _authReactionDisposer = reaction<void>(
      (_) => _authSessionStore.status == AuthStatus.authenticated,
      (status) async {
        _subscriptionFuture = ObservableFuture(_fetchSubscription());
      },
      fireImmediately: true,
    );
  }

  StreamSubscription<List<PurchaseDetails>>? _purchaseStream;
  final InAppPurchase _inAppPurchase;
  final SubscriptionService _subscriptionService;
  final AuthSessionStore _authSessionStore;
  final SecureStorageService _secureStorageService = SecureStorageService.instance;
  final AnalyticsStore _analyticsStore;
  ReactionDisposer? _authReactionDisposer;

  @readonly
  late ObservableFuture<Subscription> _subscriptionFuture = ObservableFuture(_fetchSubscription());

  @readonly
  late ObservableFuture<api.SubscriptionConfigResponse?> _subscriptionConfigFuture =
      ObservableFuture(_fetchSubscriptionConfig());

  @readonly
  late ObservableFuture<List<PurchasableProduct>> _productsFuture =
      ObservableFuture(_fetchProducts());

  @readonly
  late ObservableFuture<String?> _otherSubscriberEmailFuture =
      ObservableFuture(_fetchOtherSubscriber());

  @readonly
  SubscriptionStatus? _subscriptionStatus;

  @readonly
  PurchaseDetails? _lastPurchase;

  @computed
  PurchasableProduct? get monthlyProduct =>
      _productsFuture.value?.firstWhereOrNull((element) => element.duration == 1);

  @computed
  PurchasableProduct? get highlightedProduct =>
      _productsFuture.value?.sortedByCompare((it) => it.duration, compareNums).lastOrNull;

  @computed
  bool? get isSubscribed => _subscriptionFuture.value?.active;

  @computed
  bool get isSubscriptionLoading {
    if (storeState == StoreState.loading) {
      return true;
    }
    if (_subscriptionStatus == SubscriptionStatus.pending ||
        _subscriptionStatus == SubscriptionStatus.verifying) {
      return true;
    }
    if (_subscriptionFuture.status == FutureStatus.pending ||
        _subscriptionConfigFuture.status == FutureStatus.pending) {
      return true;
    }

    return false;
  }

  @computed
  StoreState get storeState => switch (_subscriptionConfigFuture.status) {
        FutureStatus.pending => StoreState.loading,
        FutureStatus.rejected => StoreState.notAvailable,
        FutureStatus.fulfilled =>
          _subscriptionConfigFuture.value != null ? StoreState.available : StoreState.notAvailable,
      };

  Future<List<PurchasableProduct>> _fetchProducts() async {
    final [subscription, config] = await Future.wait<Object?>([
      _subscriptionFuture,
      _subscriptionConfigFuture,
    ]);
    if (subscription is! Subscription || config is! api.SubscriptionConfigResponse) {
      return [];
    }

    return _subscriptionService.getProductsDetails(config, subscription.planId);
  }

  @action
  Future<Subscription> _fetchSubscription() async {
    if (_authSessionStore.status != AuthStatus.authenticated) {
      return Subscription.empty();
    }
    final subscription = await _subscriptionService.fetchSubscriptionDetails();
    _setSubscriptionAnalyticsProps(subscription).ignore();
    return subscription;
  }

  Future<void> _setSubscriptionAnalyticsProps(Subscription subscription) async {
    final userStatus = subscription.active
        ? 'paid'
        : (subscription.expired ?? false)
            ? 'expired_paid'
            : 'not_paid';
    _analyticsStore
      ..setUserProperty(
        AnalyticsUserProperty.fromEnum(
          name: AnalyticsUserPropName.planId,
          value: subscription.planId ?? '',
        ),
      )
      ..setUserProperty(
        AnalyticsUserProperty.fromEnum(
          name: AnalyticsUserPropName.validTo,
          value: subscription.activeUntil.toString(),
        ),
      )
      ..setUserProperty(
        AnalyticsUserProperty.fromEnum(
          name: AnalyticsUserPropName.userStatus,
          value: userStatus,
        ),
      );
  }

  Future<api.SubscriptionConfigResponse?> _fetchSubscriptionConfig() async {
    if (Platform.isWindows) {
      return null;
    }
    try {
      final config = await _subscriptionService.fetchSubscriptionConfig();
      _purchaseStream ??= _inAppPurchase.purchaseStream.listen(
        _onPurchaseUpdate,
        onDone: _updateStreamOnDone,
        onError: (error) async {
          debugPrint('Purchase stream error: $error');
          await _updateStreamOnError();
        },
      );
      await _subscriptionService.clearPendingTransactions();
      return config;
    } on NotAvailableException catch (_) {
      return null;
    }
  }

  Future<String?> _fetchOtherSubscriber() async {
    final subscription = await _subscriptionFuture;
    if (subscription.active) {
      return null;
    }

    try {
      final user = await _authSessionStore.userFuture;
      final (email, activeUntil) = await _secureStorageService.getSubscriptionPaymentInfo();
      if (email != user!.username && activeUntil.isAfter(DateTime.now())) {
        return email;
      }
    } catch (e, stack) {
      if (kDebugMode) {
        log('Failed to fetch other subscriber', error: e, stackTrace: stack);
      }
    }

    return null;
  }

  @action
  Future<List<PurchasableProduct>> refreshProducts() async {
    _productsFuture = _productsFuture.replaceOrReset(
      _fetchProducts(),
    );
    return await _productsFuture;
  }

  @action
  Future<Subscription> refreshSubscription() async {
    if (_subscriptionFuture.value?.active == false ||
        (_subscriptionFuture.value?.isExpired ?? false) ||
        _subscriptionFuture.status == FutureStatus.rejected) {
      _subscriptionFuture = _subscriptionFuture.replaceOrReset(
        _fetchSubscription(),
      );
    }

    return await _subscriptionFuture;
  }

  @action
  Future<api.SubscriptionConfigResponse?> refreshSubscriptionConfig() async {
    _subscriptionConfigFuture = _subscriptionConfigFuture.replaceOrReset(
      _fetchSubscriptionConfig(),
    );
    return await _subscriptionConfigFuture;
  }

  @action
  Future<String?> refreshOtherSubscriber() async {
    _otherSubscriberEmailFuture = _otherSubscriberEmailFuture.replaceOrReset(
      _fetchOtherSubscriber(),
    );
    return await _otherSubscriberEmailFuture;
  }

  @action
  Future<void> refreshAll() async {
    await Future.wait([
      refreshSubscriptionConfig(),
      refreshSubscription(),
    ]);

    await Future.wait([
      refreshProducts(),
      refreshOtherSubscriber(),
    ]);
  }

  @action
  Future<void> subscribeToPackage({required ProductDetails product}) async {
    try {
      _subscriptionStatus = SubscriptionStatus.pending;
      final user = (await _authSessionStore.userFuture)!;
      final subscription = await _subscriptionFuture;
      final products = await _productsFuture;

      String? purchasedProductId;
      if (subscription.active && subscription.gateway == 'google' && subscription.planId != null) {
        final product = products.firstWhereOrNull((it) => it.id == subscription.planId!);
        purchasedProductId = product?.productDetails.id;
      }

      await _subscriptionService.subscribeToPackage(
        productDetails: product,
        purchasedProductId: purchasedProductId,
        userId: user.userId,
      );
      _analyticsStore.logEvent(
        AnalyticsEvent.returnStore,
        parameters: {
          'planType': product.id,
          'price': product.rawPrice.toString(),
          'item_ids': products.map((e) => e.id).toList(),
        },
      );
    } catch (e) {
      _subscriptionService.clearPendingTransactions();
      if (await _subscriptionService.hasApplePendingPurchasingTransactions()) {
        _subscriptionStatus = SubscriptionStatus.pendingTransaction;
      } else {
        _subscriptionStatus = SubscriptionStatus.error;
      }
      _analyticsStore.logEvent(
        AnalyticsEvent.subscriptionError,
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

  Future<void> _updateStreamOnDone() async {
    await _purchaseStream?.cancel();
    _purchaseStream = null;
  }

  Future<void> _updateStreamOnError() async {
    await _purchaseStream?.cancel();
    _purchaseStream = null;
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
    final products = await _productsFuture;
    final product = products.firstWhereOrNull(
      (it) => it.productDetails.id == purchaseDetails.productID,
    );

    if ([PurchaseStatus.error, PurchaseStatus.canceled].contains(purchaseDetails.status)) {
      if (product != null) {
        product.status = ProductStatus.purchasable;
      }
      if (purchaseDetails.status == PurchaseStatus.canceled ||
          (purchaseDetails.status == PurchaseStatus.error &&
              purchaseDetails.error?.code == 'purchase_error')) {
        await _subscriptionService.clearPendingTransactions();
      }
      _subscriptionStatus = purchaseDetails.status.subscriptionStatus;
      _analyticsStore.logEvent(
        purchaseDetails.status == PurchaseStatus.error
            ? AnalyticsEvent.subscriptionError
            : AnalyticsEvent.subscriptionCancel,
        parameters: {
          'planType': product?.id,
          'price': product?.productDetails.rawPrice.toString(),
          'error': purchaseDetails.error?.message,
        },
      );
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
        productId: product?.id ?? '',
        price: product?.productDetails.rawPrice.toString() ?? '',
        currency: product?.productDetails.currencyCode ?? '',
        duration: product?.duration ?? 0,
        purchaseDetails: purchaseDetails,
      );
      final subscription = await _subscriptionFuture;
      if (purchaseDetails.status == PurchaseStatus.purchased && subscription.active) {
        if (product != null) {
          for (final product in products) {
            product.status = product.id == subscription.planId
                ? ProductStatus.purchased
                : ProductStatus.purchasable;
          }
        }
        _subscriptionStatus = SubscriptionStatus.purchased;
        await _secureStorageService.saveSubscriptionPaymentInfo(
          email: _authSessionStore.user!.username,
          activeUntil: subscription.activeUntil,
        );
      } else {
        _subscriptionStatus = SubscriptionStatus.notVerified;
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
  Future<void> verifyPurchase({
    required String productId,
    required String price,
    required String currency,
    required int duration,
    required PurchaseDetails purchaseDetails,
  }) async {
    if (_subscriptionStatus == SubscriptionStatus.pending) {
      _subscriptionStatus = SubscriptionStatus.verifying;
    }
    try {
      _subscriptionFuture = _subscriptionFuture.replace(
        _subscriptionService.verifyPurchase(
          serverVerificationData: purchaseDetails.verificationData.serverVerificationData,
          planId: productId,
          transactionId: purchaseDetails.purchaseID ?? '',
        ),
      );
      await _subscriptionFuture;
      _analyticsStore.logPaymentSuccess(
        productId: productId,
        price: price,
        duration: duration,
        currency: currency,
      );
    } catch (e) {
      _subscriptionStatus = SubscriptionStatus.verifyingError;
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
    final lastPurchase = _lastPurchase;
    if (lastPurchase == null) {
      return;
    }

    final products = await _productsFuture;
    final product = products.firstWhereOrNull(
      (it) => it.productDetails.id == lastPurchase.productID,
    );
    if (product == null) {
      return;
    }

    try {
      _subscriptionStatus = SubscriptionStatus.verifying;
      _subscriptionFuture = _subscriptionFuture.replace(
        _subscriptionService.verifyPurchase(
          serverVerificationData: lastPurchase.verificationData.serverVerificationData,
          planId: product.id,
          transactionId: lastPurchase.purchaseID ?? '',
        ),
      );
      final subscription = await _subscriptionFuture;
      _subscriptionStatus =
          subscription.active ? SubscriptionStatus.purchased : SubscriptionStatus.notVerified;
    } catch (e) {
      _subscriptionStatus = SubscriptionStatus.verifyingError;
    }
  }

  @action
  Future<void> manageSubscription() async {
    final subscription = await _subscriptionFuture;
    final user = (await _authSessionStore.userFuture)!;

    if (!subscription.active) {
      throw const SubscriptionRequiredException();
    }
    var products = await _productsFuture;
    if (products.isEmpty) {
      products = await refreshProducts();
    }
    final product = products.firstWhereOrNull((it) => it.id == subscription.planId);
    if (product == null) {
      throw const SubscriptionRequiredException();
    }

    await _subscriptionService.manageSubscription(
      productDetails: product.productDetails,
      userId: user.userId,
    );
  }

  @action
  void mockSubscriptionFailureStatus() {
    _subscriptionFuture = ObservableFuture.error(Exception('mock error'));
  }

  FutureOr<void> dispose() async {
    _authReactionDisposer?.call();
    await _purchaseStream?.cancel();
    _purchaseStream = null;
  }
}
