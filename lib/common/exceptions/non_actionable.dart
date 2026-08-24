import 'dart:async';

import 'package:mysterium_vpn/common/exceptions/exceptions.dart';

/// Errors the app expects and already handles — an expired session, an aborted
/// sign-in, a backend error surfaced in the UI. Reporting them as crashes buries
/// the real ones, so both Crashlytics and Sentry drop them.
bool isNonActionable(Object? error) =>
    error is ApiException ||
    error is SignInAborted ||
    error is KeyDoesntExistsException ||
    error is TimeoutException ||
    error is TokenAlreadyUsedException ||
    error is OperationCancelledException ||
    error is SubscriptionRequiredException ||
    error is RefreshTokenNotFoundException;
