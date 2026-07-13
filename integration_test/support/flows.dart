import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

/// Reusable end-to-end flows shared across integration tests.
///
/// Widget keys come from `lib/common/utils/keys.dart` (`K`); Patrol addresses
/// them with the `#symbol` finder (e.g. `#loginPage` matches `Key('loginPage')`).

/// Logs in with the given `email` starting from the launch login screen.
///
/// Relies on the automated quick-auth path: when `IS_AUTOMATED=true` on the
/// `dev` flavor, `TestFlagsInterceptor` appends `quick_auth=true` to the
/// `/magic-link` request, so login completes without an emailed link and the
/// app routes straight to the home page.
///
/// First-run surfaces that can overlay the home page after login. They appear
/// one at a time in a state-dependent order (and may chain), and their
/// "already shown" flags persist across app launches — so any subset, in any
/// order, may show on a given run. `waitPastPrompts` dismisses whichever
/// appears until the target screen is reachable.
const _firstRunPrompts = <(Symbol dialog, Symbol dismiss)>[
  (#onboardingDialog, #onboardingCloseButton),
  (#marketingConsentDialog, #marketingConsentDeclineButton),
  (#pushNotificationsDialog, #pushNotificationsDeclineButton),
  (#subscriptionOnboardingDialog, #subscriptionOnboardingCancelButton),
];

/// Fresh, non-subscriber accounts land on the surfaces above; they are
/// dismissed here so callers reliably land on `homePage`.
Future<void> login(PatrolIntegrationTester $, String email) async {
  // Fail fast with an actionable message: an empty LOGIN_EMAIL otherwise
  // surfaces downstream as a confusing "email is required" form error.
  if (email.isEmpty) {
    fail(
      'LOGIN_EMAIL is empty. Pass it via `--dart-define-from-file '
      'integration_test/.env` (locally) or the ENV_E2E secret (CI), together '
      'with IS_AUTOMATED=true so quick-auth login works.',
    );
  }

  await $(#loginPage).waitUntilVisible();
  await $(#loginEmailField).enterText(email);
  await $(#loginButton).tap();

  await waitPastPrompts($, #homePage);
  expect($(#unauthenticatedBanner), findsNothing);
}

/// [login] with the automated test account from the `LOGIN_EMAIL` dart-define.
/// The single source of that env key across the suite (fails fast if unset).
Future<void> loginWithEnv(PatrolIntegrationTester $) =>
    login($, const String.fromEnvironment('LOGIN_EMAIL'));

/// Polls until [key] is hit-testable, dismissing any first-run prompt found on
/// the way.
///
/// A first-run prompt can appear *after* login — its trigger (e.g. the
/// marketing-consent API) resolves asynchronously, so `nextPromptToShow` is
/// computed later than any fixed dismissal window — and overlay whatever screen
/// the test has navigated to, leaving [key] found-but-not-hit-testable rather
/// than a real failure. Polling on [key] while opportunistically dismissing
/// prompts absorbs that race wherever it surfaces (home, settings, banner CTA).
///
/// [maxAttempts] × ~1s bounds the wait; raise it for targets gated on a slow
/// backend fetch (e.g. the subscription CTA). A final assertive wait makes a
/// genuine timeout blame [key] itself.
Future<void> waitPastPrompts(PatrolIntegrationTester $, Symbol key, {int maxAttempts = 15}) async {
  for (var i = 0; i < maxAttempts; i++) {
    if (await isVisibleWithin($, key, timeout: const Duration(seconds: 1))) {
      return;
    }
    for (final (dialog, dismiss) in _firstRunPrompts) {
      // Synchronous check: the tree is settled here (the wait above pumped),
      // so a visible prompt is already mounted — no need to wait 1s per miss.
      if ($(dialog).visible) {
        await $(dismiss).tap();
        await $.pumpAndSettle();
        break;
      }
    }
  }
  await $(key).waitUntilVisible();
}

/// Opens the subscription page from the home subscription banner.
///
/// The banner only exposes its CTA once the subscription status resolves. That
/// fetch is retry-backed (dio: 15s timeout × up to 4 attempts with 1/3/5s
/// backoff ≈ 70s worst case), so on slow real devices / rate-limited test
/// backends the CTA can appear well after the default 10s (until then the banner
/// shows the "checking status" card, with no CTA). A high `maxAttempts` absorbs
/// that latency and any late prompt covering the banner; it returns as soon as
/// the CTA is tappable.
Future<void> openSubscriptionPage(PatrolIntegrationTester $) async {
  await waitPastPrompts($, #subscriptionBannerCTA, maxAttempts: 90);
  await $(#subscriptionBannerCTA).tap();
  await $(#subscriptionPage).waitUntilVisible();
  expect($(#subscriptionPage), findsOneWidget);
}

/// Opens the Settings tab from the home bottom navigation.
Future<void> openSettings(PatrolIntegrationTester $) async {
  await waitPastPrompts($, #settingsTab);
  await $(#settingsTab).tap();
}

/// Opens the Settings tab and then the category card identified by
/// [categoryKey] (e.g. `#settingsPreferencesCategory`).
Future<void> openSettingsCategory(PatrolIntegrationTester $, Symbol categoryKey) async {
  await openSettings($);
  await waitPastPrompts($, categoryKey);
  await $(categoryKey).tap();
}

/// Logs out from the Settings > Account screen and confirms the dialog,
/// returning the app to the unauthenticated login screen.
///
/// The Settings tab opens a category menu first, so the Account category is
/// opened before the logout button (which sits at the bottom of the account
/// page and may need scrolling into view).
Future<void> logout(PatrolIntegrationTester $) async {
  await openSettingsCategory($, #settingsAccountCategory);
  await $(#logoutButton).scrollTo();
  await $(#logoutButton).tap();
  await $(#logoutConfirmButton).waitUntilVisible();
  await $(#logoutConfirmButton).tap();
  await $(#loginPage).waitUntilVisible();
}

/// Whether the widget with [key] becomes visible within [timeout].
Future<bool> isVisibleWithin(
  PatrolIntegrationTester $,
  Symbol key, {
  Duration timeout = const Duration(seconds: 3),
}) async {
  try {
    await $(key).waitUntilVisible(timeout: timeout);
    return true;
  } on WaitUntilVisibleTimeoutException catch (_) {
    return false;
  }
}

/// Opens the settings picker card [cardKey], selects [optionKey] from its bottom
/// sheet [sheetKey], and waits for the sheet to close.
///
/// Retries the opening tap because some picker cards are briefly disabled while
/// their state loads (e.g. the content blocker fetches its status).
Future<void> selectFromPicker(
  PatrolIntegrationTester $,
  Symbol cardKey,
  Symbol sheetKey,
  Symbol optionKey,
) async {
  await $(cardKey).scrollTo();
  var opened = false;
  for (var attempt = 0; attempt < 5 && !opened; attempt++) {
    await $(cardKey).tap();
    opened = await isVisibleWithin($, sheetKey, timeout: const Duration(seconds: 2));
  }
  await $(sheetKey).waitUntilVisible();
  await $(optionKey).tap();
  await $.pumpAndSettle();
  expect($(sheetKey), findsNothing);
}
