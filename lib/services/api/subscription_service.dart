import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mysterium_vpn/models/purchasable_product.dart';

abstract class SubscriptionService {
  Future<bool> verifyPurchase({
    required String source,
    required String verificationData,
    required String productId,
    required String purchaseId,
  });
  String? getSubscriptionPlan();

  Future<void> getApi();

  Future<bool> subscribeToPackage({
    required ProductDetails productDetails,
    required String? purchasedProductId,
  });

  Future<List<PurchasableProduct>> getProductsDetails();
}
