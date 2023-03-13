// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/models/purchasable_product.dart';
import 'package:mysterium_vpn/services/shared_preferences_service.dart';
import 'package:mysterium_vpn/services/subscription/subscription_service.dart';

const kGetInfo = '$baseUrl/accounts/invitation_code';

class RestSubscriptionService extends SubscriptionService {
  RestSubscriptionService({
    required Dio dio,
    required InAppPurchase inAppPurchase,
  })  : _dio = dio,
        _inAppPurchase = inAppPurchase;

  final Dio _dio;
  final InAppPurchase _inAppPurchase;
  final _sharedPrefs = SharedPreferenceService();

  @override
  String? getSubscriptionPlan() => _sharedPrefs.getSubscriptionProductId();

  @override
  Future<bool> verifyPurchase({
    required String source,
    required String verificationData,
    required String productId,
    required String purchaseId,
  }) async =>
      _sharedPrefs.setSubscriptionPlan(productId, purchaseId);

  @override
  Future<void> getApi() async {
    _dio.get(kGetInfo);
  }

  @override
  Future<bool> subscribeToPackage({
    required ProductDetails productDetails,
    required String? purchasedProductId,
  }) async {
    late PurchaseParam purchaseParam;
    if (Platform.isAndroid) {
      final purchaseId = _sharedPrefs.getSubscriptionPurchaseId();
      GooglePlayPurchaseDetails? details;
      if (purchasedProductId != null && purchaseId != null) {
        final androidAddition = _inAppPurchase.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
        final oldPurchases = await androidAddition.queryPastPurchases();
        details = oldPurchases.pastPurchases.firstWhereOrNull(
          (element) => element.productID == purchasedProductId && element.purchaseID == purchaseId,
        );
      }

      purchaseParam = GooglePlayPurchaseParam(
        productDetails: productDetails,
        changeSubscriptionParam: (details != null)
            ? ChangeSubscriptionParam(
                oldPurchaseDetails: details,
                prorationMode: ProrationMode.immediateWithTimeProration,
              )
            : null,
      );
    } else {
      purchaseParam = PurchaseParam(
        productDetails: productDetails,
      );
    }
    return _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  @override
  Future<List<PurchasableProduct>> getProductsDetails() async {
    try {
      final purchasedProductId = _sharedPrefs.getSubscriptionPurchaseId();
      final res = await _inAppPurchase.queryProductDetails(kProductIds.toSet());
      //final res = await Future.delayed(const Duration(seconds: 3), () => productDetailsResponse);

      if (res.notFoundIDs.isNotEmpty) {
        throw PackageNotFoundException();
      }
      res.productDetails.sortByCompare((e) => e.rawPrice, (a, b) => a.compareTo(b));
      return res.productDetails
          .map(
            (e) => PurchasableProduct(
              productDetails: e,
              status: purchasedProductId == e.id ? ProductStatus.purchased : ProductStatus.purchasable,
            ),
          )
          .toList();
    } on Exception catch (_) {
      rethrow;
    }
  }
}
