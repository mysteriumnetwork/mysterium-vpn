import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/subscription_required_exception.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/stores/subscription_plans_store.dart';
import 'package:talker/talker.dart';

part 'subscription_purchase_store.g.dart';

// ignore: library_private_types_in_public_api
class SubscriptionPurchaseStore = _SubscriptionPurchaseStore with _$SubscriptionPurchaseStore;

abstract class _SubscriptionPurchaseStore with Store, Disposeable {
  _SubscriptionPurchaseStore(
    this._inAppPurchase,
    this._secureStorageService,
    this._subscriptionService,
    this._logger,
    this._analyticsStore,
    this._authSessionStore,
    this._subscriptionStore,
    this._plansStore,
    this._prefs,
  ) {
    _future.ignore();
  }

  final InAppPurchase _inAppPurchase;
  final SecureStorageService _secureStorageService;
  final SubscriptionService _subscriptionService;
  final Talker _logger;

  final AnalyticsStore _analyticsStore;
  final AuthSessionStore _authSessionStore;
  final SubscriptionStore _subscriptionStore;
  final SubscriptionPlansStore _plansStore;
  final SharedPreferenceService _prefs;

  StreamSubscription<List<PurchaseDetails>>? _purchaseStream;

  @readonly
  PurchaseDetails? _lastPurchase;
  @readonly
  late ObservableFuture<void> _future = ObservableFuture(_refresh());
  @readonly
  SubscriptionStatus? _subscriptionStatus;
  @readonly
  Object? _subscriptionError;

  @action
  Future<void> subscribeToPackage({required ProductDetails product}) async {
    try {
      _subscriptionStatus = SubscriptionStatus.pending;
      final user = (await _authSessionStore.userFuture)!;
      final subscription = await _subscriptionStore.subscriptionFuture;
      final products = await _plansStore.future;

      String? purchasedProductId;
      if (subscription.active && subscription.isGoogleGateway) {
        purchasedProductId = subscription.storePlanId;
        // Fallback: if storePlanId is missing, derive product id from current plan
        if (purchasedProductId == null || purchasedProductId.isEmpty) {
          final currentPlan = products.firstWhereOrNull((plan) => plan.id == subscription.planId);
          purchasedProductId = currentPlan?.productDetails.id;
        }
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
      _subscriptionStatus = null;
    } catch (e, stack) {
      if (e is PlatformException && e.code == 'storekit2_purchase_cancelled') {
        _subscriptionStatus = SubscriptionStatus.canceled;
        return;
      }
      _subscriptionService.clearPendingTransactions();
      _subscriptionStatus = SubscriptionStatus.error;
      _subscriptionError = e;
      _analyticsStore.logEvent(
        AnalyticsEvent.subscriptionError,
        parameters: {
          'planType': product.id,
          'price': product.rawPrice.toString(),
          'error': e.toString(),
        },
      );
      debugPrint(e.toString());
      _logger.handle(e, stack);
    }
  }

  ///Available on devices running iOS 14 and iPadOS 14 and later.
  @action
  Future<void> redeemCode() async {
    if (!Platform.isIOS) {
      return;
    }
    _analyticsStore.logEvent(AnalyticsEvent.redeemOpen);
    try {
      await _inAppPurchase
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>()
          .presentCodeRedemptionSheet();
      _analyticsStore.logEvent(AnalyticsEvent.redeemCodeOpenSuccess);
    } catch (e, stack) {
      debugPrint('Error presenting code redemption sheet: $e');
      _logger.handle(e, stack);
      _analyticsStore.logEvent(
        AnalyticsEvent.redeemCodeOpenError,
        parameters: {'error': e.toString()},
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

    final products = await _plansStore.future;
    final product = products.firstWhereOrNull(
      (it) => it.productDetails.id == lastPurchase.productID,
    );
    if (product == null) {
      return;
    }

    _verifyPurchase(
      productId: product.id,
      price: product.productDetails.rawPrice.toString(),
      currency: product.productDetails.currencyCode,
      duration: product.duration,
      purchaseDetails: lastPurchase,
    );
  }

  @action
  Future<void> manageSubscription() async {
    try {
      final subscription = await _subscriptionStore.subscriptionFuture;
      final user = (await _authSessionStore.userFuture)!;

      if (!subscription.active) {
        throw const SubscriptionRequiredException();
      }
      var products = await _plansStore.future;
      if (products.isEmpty) {
        products = await _plansStore.refresh();
      }
      final product = products.firstWhereOrNull((it) => it.id == subscription.planId);
      if (product == null) {
        throw const SubscriptionRequiredException();
      }

      await _subscriptionService.manageSubscription(
        productDetails: product.productDetails,
        userId: user.userId,
      );
    } catch (e, stack) {
      if (e is PlatformException && e.code == 'storekit2_purchase_cancelled') {
        return;
      }
      debugPrint('Error managing subscription: $e');
      _logger.handle(e, stack);
      rethrow;
    }
  }

  Future<void> _refresh() async {
    _purchaseStream ??= _inAppPurchase.purchaseStream.listen(
      _onPurchaseUpdate,
      onDone: () async {
        await _purchaseStream?.cancel();
        _purchaseStream = null;
      },
      onError: (error, stack) async {
        debugPrint('Purchase stream error: $error');
        if (error is Object) {
          _logger.handle(error);
        }
      },
    );
  }

  @action
  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    for (final purchase in purchaseDetailsList) {
      try {
        await _handlePurchase(purchase);
      } catch (e, stack) {
        debugPrint('Error handling purchase update: $e');
        _logger.handle(e, stack);
      }
    }
  }

  @action
  Future<void> _handlePurchase(PurchaseDetails purchaseDetails) async {
    final products = await _plansStore.future;
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
      if (_subscriptionStatus?.isError ?? false) {
        _subscriptionError =
            purchaseDetails.error?.details?.toString() ?? purchaseDetails.error?.message;
      }
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

    if (purchaseDetails.pendingCompletePurchase) {
      await _inAppPurchase.completePurchase(purchaseDetails);
    }

    try {
      await _verifyPurchase(
        productId: product?.id ?? '',
        price: product?.productDetails.rawPrice.toString() ?? '',
        currency: product?.productDetails.currencyCode ?? '',
        duration: product?.duration ?? 0,
        purchaseDetails: purchaseDetails,
      );
      final subscription = await _subscriptionStore.subscriptionFuture;
      if (purchaseDetails.status == PurchaseStatus.restored ||
          purchaseDetails.status == PurchaseStatus.purchased && subscription.active) {
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
    } catch (e, stack) {
      debugPrint('Error handling purchase details');
      _logger.handle(e, stack);
    } finally {
      _lastPurchase = purchaseDetails;
    }
  }

  @action
  Future<void> _verifyPurchase({
    required String productId,
    required String price,
    required String currency,
    required int duration,
    required PurchaseDetails purchaseDetails,
  }) async {
    _analyticsStore.logEvent(
      AnalyticsEvent.subscriptionVerifyAttempt,
      parameters: {
        'planType': productId,
        'price': price,
        'status': purchaseDetails.status.toString(),
        'id': purchaseDetails.purchaseID,
      },
    );
    if (_subscriptionStatus == SubscriptionStatus.pending) {
      _subscriptionStatus = SubscriptionStatus.verifying;
    }
    try {
      await _subscriptionStore.updateSubscription(
        () => _subscriptionService.verifyPurchase(
          serverVerificationData: purchaseDetails.verificationData.serverVerificationData,
          planId: productId,
          transactionId: purchaseDetails.purchaseID ?? '',
        ),
      );
      await _prefs.setBool(StorageKeys.shouldVerifyPurchase.name, value: false);
      _analyticsStore.logPaymentSuccess(
        productId: productId,
        price: price,
        duration: duration,
        currency: currency,
      );
    } catch (e) {
      // Cancelling subscription when app is in background will fail to verify purchase,
      // so we need to set this flag so that we verify purchase when app is active again.
      // Main problem: no internet connection when app is in background.
      await _prefs.setBool(StorageKeys.shouldVerifyPurchase.name, value: true);
      _subscriptionStatus = SubscriptionStatus.verifyingError;
      _subscriptionError = e;
      _analyticsStore.logEvent(
        AnalyticsEvent.paymentVerificationError,
        parameters: {'planType': productId, 'price': price, 'error': e.toString()},
      );
      rethrow;
    }
  }

  @override
  FutureOr<void> dispose() async {
    await _purchaseStream?.cancel();
    _purchaseStream = null;
  }
}
