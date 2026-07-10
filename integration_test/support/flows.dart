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
/// order, may show on a given run. `_clearFirstRunPrompts` dismisses whichever
/// appears until the home page is reachable.
const _firstRunPrompts = <(Symbol dialog, Symbol dismiss)>[
  (#onboardingDialog, #onboardingCloseButton),
  (#marketingConsentDialog, #marketingConsentDeclineButton),
  (#pushNotificationsDialog, #pushNotificationsDeclineButton),
  (#subscriptionOnboardingDialog, #subscriptionOnboardingCancelButton),
];

/// Fresh, non-subscriber accounts land on the surfaces above; they are
/// dismissed here so callers reliably land on `homePage`.
Future<void> login(PatrolIntegrationTester $, String email) async {
  await $(#loginPage).waitUntilVisible();
  await $(#loginEmailField).enterText(email);
  await $(#loginButton).tap();

  await _clearFirstRunPrompts($);

  await $(#homePage).waitUntilVisible();
  expect($(#unauthenticatedBanner), findsNothing);
}

/// Polls until the home page is hit-testable, dismissing any first-run prompt
/// found on the way.
///
/// The home page is the authoritative signal (not "no prompt this pass"):
/// `nextPromptToShow` is computed after async checks (e.g. the marketing-consent
/// API), so a prompt can appear *later* than a fixed dismissal window. Looping
/// on home visibility tolerates that late arrival.
Future<void> _clearFirstRunPrompts(PatrolIntegrationTester $) async {
  const maxIterations = 12;
  for (var i = 0; i < maxIterations; i++) {
    if (await isVisibleWithin($, #homePage, timeout: const Duration(seconds: 1))) {
      return;
    }
    for (final (dialog, dismiss) in _firstRunPrompts) {
      if (await isVisibleWithin($, dialog, timeout: const Duration(seconds: 1))) {
        await $(dismiss).tap();
        await $.pumpAndSettle();
        break;
      }
    }
  }
}

/// Opens the subscription page from the home subscription banner.
Future<void> openSubscriptionPage(PatrolIntegrationTester $) async {
  await $(#subscriptionBanner).waitUntilVisible();
  await $(#subscriptionBannerCTA).waitUntilVisible();
  await $(#subscriptionBannerCTA).tap();
  await $(#subscriptionPage).waitUntilVisible();
  expect($(#subscriptionPage), findsOneWidget);
}

/// Opens the Settings tab from the home bottom navigation.
Future<void> openSettings(PatrolIntegrationTester $) async {
  await $(#settingsTab).waitUntilVisible();
  await $(#settingsTab).tap();
}

/// Opens the Settings tab and then the category card identified by
/// [categoryKey] (e.g. `#settingsPreferencesCategory`).
Future<void> openSettingsCategory(PatrolIntegrationTester $, Symbol categoryKey) async {
  await openSettings($);
  await $(categoryKey).waitUntilVisible();
  await $(categoryKey).tap();
}

/// Logs out from the Settings > Account screen and confirms the dialog,
/// returning the app to the unauthenticated login screen.
///
/// The Settings tab opens a category menu first, so the Account category is
/// opened before the logout button (which sits at the bottom of the account
/// page and may need scrolling into view).
Future<void> logout(PatrolIntegrationTester $) async {
  await openSettings($);
  await $(#settingsAccountCategory).waitUntilVisible();
  await $(#settingsAccountCategory).tap();
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
