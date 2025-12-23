import 'package:in_app_purchase/in_app_purchase.dart';

enum SubscriptionStatus {
  pending(isError: false, isLoading: true),
  purchased(isError: false, isLoading: false),
  error(isError: true, isLoading: false),
  restored(isError: false, isLoading: false),
  canceled(isError: false, isLoading: false),
  verifyingError(isError: true, isLoading: false),
  verifying(isError: false, isLoading: true),
  notVerified(isError: false, isLoading: false),
  pendingTransaction(isError: false, isLoading: true);

  const SubscriptionStatus({
    required this.isLoading,
    required this.isError,
  });

  final bool isLoading;
  final bool isError;
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
