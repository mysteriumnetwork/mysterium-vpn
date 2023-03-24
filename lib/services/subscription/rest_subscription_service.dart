// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/exceptions/store_not_available.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/models/purchasable_product.dart';
import 'package:mysterium_vpn/models/subscription.dart';
import 'package:mysterium_vpn/models/subscription_config.dart';
import 'package:mysterium_vpn/models/subscription_request.dart';
import 'package:mysterium_vpn/services/local_db_service.dart';
import 'package:mysterium_vpn/services/subscription/subscription_service.dart';

const kFetchSubscriptionInfo = '/subscription';
const kFetchSubscriptionConfig = '/subscription/config';
const kCreateSubscriptionRequest = '/subscription';

class RestSubscriptionService extends SubscriptionService {
  RestSubscriptionService({
    required Dio apiClient,
    required InAppPurchase inAppPurchase,
    required LocalDBService localDb,
  })  : _apiClient = apiClient,
        _inAppPurchase = inAppPurchase,
        _localDb = localDb;

  final Dio _apiClient;
  final InAppPurchase _inAppPurchase;
  final LocalDBService _localDb;

  @override
  String? getSubscriptionPlan() => _localDb.getSubscriptionPlan();

  @override
  Future<Subscription> verifyPurchase({
    required String source,
    required String verificationData,
    required String productId,
    required String purchaseId,
  }) async {
    final res = await fetchSubscriptionDetails();
    if (res.active) {
      await _localDb.setSubscriptionPlan(
        subscriptionPlan: productId,
        subscriptionPurchaseId: purchaseId,
      );
    }
    return res;
  }

  @override
  Future<bool> subscribeToPackage({
    required ProductDetails productDetails,
    required String? purchasedProductId,
    required String userId,
  }) async {
    late PurchaseParam purchaseParam;
    if (Platform.isAndroid) {
      final purchaseId = _localDb.getSubscriptionPurchaseId();
      GooglePlayPurchaseDetails? details;
      if (purchasedProductId != null && purchaseId != null) {
        final androidAddition =
            _inAppPurchase.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
        final oldPurchases = await androidAddition.queryPastPurchases();
        details = oldPurchases.pastPurchases.firstWhereOrNull(
          (element) => element.productID == purchasedProductId && element.purchaseID == purchaseId,
        );
      }

      purchaseParam = GooglePlayPurchaseParam(
        productDetails: productDetails,
        applicationUserName: userId,
        changeSubscriptionParam: (details != null)
            ? ChangeSubscriptionParam(
                oldPurchaseDetails: details,
                prorationMode: ProrationMode.immediateWithTimeProration,
              )
            : null,
      );
    } else {
      purchaseParam = AppStorePurchaseParam(
        productDetails: productDetails,
        applicationUserName: userId,
      );
    }
    return _inAppPurchase.buyNonConsumable(
      purchaseParam: purchaseParam,
    );
  }

  @override
  List<PurchasableProduct> getProductsDetails(SubscriptionConfig subscriptionConfig) {
    try {
      final purchasedProductId = _localDb.getSubscriptionPlan();

      final plans = subscriptionConfig.plans
        ..sortByCompare((e) => e.price.euro, (a, b) => a.compareTo(b));
      return plans
          .map(
            (e) => PurchasableProduct(
              productDetails: e,
              status:
                  purchasedProductId == e.id ? ProductStatus.purchased : ProductStatus.purchasable,
            ),
          )
          .toList();
    } on Exception catch (e) {
      throw handleException(e);
    }
  }

  @override
  Future<void> clearPendingTransactions() async {
    if (Platform.isIOS) {
      final transactions = await SKPaymentQueueWrapper().transactions();
      for (final transaction in transactions) {
        await SKPaymentQueueWrapper().finishTransaction(transaction);
      }
    }
  }

  @override
  Future<Subscription> fetchSubscriptionDetails() async {
    try {
      final res = await _apiClient.get(kFetchSubscriptionInfo);
      // return Subscription(active: true);
      return Subscription.fromJson(res.data as Map<String, dynamic>);
    } on Exception catch (e) {
      debugPrint(e.toString());
      throw handleException(e);
    }
  }

  @override
  Future<SubscriptionConfig> fetchSubscriptionConfig() async {
    try {
      final isStoreAvailable = await _inAppPurchase.isAvailable();
      if (!isStoreAvailable) {
        throw StoreNotAvailableException();
      }
      final res = await _apiClient.get(kFetchSubscriptionConfig);

      final config = SubscriptionConfig.fromJson(res.data as Map<String, dynamic>);
      final gateway =
          config.gateways.firstWhereOrNull((element) => element.name == getPlatformGateway());
      if (gateway == null || !gateway.enabled) {
        throw StoreNotAvailableException();
      }
      return config;
    } on StoreNotAvailableException catch (_) {
      rethrow;
    } on Exception catch (e) {
      debugPrint(e.toString());
      throw handleException(e);
    }
  }

  @override
  Future<ProductDetails> createSubscriptionRequest(SubscriptionRequest subscriptionRequest) async {
    try {
      // final res =
      //     await _apiClient.post<Map<String, dynamic>>(kCreateSubscriptionRequest, data: subscriptionRequest.toJson());
      // final subscriptionProductId = res.data?['subscription_product_id'] as String?;
      // if (subscriptionProductId == null) {
      //   throw PackageNotFoundException();
      // }
      //TODO: FIX LATER
      const subscriptionProductId = 'monthly_vpn_plan';

      final productDetails = await _inAppPurchase.queryProductDetails({subscriptionProductId});
      final product = productDetails.productDetails
          .firstWhereOrNull((element) => element.id == subscriptionProductId);
      if (product == null) {
        throw PackageNotFoundException();
      }
      return product;
    } on Exception catch (e) {
      debugPrint(e.toString());
      throw handleException(e);
    }
  }
}
