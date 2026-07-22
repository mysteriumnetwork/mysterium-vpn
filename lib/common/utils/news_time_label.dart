/// Abbreviated English month names. The News Center is English-only, so dates
/// are formatted with these rather than a locale-dependent `DateFormat` (which
/// would render in the app's locale and require that locale's date symbols).
const _monthsShort = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// Label builders for [newsTimeLabel]. Kept as plain strings/functions so the
/// formatter is unit-testable and free of the translation layer.
class NewsTimeLabels {
  const NewsTimeLabels({
    required this.justNow,
    required this.minutesAgo,
    required this.hoursAgo,
    required this.daysAgo,
  });

  final String justNow;
  final String Function(int minutes) minutesAgo;
  final String Function(int hours) hoursAgo;
  final String Function(int days) daysAgo;
}

/// Formats [createdAt] as a compact relative label, matching the News Center
/// design: `Just now` (< 1 min), `12min ago`, `3h ago`, `2d ago` (< 7 days),
/// and an absolute `d MMM` date (e.g. `14 May`) for anything a week or older.
///
/// A [createdAt] in the future is treated as `Just now`.
String newsTimeLabel(DateTime createdAt, {required DateTime now, required NewsTimeLabels labels}) {
  final diff = now.difference(createdAt);

  if (diff.inMinutes < 1) {
    return labels.justNow;
  }
  if (diff.inMinutes < 60) {
    return labels.minutesAgo(diff.inMinutes);
  }
  if (diff.inHours < 24) {
    return labels.hoursAgo(diff.inHours);
  }
  if (diff.inDays < 7) {
    return labels.daysAgo(diff.inDays);
  }
  // English-only `d MMM` (e.g. "14 May"), independent of the app locale.
  return '${createdAt.day} ${_monthsShort[createdAt.month - 1]}';
}
