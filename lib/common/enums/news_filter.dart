/// Category filter for the News Center feed.
///
/// Distinct from `NewsCategory`: [NewsFilter.all] bypasses category matching,
/// while the other three map 1:1 to a `NewsCategory`.
enum NewsFilter { all, incidents, news, offers }
