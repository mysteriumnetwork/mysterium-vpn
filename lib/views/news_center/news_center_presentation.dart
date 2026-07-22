import 'package:flutter/widgets.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/news_time_label.dart';
import 'package:mysterium_vpn/views/news_center/news_center_strings.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:vpn_api/vpn_api.dart';

/// View-layer mapping of News Center enums to icons and labels.
///
/// Labels are hardcoded English (see news_center_strings.dart): this feature is
/// English-only. A `switch` here fails at compile time if an enum value is added.

IconData newsCategoryIcon(NewscenterCategory category) => switch (category) {
  NewscenterCategory.incident => UntitledUI.alert_triangle,
  NewscenterCategory.news => UntitledUI.file_06,
  NewscenterCategory.offer => UntitledUI.tag_01,
};

String newsCategoryLabel(NewscenterCategory category) => switch (category) {
  NewscenterCategory.incident => newsFilterIncidentsText,
  NewscenterCategory.news => newsFilterNewsText,
  NewscenterCategory.offer => newsFilterOffersText,
};

IconData newsFilterIcon(NewsFilter filter) => switch (filter) {
  NewsFilter.all => UntitledUI.inbox_01,
  NewsFilter.incidents => UntitledUI.alert_triangle,
  NewsFilter.news => UntitledUI.file_06,
  NewsFilter.offers => UntitledUI.tag_01,
};

String newsFilterLabel(NewsFilter filter) => switch (filter) {
  NewsFilter.all => newsFilterAllText,
  NewsFilter.incidents => newsFilterIncidentsText,
  NewsFilter.news => newsFilterNewsText,
  NewsFilter.offers => newsFilterOffersText,
};

/// Relative timestamp label for a feed item (e.g. "12min ago", "14 May").
String newsItemTimeLabel(DateTime createdAt, {DateTime? now}) => newsTimeLabel(
  createdAt,
  now: now ?? DateTime.now(),
  labels: const NewsTimeLabels(
    justNow: newsTimeJustNowText,
    minutesAgo: newsTimeMinutesAgoText,
    hoursAgo: newsTimeHoursAgoText,
    daysAgo: newsTimeDaysAgoText,
  ),
);
