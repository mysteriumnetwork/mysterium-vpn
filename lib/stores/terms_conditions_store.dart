import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/disposeable.dart';
import 'package:mysterium_vpn/models/terms_conditions.dart';
import 'package:mysterium_vpn/repositories/terms_conditions/terms_conditions_repository.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/auth/auth_session_store.dart';
import 'package:mysterium_vpn/stores/remote_config/remote_config_store.dart';
import 'package:mysterium_vpn/stores/theme_store.dart';

part 'terms_conditions_store.g.dart';

// ignore: library_private_types_in_public_api
class TermsConditionsStore = _TermsConditionsStore with _$TermsConditionsStore;

abstract class _TermsConditionsStore with Store, Disposeable {
  _TermsConditionsStore({
    required this._termsConditionsRepository,
    required this._themeStore,
    required this._authSessionStore,
    required this._remoteConfigStore,
    required this._analyticsStore,
  }) {
    _disposers = [
      reaction(
        (_) => (_authSessionStore.isAuthenticated, _remoteConfigStore.termsConditionsEnabled),
        (state) {
          final (isAuthenticated, enabled) = state;
          if (!isAuthenticated || !enabled) {
            _clear();
            return;
          }
          checkForUpdatedTermsConditions();
        },
        fireImmediately: true,
      ),
      // Terms HTML is themed server-side; re-fetch only while the gate is up.
      reaction((_) => _themeStore.isDarkMode, (_) {
        if (_requiresTermsConditionsApproval) {
          checkForUpdatedTermsConditions();
        }
      }),
    ];
  }

  late final List<ReactionDisposer> _disposers;
  final TermsConditionsRepository _termsConditionsRepository;
  final AuthSessionStore _authSessionStore;
  final ThemeStore _themeStore;
  final RemoteConfigStore _remoteConfigStore;
  final AnalyticsStore _analyticsStore;
  var _loggedTermsOpened = false;
  String? _loadedTheme;

  bool get _canCheck =>
      _authSessionStore.isAuthenticated && _remoteConfigStore.termsConditionsEnabled;

  String get _termsTheme => _themeStore.isDarkMode ? 'dark' : 'light';

  void _clear() {
    _latestTermsConditions = null;
    _loadedTheme = null;
    _requiresTermsConditionsApproval = false;
    _failure = null;
    _isLoading = false;
    _isAccepting = false;
    _loggedTermsOpened = false;
  }

  void _showPrompt() {
    if (_requiresTermsConditionsApproval) {
      return;
    }
    _requiresTermsConditionsApproval = true;
    _analyticsStore.logTermsAcceptancePromptShown().ignore();
  }

  void _openTerms() {
    if (_loggedTermsOpened) {
      return;
    }
    _loggedTermsOpened = true;
    _analyticsStore.logTermsAcceptanceTermsOpened().ignore();
  }

  @readonly
  TermsConditionsFailureType? _failure;

  /// A terms check is in flight (startup, resume or retry).
  @readonly
  bool _isLoading = false;

  /// The user's acceptance is being submitted.
  @readonly
  bool _isAccepting = false;

  @readonly
  TermsAndConditions? _latestTermsConditions;

  @readonly
  bool _requiresTermsConditionsApproval = false;

  @action
  Future<void> checkForUpdatedTermsConditions() async {
    if (!_canCheck || _isLoading || _isAccepting) {
      return;
    }

    _isLoading = true;
    final theme = _termsTheme;

    try {
      final TermsConsent consent;
      try {
        consent = await _termsConditionsRepository.getConsent();
      } catch (_) {
        // Consent unknown, so don't lock the app behind an error screen.
        return;
      }
      if (!_canCheck) {
        return;
      }

      if (!consent.requiresAcceptance) {
        _requiresTermsConditionsApproval = false;
        _latestTermsConditions = null;
        _loadedTheme = null;
        _failure = null;
        _loggedTermsOpened = false;
        return;
      }

      // Acceptance is required, so a load failure now keeps the gate up.
      _showPrompt();

      // Already have this version's text for this theme.
      if (_latestTermsConditions?.version == consent.latestVersion && _loadedTheme == theme) {
        _failure = null;
        return;
      }

      TermsAndConditions? latest;
      try {
        latest = await _termsConditionsRepository.getLatestVersion(theme);
      } catch (_) {
        latest = null;
      }
      if (!_canCheck) {
        return;
      }

      if (latest == null) {
        _failure = TermsConditionsFailureType.loading;
        _analyticsStore.logTermsAcceptanceError(TermsConditionsFailureType.loading.name).ignore();
      } else {
        _latestTermsConditions = latest;
        _loadedTheme = theme;
        _failure = null;
        _openTerms();
      }
    } finally {
      _isLoading = false;
    }

    // The theme flipped mid-flight, so the HTML we just fetched is stale.
    if (_canCheck && _requiresTermsConditionsApproval && _termsTheme != theme) {
      await checkForUpdatedTermsConditions();
    }
  }

  @action
  Future<void> acceptTermsConditions() async {
    if (_latestTermsConditions == null || _isAccepting || _isLoading) {
      return;
    }

    _isAccepting = true;
    _analyticsStore.logTermsAcceptanceClicked().ignore();

    try {
      await _termsConditionsRepository.acceptVersion(
        acceptedVersion: _latestTermsConditions!.version,
      );
      // Backend recorded it, so the funnel gets its terminal event regardless.
      _analyticsStore.logTermsAcceptanceSuccess().ignore();
      if (_canCheck) {
        _requiresTermsConditionsApproval = false;
        _failure = null;
        _loggedTermsOpened = false;
      }
    } catch (_) {
      _analyticsStore.logTermsAcceptanceError(TermsConditionsFailureType.saving.name).ignore();
      // A logout mid-accept already cleared the store; don't resurrect a failure.
      if (!_canCheck) {
        return;
      }
      _failure = TermsConditionsFailureType.saving;
    } finally {
      _isAccepting = false;
    }
  }

  @override
  FutureOr<void> dispose() {
    for (final disposer in _disposers) {
      disposer();
    }
  }
}
