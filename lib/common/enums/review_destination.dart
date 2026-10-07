/// Where the review prompt's "Leave a review" button sends the user.
///
/// Selected per user by an A/B variant so the split can be dialled remotely
/// without a release; [store] is the safe default whenever the variant is
/// missing or unrecognised.
enum ReviewDestination {
  /// The platform's native store review prompt (`in_app_review`).
  store,

  /// Trustpilot's in-app review collector, opened in a webview.
  trustpilot;

  /// Case-insensitive: the variant is typed by hand in the ConfigCat dashboard,
  /// and a capitalised brand name would otherwise fall back to [store] for every
  /// user with nothing logged anywhere.
  static ReviewDestination fromName(String? value) {
    final name = value?.trim().toLowerCase();
    return values.firstWhere((it) => it.name == name, orElse: () => store);
  }
}
