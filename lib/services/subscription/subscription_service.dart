import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:vpn_api/vpn_api.dart' as api;

abstract class SubscriptionService {
  Future<Subscription> verifyPurchase({
    required String serverVerificationData,
    required String planId,
    required String transactionId,
  });

  Future<Subscription> fetchSubscriptionDetails();

  Future<api.GetPlanResponse> fetchSubscriptionPlan();

  Future<void> subscribeToPackage({
    required ProductDetails productDetails,
    required String? purchasedProductId,
    required String userId,
  });

  Future<List<PurchasableProduct>> getProductsDetails(
    api.SubscriptionConfigResponse subscriptionConfig,
    String? purchasedProductId,
  );

  Future<api.SubscriptionConfigResponse> fetchSubscriptionConfig();

  Future<void> clearPendingTransactions();

  Future<bool> isEligibleForIntroOffer(String productId);

  Future<void> manageSubscription({
    required ProductDetails productDetails,
    required String userId,
  });
}
