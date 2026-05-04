// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_2_wrappers.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/models/models.dart' hide Response;
import 'package:mysterium_vpn/services/services.dart' hide Response;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:retry/retry.dart';
import 'package:talker/talker.dart';
import 'package:vpn_api/vpn_api.dart' as api;

const kFetchSubscriptionConfig = '/subscription/config';

class RestSubscriptionService extends SubscriptionService {
  RestSubscriptionService({
    required api.VpnApi api,
    required InAppPurchase inAppPurchase,
    required Talker logger,
  }) : _apiSubscription = api.getSubscription(),
       _inAppPurchase = inAppPurchase,
       _logger = logger;

  final api.Subscription _apiSubscription;
  final InAppPurchase _inAppPurchase;
  final Talker _logger;

  @override
  Future<Subscription> verifyPurchase({
    required String serverVerificationData,
    required String planId,
    required String transactionId,
  }) async {
    try {
      Response<void> res;
      if (Platform.isAndroid) {
        res = await _apiSubscription.subscriptionUserCallback(
          userCallbackRequest: api.UserCallbackRequest(
            gatewayId: api.UserCallbackRequestGatewayIdEnum.google,
            payload: serverVerificationData,
          ),
        );
      } else {
        res = await _apiSubscription.subscriptionUserCallback(
          userCallbackRequest: api.UserCallbackRequest(
            gatewayId: api.UserCallbackRequestGatewayIdEnum.apple,
            transactionId: transactionId,
          ),
        );
      }
      if (res.statusCode == 200) {
        return await fetchActiveSubscription(planId);
      } else {
        throw SubscriptionVerificationException();
      }
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }

  Future<Subscription> fetchActiveSubscription(String planId) async => retry(
    () async {
      final subs = await fetchSubscriptionDetails();
      if (subs.active) {
        return subs;
      }
      throw Exception('Subscription not active');
    },
    maxAttempts: 3,
    delayFactor: const Duration(seconds: 1),
  ).catchError((_) => Subscription(planId: planId, active: false));

  @override
  Future<void> subscribeToPackage({
    required ProductDetails productDetails,
    required String? purchasedProductId,
    required String userId,
  }) async {
    try {
      late PurchaseParam purchaseParam;
      if (Platform.isAndroid) {
        GooglePlayPurchaseDetails? details;
        if (purchasedProductId != null) {
          final androidAddition = _inAppPurchase
              .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
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
                  replacementMode: ReplacementMode.withTimeProration,
                )
              : null,
        );
      } else {
        purchaseParam = AppStorePurchaseParam(
          productDetails: productDetails,
          applicationUserName: userId,
        );
      }
      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }

  Future<void> openAndroidManageSubscriptions(String productId) async {
    final info = await PackageInfo.fromPlatform();
    final packageName = info.packageName;
    final url =
        'https://play.google.com/store/account/subscriptions?sku=$productId&package=$packageName';

    await openUrlLink(Uri.parse(url));
  }

  @override
  Future<List<PurchasableProduct>> getProductsDetails(
    api.SubscriptionConfigResponse subscriptionConfig,
    String? purchasedProductId,
  ) async {
    try {
      final plans =
          (subscriptionConfig.plans
                .map((e) => Platform.isAndroid ? e.googleProductId : e.appleProductId)
                .nonNulls
                .toSet())
            ..removeWhere(
              (element) => element.isEmpty || element == 'not_supported' || element == 'not_found',
            );
      final subsConfPlans = subscriptionConfig.plans.where(
        (element) =>
            plans.contains(Platform.isAndroid ? element.googleProductId : element.appleProductId),
      );
      final storePlans = (await _inAppPurchase.queryProductDetails(plans)).productDetails
        ..removeWhere((element) => element.rawPrice <= 0 || element.price.toLowerCase() == 'free');
      final productsDetails = <PurchasableProduct>[];

      for (final plan in subsConfPlans) {
        ProductDetails? productDetails;
        double? rawPrice;
        double? introductoryPrice;
        final offers = <ProductOffer>[];
        if (Platform.isAndroid) {
          final products = storePlans
              .where((element) => element.id == plan.googleProductId)
              .toList();
          if (products.length > 1) {
            products.sort((a, b) => a.rawPrice.compareTo(b.rawPrice));
            productDetails = products.firstOrNull;
            rawPrice = products.lastOrNull?.rawPrice;
            introductoryPrice = productDetails?.rawPrice;
          } else {
            productDetails = storePlans.firstWhereOrNull(
              (element) => element.id == plan.googleProductId,
            );
          }

          if (productDetails is GooglePlayProductDetails) {
            final subOfferDetails = productDetails.productDetails.subscriptionOfferDetails;
            if (subOfferDetails != null) {
              for (final detail in subOfferDetails) {
                try {
                  offers.add(ProductOffer.fromGooglePlay(detail));
                } catch (e, stack) {
                  _logger.handle(e, stack);
                }
              }
            }
          }
        } else {
          productDetails = storePlans.firstWhereOrNull(
            (element) => element.id == plan.appleProductId,
          );
          if (productDetails is AppStoreProduct2Details) {
            final skProduct = productDetails.sk2Product;
            final promoOffers = skProduct.subscription?.promotionalOffers;
            final isEligibleForIntro = await isEligibleForIntroOffer(productDetails.id);
            if (promoOffers != null && promoOffers.isNotEmpty) {
              for (final offer in promoOffers) {
                try {
                  if (isEligibleForIntro || offer.type != SK2SubscriptionOfferType.introductory) {
                    offers.add(ProductOffer.fromAppStore(offer, productDetails));
                  }
                } catch (e, stack) {
                  _logger.handle(e, stack);
                }
              }
              final offer = promoOffers.firstWhereOrNull(
                (element) => element.type == SK2SubscriptionOfferType.introductory,
              );
              introductoryPrice = offer?.price;
            }
          }
        }
        if (productDetails == null) {
          continue;
        }
        productsDetails.add(
          PurchasableProduct(
            planDetails: plan,
            productDetails: productDetails,
            status: purchasedProductId == plan.id
                ? ProductStatus.purchased
                : ProductStatus.purchasable,
            rawPrice: rawPrice ?? productDetails.rawPrice,
            currencyCode: productDetails.currencyCode,
            currencySymbol: productDetails.currencySymbol,
            introductoryPrice: introductoryPrice,
            hasIntroductoryPrice: await _hasIntroductoryPrice(productDetails.id, introductoryPrice),
            offers: offers,
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

  @override
  Future<void> clearPendingTransactions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      final transactions = await SK2Transaction.transactions();
      for (final transaction in transactions) {
        await SK2Transaction.finish(int.parse(transaction.id));
      }
    }
  }

  @override
  Future<Subscription> fetchSubscriptionDetails() async {
    try {
      final res = await _apiSubscription.subscriptionStatus();
      if (res.data == null) {
        throw Exception('No data found');
      }
      final data = res.data!;

      return Subscription(
        id: data.subscriptionId,
        active: data.active,
        planId: data.planId,
        gateway: data.gateway,
        activeUntil: data.activeUntil,
        expired: data.expired,
        recurring: data.recurring,
        storePlanId: data.storePlanId,
        periodStart: data.periodStart,
      );
    } on ApiException {
      rethrow;
    } on Exception catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<api.GetPlanResponse> fetchSubscriptionPlan() async {
    final res = await _apiSubscription.plan();
    return res.data!;
  }

  @override
  Future<api.SubscriptionConfigResponse> fetchSubscriptionConfig() async {
    try {
      final res = await _apiSubscription.subscriptionConfig();
      if (res.data == null) {
        throw Exception('No data found');
      }

      return res.data!;
    } on ApiException {
      rethrow;
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<bool> isEligibleForIntroOffer(String productId) async {
    if (!Platform.isIOS && !Platform.isMacOS) {
      return false;
    }
    try {
      final iapStoreKitPlatform = InAppPurchasePlatform.instance as InAppPurchaseStoreKitPlatform;
      return await iapStoreKitPlatform.isIntroductoryOfferEligible(productId);
    } catch (e, s) {
      _logger.handle(e, s);
      return false;
    }
  }

  Future<bool> _hasIntroductoryPrice(String productId, double? introductoryPrice) async {
    var isEligible = true;
    if (Platform.isIOS || Platform.isMacOS) {
      isEligible = await isEligibleForIntroOffer(productId);
    }

    return isEligible && introductoryPrice != null && introductoryPrice > 0;
  }

  @override
  Future<void> manageSubscription({
    required ProductDetails productDetails,
    required String userId,
  }) async {
    if (Platform.isAndroid) {
      return openAndroidManageSubscriptions(productDetails.id);
    } else if (Platform.isIOS || Platform.isMacOS) {
      return subscribeToPackage(
        productDetails: productDetails,
        userId: userId,
        purchasedProductId: null,
      );
    }
  }
}
