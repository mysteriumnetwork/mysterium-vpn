/// Tunables for the in-app review/feedback prompt, delivered as a single
/// ConfigCat JSON value (`reviewPromptConfig`). Each field falls back to its
/// default independently when missing, the wrong type, or negative, so a
/// partial or slightly malformed payload still yields a usable config.
class ReviewPromptConfig {
  const ReviewPromptConfig({
    this.enabled = true,
    this.minAccountAgeDays = 7,
    this.minAppOpens = 5,
    this.minConnections = 10,
    this.cleanSessionsRequired = 3,
    this.stableSessionSeconds = 60,
    this.cooldownDismissDays = 30,
    this.cooldownNegativeDays = 75,
    this.cooldownPositiveDays = 105,
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
      minAccountAgeDays: nonNegative('minAccountAgeDays', defaults.minAccountAgeDays),
      minAppOpens: nonNegative('minAppOpens', defaults.minAppOpens),
      minConnections: nonNegative('minConnections', defaults.minConnections),
      cleanSessionsRequired: nonNegative('cleanSessionsRequired', defaults.cleanSessionsRequired),
      stableSessionSeconds: nonNegative('stableSessionSeconds', defaults.stableSessionSeconds),
      cooldownDismissDays: nonNegative('cooldownDismissDays', defaults.cooldownDismissDays),
      cooldownNegativeDays: nonNegative('cooldownNegativeDays', defaults.cooldownNegativeDays),
      cooldownPositiveDays: nonNegative('cooldownPositiveDays', defaults.cooldownPositiveDays),
      yearlyCap: nonNegative('yearlyCap', defaults.yearlyCap),
    );
  }

  /// Master switch for the prompt.
  final bool enabled;

  /// Minimum account age (days) before the prompt is eligible.
  final int minAccountAgeDays;

  /// Minimum number of app opens before the prompt is eligible.
  final int minAppOpens;

  /// Minimum successful VPN connections before the prompt is eligible.
  final int minConnections;

  /// How many of the most recent sessions must be clean (no disconnect/error)
  /// for the user to be eligible. `0` disables the recent-sessions check.
  final int cleanSessionsRequired;

  /// How long (seconds) a connection must stay up to count as a stable session.
  final int stableSessionSeconds;

  /// Cooldown (days) after the user dismisses the prompt.
  final int cooldownDismissDays;

  /// Cooldown (days) after the user gives negative feedback.
  final int cooldownNegativeDays;

  /// Cooldown (days) after the native review prompt is opened.
  final int cooldownPositiveDays;

  /// Maximum prompt displays allowed per rolling year.
  final int yearlyCap;
}
