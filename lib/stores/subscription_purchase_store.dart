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
  ) {
    debugPrint('MAZLOG SubscriptionPurchaseStore constructed storeHash=${identityHashCode(this)}');
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
    debugPrint(
      'MAZLOG _refresh called, existing _purchaseStream=${_purchaseStream != null} '
      'storeHash=${identityHashCode(this)}',
    );
    _purchaseStream ??= _inAppPurchase.purchaseStream.listen(
      _onPurchaseUpdate,
      onDone: () async {
        debugPrint('MAZLOG purchaseStream onDone storeHash=${identityHashCode(this)}');
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
    debugPrint(
      'MAZLOG _refresh listener attached storeHash=${identityHashCode(this)} '
      'streamSubHash=${identityHashCode(_purchaseStream)}',
    );
  }

  @action
  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    debugPrint(
      'MAZLOG _onPurchaseUpdate batch size=${purchaseDetailsList.length} '
      'storeHash=${identityHashCode(this)} '
      'ids=${purchaseDetailsList.map((p) => p.purchaseID).toList()} '
      'objHashes=${purchaseDetailsList.map(identityHashCode).toList()}',
    );
    for (final purchase in purchaseDetailsList) {
      debugPrint(
        'MAZLOG _onPurchaseUpdate item id=${purchase.purchaseID} '
        'product=${purchase.productID} status=${purchase.status} '
        'objHash=${identityHashCode(purchase)}',
      );
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
    final currentSub = _subscriptionStore.subscriptionFuture.value;
    final currentPlanProductId = products
        .firstWhereOrNull((it) => it.id == currentSub?.planId)
        ?.productDetails
        .id;
    final matchesStorePlanId =
        currentSub?.storePlanId != null && currentSub!.storePlanId == purchaseDetails.productID;
    final matchesCurrentPlanProduct =
        currentPlanProductId != null && currentPlanProductId == purchaseDetails.productID;
    debugPrint(
      'MAZLOG _handlePurchase compare '
      'purchaseProduct=${purchaseDetails.productID} '
      'purchaseId=${purchaseDetails.purchaseID} '
      'status=${purchaseDetails.status} '
      'pendingComplete=${purchaseDetails.pendingCompletePurchase} '
      'subActive=${currentSub?.active} '
      'subRecurring=${currentSub?.recurring} '
      'subPlanId=${currentSub?.planId} '
      'subStorePlanId=${currentSub?.storePlanId} '
      'currentPlanProductId=$currentPlanProductId '
      'matchesStorePlanId=$matchesStorePlanId '
      'matchesCurrentPlanProduct=$matchesCurrentPlanProduct '
      'sameAsSubscribedProduct=${matchesStorePlanId || matchesCurrentPlanProduct}',
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
      try {
        debugPrint(
          'MAZLOG completePurchase start '
          'id=${purchaseDetails.purchaseID} '
          'product=${purchaseDetails.productID} '
          'status=${purchaseDetails.status}',
        );
        await _inAppPurchase.completePurchase(purchaseDetails);
        debugPrint(
          'MAZLOG completePurchase success '
          'id=${purchaseDetails.purchaseID}',
        );
      } catch (e, stack) {
        debugPrint(
          'MAZLOG completePurchase FAILED '
          'id=${purchaseDetails.purchaseID} '
          'error=$e',
        );
        debugPrint('MAZLOG completePurchase stack: $stack');
        _logger.handle(e, stack);
      }
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
    debugPrint(
      'MAZLOG verifyPurchase start '
      'transactionId=${purchaseDetails.purchaseID} '
      'storeProduct=${purchaseDetails.productID} '
      'planId=$productId',
    );
    try {
      await _subscriptionStore.updateSubscription(
        () => _subscriptionService.verifyPurchase(
          serverVerificationData: purchaseDetails.verificationData.serverVerificationData,
          planId: productId,
          transactionId: purchaseDetails.purchaseID ?? '',
        ),
      );
      final after = _subscriptionStore.subscriptionFuture.value;
      debugPrint(
        'MAZLOG verifyPurchase SUCCESS '
        'transactionId=${purchaseDetails.purchaseID} '
        'active=${after?.active} recurring=${after?.recurring} '
        'planId=${after?.planId} storePlanId=${after?.storePlanId}',
      );
      _analyticsStore.logPaymentSuccess(
        productId: productId,
        price: price,
        duration: duration,
        currency: currency,
      );
    } catch (e) {
      debugPrint(
        'MAZLOG verifyPurchase FAILED '
        'transactionId=${purchaseDetails.purchaseID} '
        'storeProduct=${purchaseDetails.productID} '
        'error=$e',
      );
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
    debugPrint('MAZLOG SubscriptionPurchaseStore dispose storeHash=${identityHashCode(this)}');
    await _purchaseStream?.cancel();
    _purchaseStream = null;
  }
}
