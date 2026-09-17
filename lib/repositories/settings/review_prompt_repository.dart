import 'package:mysterium_vpn/services/data/storage.dart';

/// Single source of truth for the state that decides when to ask the user for
/// an app-store review.
abstract class ReviewPromptRepository {
  int? appInstallDay();

  Future<void> setAppInstallDay(int value);

  /// Device-wide opens since install. Distinct from
  /// `PromptsRepository.appOpenCount`, which is per-user and lives in Hive.
  int opensSinceInstall();

  Future<void> setOpensSinceInstall(int value);

  int successfulConnections();

  Future<void> setSuccessfulConnections(int value);

  List<bool> recentSessionOutcomes();

  Future<void> setRecentSessionOutcomes(List<bool> value);

  int? cooldownUntil();

  Future<void> setCooldownUntil(int value);

  List<int> promptShownTimestamps();

  Future<void> setPromptShownTimestamps(List<int> value);

  int? nativeReviewOpenedAt();

  Future<void> setNativeReviewOpenedAt(int value);

  Future<void> reset();
}

/// [ReviewPromptRepository] backed by [SharedPreferenceService].
class LocalReviewPromptRepository implements ReviewPromptRepository {
  LocalReviewPromptRepository(this._prefs);

  final SharedPreferenceService _prefs;

  @override
  int? appInstallDay() => _prefs.getAppInstallDay();

  @override
  Future<void> setAppInstallDay(int value) => _prefs.setAppInstallDay(value);

  @override
  int opensSinceInstall() => _prefs.getReviewAppOpenCount();

  @override
  Future<void> setOpensSinceInstall(int value) => _prefs.setReviewAppOpenCount(value);

  @override
  int successfulConnections() => _prefs.getReviewSuccessfulConnections();

  @override
  Future<void> setSuccessfulConnections(int value) => _prefs.setReviewSuccessfulConnections(value);

  @override
  List<bool> recentSessionOutcomes() => _prefs.getReviewRecentSessionOutcomes();

  @override
  Future<void> setRecentSessionOutcomes(List<bool> value) =>
      _prefs.setReviewRecentSessionOutcomes(value);

  @override
  int? cooldownUntil() => _prefs.getReviewCooldownUntil();

  @override
  Future<void> setCooldownUntil(int value) => _prefs.setReviewCooldownUntil(value);

  @override
  List<int> promptShownTimestamps() => _prefs.getReviewPromptShownTimestamps();

  @override
  Future<void> setPromptShownTimestamps(List<int> value) =>
      _prefs.setReviewPromptShownTimestamps(value);

  @override
  int? nativeReviewOpenedAt() => _prefs.getReviewNativeReviewOpenedAt();

  @override
  Future<void> setNativeReviewOpenedAt(int value) => _prefs.setReviewNativeReviewOpenedAt(value);

  @override
  Future<void> reset() => _prefs.resetReviewPromptState();
}
