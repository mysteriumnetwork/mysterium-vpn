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
    _disposer = reaction(
      (_) => (
        _authSessionStore.isAuthenticated,
        _remoteConfigStore.termsConditionsEnabled,
        _themeStore.isDarkMode,
      ),
      (state) {
        final (isAuthenticated, enabled, _) = state;
        if (!isAuthenticated || !enabled) {
          _clear();
          return;
        }
        checkForUpdatedTermsConditions();
      },
      fireImmediately: true,
    );
  }

  late final ReactionDisposer _disposer;
  final TermsConditionsRepository _termsConditionsRepository;
  final AuthSessionStore _authSessionStore;
  final ThemeStore _themeStore;
  final RemoteConfigStore _remoteConfigStore;
  final AnalyticsStore _analyticsStore;
  var _loggedTermsOpened = false;

  bool get _canCheck =>
      _authSessionStore.isAuthenticated && _remoteConfigStore.termsConditionsEnabled;

  String get _termsTheme => _themeStore.isDarkMode ? 'dark' : 'light';

  void _clear() {
    _userAcceptedVersion = null;
    _latestTermsConditions = null;
    _requiresTermsConditionsApproval = false;
    _failure = null;
    _isLoading = false;
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
    _analyticsStore.logTermsAcceptancePromptTermsOpened().ignore();
  }

  String? _userAcceptedVersion;

  @observable
  TermsConditionsFailureType? _failure;
  @computed
  TermsConditionsFailureType? get failure => _failure;

  @observable
  bool _isLoading = false;
  @computed
  bool get isLoading => _isLoading;

  @observable
  TermsAndConditions? _latestTermsConditions;
  @computed
  TermsAndConditions? get latestTermsConditions => _latestTermsConditions;

  @observable
  bool _requiresTermsConditionsApproval = false;

  @computed
  bool get requiresTermsConditionsApproval => _requiresTermsConditionsApproval;

  @action
  Future<void> checkForUpdatedTermsConditions() async {
    if (!_canCheck || _isLoading) {
      return;
    }

    _isLoading = true;
    final theme = _termsTheme;

    try {
      final checkUserVersion = await _termsConditionsRepository.checkUserAcceptedVersion();
      if (!_canCheck) {
        return;
      }
      _userAcceptedVersion = checkUserVersion;

      final latestTermsConditions = await _termsConditionsRepository.getLatestVersion(theme);
      if (!_canCheck) {
        return;
      }
      if (latestTermsConditions != null) {
        _latestTermsConditions = latestTermsConditions;
      }

      // if no latest terms conditions, show loading error state
      if (_latestTermsConditions == null) {
        _showPrompt();
        _failure = TermsConditionsFailureType.loading;
        _analyticsStore
            .logTermsAcceptancePromptError(TermsConditionsFailureType.loading.name)
            .ignore();
      } else {
        _failure = null;

        final needsApproval = _latestTermsConditions!.version != _userAcceptedVersion;
        if (!needsApproval) {
          _requiresTermsConditionsApproval = false;
          _loggedTermsOpened = false;
        } else {
          _showPrompt();
          _openTerms();
        }
      }
    } catch (_) {
    } finally {
      _isLoading = false;
    }

    if (_canCheck && _termsTheme != theme) {
      await checkForUpdatedTermsConditions();
    }
  }

  @action
  Future<void> acceptTermsConditions() async {
    if (_latestTermsConditions == null || _isLoading) {
      return;
    }

    _isLoading = true;
    _analyticsStore.logTermsAcceptancePromptClicked().ignore();

    try {
      await _termsConditionsRepository.acceptVersion(
        acceptedVersion: _latestTermsConditions!.version,
      );
      if (_canCheck) {
        _userAcceptedVersion = _latestTermsConditions!.version;
        _requiresTermsConditionsApproval = false;
        _loggedTermsOpened = false;
        _analyticsStore.logTermsAcceptancePromptSuccess().ignore();
      }
    } catch (e) {
      _failure = TermsConditionsFailureType.saving;
      _analyticsStore
          .logTermsAcceptancePromptError(TermsConditionsFailureType.saving.name)
          .ignore();
    } finally {
      _isLoading = false;
    }
  }

  @override
  FutureOr<void> dispose() {
    _disposer();
  }
}
