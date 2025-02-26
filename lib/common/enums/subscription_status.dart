import 'package:in_app_purchase/in_app_purchase.dart';

enum SubscriptionStatus {
  pending,
  purchased,
  error,
  restored,
  canceled,
  verifyingError,
  verifying,
  notVerified,
  pendingTransaction,
}

extension PurchaseStatusExtensions on PurchaseStatus {
  SubscriptionStatus get subscriptionStatus => switch (this) {
        PurchaseStatus.purchased => SubscriptionStatus.purchased,
        PurchaseStatus.pending => SubscriptionStatus.pending,
        PurchaseStatus.error => SubscriptionStatus.error,
        PurchaseStatus.restored => SubscriptionStatus.restored,
        PurchaseStatus.canceled => SubscriptionStatus.canceled
      };
}
