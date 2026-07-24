/// Hardcoded English copy for the News Center.
///
/// The backend serves this feature's content (feed items) in English only and
/// provides no translations, so the whole page is English-only, is not routed
/// through `S`/localization, and is forced left-to-right (see the
/// `Directionality` in `NewsCenterPage`).
library;

const newsCenterTitleText = 'Notifications';
const newsCenterBackText = 'Back';

const newsFilterAllText = 'All';
const newsFilterIncidentsText = 'Incidents';
const newsFilterNewsText = 'News';
const newsFilterOffersText = 'Offers';

const newsCenterEmptyTitleText = 'No notifications yet';
const newsCenterEmptySubtitleText = "You'll see updates, incidents, news, and offers here.";

const newsCenterErrorTitleText = 'Something went wrong';
const newsCenterErrorSubtitleText = "We couldn't load your notifications. Please try again.";
const newsCenterRetryText = 'Retry';

const newsCenterUpdatedText = 'Notifications updated';
const newsCenterUpdateFailedText = "Couldn't update notifications";

/// Shown when a deep link points at an item that isn't in the feed (removed or
/// expired, or a bad id).
const newsCenterItemUnavailableText = 'This notification has expired or is no longer available.';

/// Close button label on the in-app webview toolbar (tooltip + a11y label).
const newsWebViewCloseText = 'Close';

const newsTimeJustNowText = 'Just now';
String newsTimeMinutesAgoText(int minutes) => '${minutes}min ago';
String newsTimeHoursAgoText(int hours) => '${hours}h ago';
String newsTimeDaysAgoText(int days) => '${days}d ago';
