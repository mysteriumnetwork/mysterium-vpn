// ignore_for_file: depend_on_referenced_packages

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
const kVerifySubscription = '/subscription/user-callback';

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

  @override
  Future<Subscription> verifyPurchase({
    required String serverVerificationData,
    required String planId,
    required String transactionId,
  }) async {
    try {
      final gatewayId = getPlatformGateway();
      final res = await _networkService.post(
        kVerifySubscription,
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
          return subs;
        } catch (e) {
          return Subscription(
            planId: planId,
            active: true,
          );
        } finally {
          await _localDb.setSubscriptionPurchase(
            subscriptionPlan: planId,
            subscriptionPurchaseId: transactionId,
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
      final storePlans = await _inAppPurchase.queryProductDetails(
        subscriptionConfig.plans
            .map((e) => Platform.isAndroid ? e.googleProductId : e.appleProductId)
            .toSet(),
      );
      final productsDetails = <PurchasableProduct>[];

      for (final plan in subscriptionConfig.plans) {
        ProductDetails? productDetails;
        ProductDetails? basePlan;
        double? rawPrice;
        String? currencyCode;
        String? currencySymbol;
        if (Platform.isAndroid) {
          final products = storePlans.productDetails.where(
            (element) => element.id == plan.googleProductId,
          );
          if (products.length > 1) {
            basePlan = products.firstWhereOrNull((element) => element.rawPrice > 0);
            productDetails = products.firstWhere((element) => element.rawPrice == 0);
          } else {
            productDetails = storePlans.productDetails.firstWhereOrNull(
              (element) => element.id == plan.googleProductId,
            );
          }
        } else {
          productDetails = storePlans.productDetails.firstWhereOrNull(
            (element) => element.id == plan.appleProductId,
          );
        }
        rawPrice = basePlan?.rawPrice ?? productDetails?.rawPrice;
        currencyCode = basePlan?.currencyCode ?? productDetails?.currencyCode;
        currencySymbol = basePlan?.currencySymbol ?? productDetails?.currencySymbol;
        if (productDetails != null) {
          productsDetails.add(
            PurchasableProduct(
              planDetails: plan,
              productDetails: productDetails,
              status: purchasedProductId == plan.id
                  ? ProductStatus.purchased
                  : ProductStatus.purchasable,
              rawPrice: rawPrice!,
              currencyCode: currencyCode!,
              currencySymbol: currencySymbol!,
            ),
          );
        }
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

  @override
  Future<void> clearPendingTransactions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      final transactions = await SKPaymentQueueWrapper().transactions();
      for (final transaction in transactions) {
        await SKPaymentQueueWrapper().finishTransaction(transaction);
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
        throw StoreNotAvailableException();
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
        throw StoreNotAvailableException();
      }
      return config;
    } on StoreNotAvailableException catch (_) {
      rethrow;
    } on ApiException {
      rethrow;
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }
}
