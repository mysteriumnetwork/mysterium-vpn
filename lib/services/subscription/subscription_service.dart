import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mysterium_vpn/models/purchasable_product.dart';
import 'package:mysterium_vpn/models/subscription.dart';
import 'package:mysterium_vpn/models/subscription_config.dart';

abstract class SubscriptionService {
  Future<Subscription> verifyPurchase({
    required String serverVerificationData,
    required String planId,
    required String transactionId,
  });

  Future<Subscription> fetchSubscriptionDetails();

  Future<bool> subscribeToPackage({
    required ProductDetails productDetails,
    required String? purchasedProductId,
    required String userId,
  });

  Future<List<PurchasableProduct>> getProductsDetails(
    SubscriptionConfig subscriptionConfig,
    String? purchasedProductId,
  );

  Future<SubscriptionConfig> fetchSubscriptionConfig();

  Future<void> clearPendingTransactions();
}
