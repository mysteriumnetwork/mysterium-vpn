/// How the current platform lets a user manage an existing subscription.
enum SubscriptionManagementMode {
  /// Android — hand the user to the Play Store subscriptions page.
  playStore,

  /// iOS and macOS — route through StoreKit's purchase flow.
  appStore,

  /// Windows and Linux have no store flow; managing is a no-op there.
  unsupported,
}
