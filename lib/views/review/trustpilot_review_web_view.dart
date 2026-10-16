import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/ui/ui.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Path on the web app hosting Trustpilot's in-app review collector.
const _reviewPath = '/app-review';

/// The web app bounces unauthenticated visitors here.
const _loginPath = '/login';

/// Public review form, used when the verified collector cannot be reached. The
/// review lands unverified, which is far better than stranding the user on a
/// login page they cannot complete inside a modal.
///
/// Flavor-scoped like every other url here: on dev this is Trustpilot's shared
/// test business unit, so a QA pass cannot post a real review to the live
/// company profile.
Uri get _publicReviewUri => Uri.https(
  'www.trustpilot.com',
  '/evaluate/${Env.flavor.isDev ? 'verifiedreviewcollector.tp-testing.com' : 'www.mysteriumvpn.com'}',
);

/// `#rrggbb`, the form the page validates before putting it in a stylesheet.
String _hex(Color color) => '#${(color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';

/// Builds the review-collector URL on the web app.
///
/// [accessToken] is forwarded as a query parameter — the web app's middleware
/// exchanges it for a session cookie and strips it from the URL — mirroring
/// the rule in `NavigationExtensions.navigateToUrl`. Without it the page
/// cannot identify the user and the collector falls back to an unverified
/// review.
///
/// [isDarkMode] and [background] let the page match the modal it is embedded
/// in. The colour is passed rather than duplicated in the web app so it tracks
/// the design system automatically.
@visibleForTesting
Uri reviewWebViewUri({String? accessToken, bool isDarkMode = false, Color? background}) {
  final query = {
    'theme': isDarkMode ? 'dark' : 'light',
    if (background != null) 'bg': _hex(background),
    if (accessToken != null && accessToken.isNotEmpty) 'access_token': accessToken,
  };
  return Uri.https(Env.webAppUrl, _reviewPath, query);
}

/// Opens Trustpilot's review collector: a webview modal, or the default browser
/// where there is no webview (Windows/Linux) — [openInAppWebView] picks. Both
/// get the same authenticated url, so the review is verified either way.
///
/// The user closes the modal themselves. There is deliberately no auto-close on
/// a "finished" URL: picking a rating navigates to `/verified-review/...`, which
/// is the review *form*, so closing on it would dismiss the modal exactly when
/// the user is about to write their review.
Future<void> showTrustpilotReviewWebView(
  BuildContext context, {
  String? accessToken,
  @visibleForTesting bool Function() isSupported = supportsInAppWebView,
}) async {
  final theme = Theme.of(context);
  final supported = isSupported();
  final uri = reviewWebViewUri(
    accessToken: accessToken,
    isDarkMode: theme.brightness == Brightness.dark,
    // Nothing to blend into when this opens in the browser.
    background: supported ? theme.palette.bgPopover : null,
  );
  // The app refreshes its token only in response to a 401, so the one we hold
  // here may already have expired; the web app then bounces to a passwordless
  // login the user cannot complete inside a modal.
  var bouncedToLogin = false;

  await openInAppWebView(
    context,
    uri: uri,
    source: RedirectSource.reviewPrompt,
    isSupported: () => supported,
    builder: (_) => InAppWebViewScreen(
      uri: uri,
      title: S.current.reviewLeaveReviewBtn,
      shouldClose: (url) {
        // Host-scoped: the flow navigates on to trustpilot.com, so a `/login`
        // path there must not be mistaken for our own bounce.
        if (url.host == uri.host && url.path.startsWith(_loginPath)) {
          bouncedToLogin = true;
          return true;
        }
        return false;
      },
    ),
  );

  if (bouncedToLogin) {
    // Silent degradation otherwise: the user still gets to review, but the
    // review is unverified, and nothing else records that it happened.
    await analyticsStoreRef?.logEvent(
      AnalyticsEvent.reviewCollectorFallback,
      parameters: {'reason': 'login_bounce'},
    );
    await openUrlLink(_publicReviewUri, source: RedirectSource.reviewPrompt);
  }
}
