import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mysterium_vpn/models/purchasable_product.dart';
import 'package:mysterium_vpn/models/subscription.dart';
import 'package:mysterium_vpn/models/subscription_config.dart';
import 'package:mysterium_vpn/models/subscription_request.dart';

abstract class SubscriptionService {
  Future<Subscription> verifyPurchase({
    required String source,
    required String verificationData,
    required String productId,
    required String purchaseId,
  });
  String? getSubscriptionPlan();

  Future<Subscription> fetchSubscriptionDetails();

  Future<bool> subscribeToPackage({
    required ProductDetails productDetails,
    required String? purchasedProductId,
    required String userId,
  });

  List<PurchasableProduct> getProductsDetails(SubscriptionConfig subscriptionConfig);

  Future<SubscriptionConfig> fetchSubscriptionConfig();

  Future<ProductDetails> createSubscriptionRequest(SubscriptionRequest subscriptionRequest);
  Future<void> clearPendingTransactions();
}
