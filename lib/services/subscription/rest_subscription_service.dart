// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
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
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/services/data/network/network_service.dart';
import 'package:mysterium_vpn/services/subscription/subscription_service.dart';
import 'package:talker/talker.dart';

const kFetchSubscriptionInfo = '/subscription';
const kFetchSubscriptionConfig = '/subscription/config';
const kCreateSubscriptionRequest = '/subscription';

class RestSubscriptionService extends SubscriptionService {
  RestSubscriptionService({
    required NetworkService networkService,
    required InAppPurchase inAppPurchase,
    required LocalDBService localDb,
    required Talker logger,
  })  : _networkService = networkService,
        _inAppPurchase = inAppPurchase,
        _localDb = localDb,
        _logger = logger;

  final NetworkService _networkService;
  final InAppPurchase _inAppPurchase;
  final LocalDBService _localDb;
  final Talker _logger;

  /// Experiment on verifying purchase using server side verification (webhooks)
  /// Downside: It's taking too long to verify the purchase (1-2min)
  /// Upside: It's more secure and reliable
  /// Might need to be optimized and used in the future
  // @override
  // Future<Subscription> verifyPurchase({
  //   required String serverVerificationData,
  //   required String planId,
  //   required String transactionId,
  // }) async {
  //   try {
  //     late Subscription subs;
  //     var retries = 0;
  //     await Future.doWhile(
  //       () async {
  //         subs = await fetchSubscriptionDetails();
  //         if (subs.active && subs.planId == planId) {
  //           return false;
  //         }
  //         if (retries >= 15) {
  //           return false;
  //         }
  //         await Future.delayed(
  //           const Duration(
  //             milliseconds: 1500,
  //           ),
  //         );
  //         retries++;
  //         return true;
  //       },
  //     );
  //     if (!subs.active || subs.planId != planId) {
  //       throw SubscriptionVerificationException();
  //     }

  //     unawaited(
  //       _localDb.setSubscriptionPurchase(
  //         subscriptionPlan: subs.planId!,
  //         subscriptionPurchaseId: transactionId,
  //       ),
  //     );
  //     return subs;
  //   } catch (e) {
  //     throw SubscriptionVerificationException();
  //   }
  // }

  @override
  Future<Subscription> verifyPurchase({
    required String serverVerificationData,
    required String planId,
    required String transactionId,
  }) async {
    try {
      final gatewayId = getPlatformGateway();
      final res = await _networkService.post(
        '/subscription/user-callback',
        data: {
          'gateway_id': gatewayId,
          if (gatewayId == 'google') 'payload': serverVerificationData,
          if (gatewayId == 'apple') 'transaction_id': transactionId,
        },
      );
      if (res.statusCode == 200) {
        try {
          final subs = await fetchSubscriptionDetails();
          planId = subs.planId ?? planId;
          _localDb.setSubscriptionPurchase(
            subscriptionPlan: planId,
            subscriptionPurchaseId: transactionId,
          );
          return subs;
        } catch (e) {
          return Subscription(
            planId: planId,
            active: true,
          );
        }
      } else {
        throw SubscriptionVerificationException();
      }
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<bool> subscribeToPackage({
    required ProductDetails productDetails,
    required String? purchasedProductId,
    required String userId,
  }) async {
    try {
      late PurchaseParam purchaseParam;
      if (Platform.isAndroid) {
        GooglePlayPurchaseDetails? details;
        if (purchasedProductId != null) {
          final androidAddition =
              _inAppPurchase.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
          final oldPurchases = await androidAddition.queryPastPurchases();
          final oldPurchase = oldPurchases.pastPurchases.where(
            (element) => element.productID == purchasedProductId && element.transactionDate != null,
          );
          if (oldPurchase.isNotEmpty) {
            details = oldPurchase.sortedBy((e) => e.transactionDate!).last;
          }
        }

        purchaseParam = GooglePlayPurchaseParam(
          productDetails: productDetails,
          applicationUserName: userId,
          changeSubscriptionParam: (details != null)
              ? ChangeSubscriptionParam(
                  oldPurchaseDetails: details,
                )
              : null,
        );
      } else {
        purchaseParam = AppStorePurchaseParam(
          productDetails: productDetails,
          applicationUserName: userId,
        );
      }
      return await _inAppPurchase.buyNonConsumable(
        purchaseParam: purchaseParam,
      );
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<PurchasableProduct>> getProductsDetails(
    SubscriptionConfig subscriptionConfig,
    String? purchasedProductId,
  ) async {
    try {
      final plans = (subscriptionConfig.plans
          .map((e) => Platform.isAndroid ? e.googleProductId : e.appleProductId)
          .toSet())
        ..removeWhere(
          (element) => element.isEmpty || element == 'not_supported' || element == 'not_found',
        );
      final storePlans = (await _inAppPurchase.queryProductDetails(plans)).productDetails
        ..removeWhere((element) => element.rawPrice <= 0 || element.price.toLowerCase() == 'free');
      final productsDetails = <PurchasableProduct>[];

      for (final plan in subscriptionConfig.plans) {
        ProductDetails? productDetails;
        double? introductoryPrice;
        if (Platform.isAndroid) {
          final products = storePlans.where(
            (element) => element.id == plan.googleProductId,
          );
          if (products.length > 1) {
            productDetails = products
                .sorted((a, b) => a.rawPrice.compareTo(b.rawPrice))
                .firstWhereOrNull((element) => element.rawPrice > 0);
          } else {
            productDetails = storePlans.firstWhereOrNull(
              (element) => element.id == plan.googleProductId,
            );
          }
        } else {
          productDetails = storePlans.firstWhereOrNull(
            (element) => element.id == plan.appleProductId,
          );
          if (productDetails is AppStoreProductDetails) {
            final skProduct = productDetails.skProduct;
            introductoryPrice = skProduct.introductoryPrice?.price != null
                ? double.tryParse(skProduct.introductoryPrice!.price)
                : null;
          }
        }
        if (productDetails == null) {
          continue;
        }
        productsDetails.add(
          PurchasableProduct(
            planDetails: plan,
            productDetails: productDetails,
            status:
                purchasedProductId == plan.id ? ProductStatus.purchased : ProductStatus.purchasable,
            rawPrice: productDetails.rawPrice,
            currencyCode: productDetails.currencyCode,
            currencySymbol: productDetails.currencySymbol,
            introductoryPrice: introductoryPrice,
          ),
        );
      }
      return productsDetails
        ..sortByCompare((e) => e.productDetails.rawPrice, (a, b) => a.compareTo(b));
    } on ApiException {
      rethrow;
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }

  void handleIntroductoryPricePeriod(ProductDetails productDetails) {
    if (productDetails is GooglePlayProductDetails) {
      final product = productDetails.productDetails;
      if (product.productType == ProductType.subs) {
        // Unwrapping is safe because the product is a subscription.
        final offer = product.subscriptionOfferDetails![productDetails.subscriptionIndex!];
        final pricingPhases = offer.pricingPhases;
        if (pricingPhases.length >= 2 &&
            pricingPhases.first.priceAmountMicros < pricingPhases[1].priceAmountMicros) {
          // Introductory pricing period logic.
        }
      }
    }
  }

  @override
  Future<void> clearPendingTransactions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      final transactions = await SKPaymentQueueWrapper().transactions();
      for (final transaction in transactions) {
        if (transaction.transactionState != SKPaymentTransactionStateWrapper.purchasing) {
          await SKPaymentQueueWrapper().finishTransaction(transaction);
        }
      }
    }
  }

  @override
  Future<Subscription> fetchSubscriptionDetails() async {
    try {
      final data =
          (await _networkService.get(kFetchSubscriptionInfo)).data as Map<String, dynamic>?;
      if (data == null) {
        throw Exception('No data found');
      }
      return Subscription.fromJson(data);
    } on ApiException {
      rethrow;
    } on Exception catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<SubscriptionConfig> fetchSubscriptionConfig() async {
    try {
      final isStoreAvailable = await _inAppPurchase.isAvailable();
      if (!isStoreAvailable) {
        throw NotAvailableException();
      }
      final data =
          (await _networkService.get(kFetchSubscriptionConfig)).data as Map<String, dynamic>?;
      if (data == null) {
        throw Exception('No data found');
      }
      final config = SubscriptionConfig.fromJson(data);
      final gateway =
          config.gateways.firstWhereOrNull((element) => element.name == getPlatformGateway());
      if (gateway == null || !gateway.enabled) {
        throw NotAvailableException();
      }
      return config;
    } on NotAvailableException catch (_) {
      rethrow;
    } on ApiException {
      rethrow;
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }
}
