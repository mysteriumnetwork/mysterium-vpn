import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/services/services.dart';

/// Single source of truth for which one-off prompts the user has already seen.
abstract class PromptsRepository {
  Future<List<BannerType>> shownBanners();

  Future<void> setShownBanners(List<BannerType> banners);

  Future<void> resetShownBanners();

  Future<DateTime?> pushPromptLastShownAt();

  Future<void> setPushPromptLastShownAt(DateTime dateTime);

  Future<bool> subscriptionOnboardingShown();

  Future<void> setSubscriptionOnboardingShown();

  Future<void> resetSubscriptionOnboardingShown();
}

/// [PromptsRepository] backed by [LocalDBService] (Hive).
class LocalPromptsRepository implements PromptsRepository {
  LocalPromptsRepository(this._db);

  final LocalDBService _db;

  @override
  Future<List<BannerType>> shownBanners() => _db.getShownBanners();

  @override
  Future<void> setShownBanners(List<BannerType> banners) => _db.setShownBanners(banners);

  @override
  Future<void> resetShownBanners() => _db.resetShownBanners();

  @override
  Future<DateTime?> pushPromptLastShownAt() => _db.getPushNotificationsPromptLastShownAt();

  @override
  Future<void> setPushPromptLastShownAt(DateTime dateTime) =>
      _db.setPushNotificationsPromptLastShownAt(dateTime);

  @override
  Future<bool> subscriptionOnboardingShown() => _db.getSubscriptionOnboardingShown();

  @override
  Future<void> setSubscriptionOnboardingShown() => _db.setSubscriptionOnboardingShown();

  @override
  Future<void> resetSubscriptionOnboardingShown() => _db.resetSubscriptionOnboardingShown();
}
