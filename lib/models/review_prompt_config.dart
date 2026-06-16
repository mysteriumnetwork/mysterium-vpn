/// Tunables for the in-app review/feedback prompt, delivered as a single
/// ConfigCat JSON value (`reviewPromptConfig`). Each field falls back to its
/// default independently when missing, the wrong type, or negative, so a
/// partial or slightly malformed payload still yields a usable config.
///
/// Durations (account age, cooldowns) are expressed in **minutes** so QA can
/// configure short, testable windows; production sets the day-equivalents
/// (e.g. 7 days = 10080, 30 days = 43200).
class ReviewPromptConfig {
  const ReviewPromptConfig({
    this.enabled = true,
    this.minAccountAgeMinutes = 10080, // 7 days
    this.minAppOpens = 5,
    this.minConnections = 10,
    this.cleanSessionsRequired = 3,
    this.stableSessionSeconds = 60,
    this.cooldownDismissMinutes = 43200, // 30 days
    this.cooldownNegativeMinutes = 108000, // 75 days
    this.cooldownPositiveMinutes = 151200, // 105 days
    this.yearlyCap = 3,
  });

  factory ReviewPromptConfig.fromJson(Map<String, dynamic> json) {
    const defaults = ReviewPromptConfig();

    // Accept a value only when it is a non-negative int; `0` is valid (e.g.
    // dropping an eligibility gate or disabling a cooldown).
    int nonNegative(String key, int fallback) {
      final value = json[key];
      return value is int && value >= 0 ? value : fallback;
    }

    final enabled = json['enabled'];

    return ReviewPromptConfig(
      enabled: enabled is bool ? enabled : defaults.enabled,
      minAccountAgeMinutes: nonNegative('minAccountAgeMinutes', defaults.minAccountAgeMinutes),
      minAppOpens: nonNegative('minAppOpens', defaults.minAppOpens),
      minConnections: nonNegative('minConnections', defaults.minConnections),
      cleanSessionsRequired: nonNegative('cleanSessionsRequired', defaults.cleanSessionsRequired),
      stableSessionSeconds: nonNegative('stableSessionSeconds', defaults.stableSessionSeconds),
      cooldownDismissMinutes: nonNegative(
        'cooldownDismissMinutes',
        defaults.cooldownDismissMinutes,
      ),
      cooldownNegativeMinutes: nonNegative(
        'cooldownNegativeMinutes',
        defaults.cooldownNegativeMinutes,
      ),
      cooldownPositiveMinutes: nonNegative(
        'cooldownPositiveMinutes',
        defaults.cooldownPositiveMinutes,
      ),
      yearlyCap: nonNegative('yearlyCap', defaults.yearlyCap),
    );
  }

  /// Master switch for the prompt.
  final bool enabled;

  /// Minimum account age (minutes) before the prompt is eligible.
  final int minAccountAgeMinutes;

  /// Minimum number of app opens before the prompt is eligible.
  final int minAppOpens;

  /// Minimum successful VPN connections before the prompt is eligible.
  final int minConnections;

  /// How many of the most recent sessions must be clean (no disconnect/error)
  /// for the user to be eligible. `0` disables the recent-sessions check.
  final int cleanSessionsRequired;

  /// How long (seconds) a connection must stay up to count as a stable session.
  final int stableSessionSeconds;

  /// Cooldown (minutes) after the user dismisses the prompt.
  final int cooldownDismissMinutes;

  /// Cooldown (minutes) after the user gives negative feedback.
  final int cooldownNegativeMinutes;

  /// Cooldown (minutes) after the native review prompt is opened.
  final int cooldownPositiveMinutes;

  /// Maximum prompt displays allowed per rolling year. `0` disables the cap.
  final int yearlyCap;
}
