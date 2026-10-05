import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/utils/disposeable.dart';
import 'package:mysterium_vpn/models/terms_conditions.dart';
import 'package:mysterium_vpn/repositories/terms_conditions/terms_conditions_repository.dart';
import 'package:mysterium_vpn/stores/auth/auth_session_store.dart';
import 'package:mysterium_vpn/stores/theme_store.dart';

part 'terms_conditions_store.g.dart';

// ignore: library_private_types_in_public_api
class TermsConditionsStore = _TermsConditionsStore with _$TermsConditionsStore;

abstract class _TermsConditionsStore with Store, Disposeable {
  _TermsConditionsStore({
    required this._termsConditionsRepository,
    required this._themeStore,
    required this._authSessionStore,
  }) {
    _disposer = reaction((_) => _authSessionStore.isAuthenticated, (isAuthenticated) {
      if (!isAuthenticated) {
        _userAcceptedVersion = null;
        _latestTermsConditions = null;
        _requiresTermsConditionsApproval = false;
        _failure = null;
        _isLoading = false;
        return;
      }
      checkForUpdatedTermsConditions();
    }, fireImmediately: true);
  }

  late final ReactionDisposer _disposer;
  final TermsConditionsRepository _termsConditionsRepository;
  final AuthSessionStore _authSessionStore;
  final ThemeStore _themeStore;

  String? _userAcceptedVersion;

  @observable
  TermsConditionsFailureType? _failure;
  @computed
  TermsConditionsFailureType? get failure => _failure;

  @observable
  bool _isLoading = false;
  @computed
  bool get isLoading => _isLoading;

  TermsAndConditions? _latestTermsConditions;
  TermsAndConditions? get latestTermsConditions => _latestTermsConditions;

  @observable
  bool _requiresTermsConditionsApproval = false;

  @computed
  bool get requiresTermsConditionsApproval => _requiresTermsConditionsApproval;

  @action
  Future<void> checkForUpdatedTermsConditions() async {
    if (!_authSessionStore.isAuthenticated) {
      return;
    }

    _isLoading = true;

    // gets the user accepted version
    if (_userAcceptedVersion == null) {
      final checkUserVersion = await _termsConditionsRepository.checkUserAcceptedVersion();
      // if user is not authenticated, stop the flow
      if (!_authSessionStore.isAuthenticated) {
        _isLoading = false;
        return;
      }
      if (!checkUserVersion.isNullOrEmpty) {
        _userAcceptedVersion = checkUserVersion;
      }
    }

    // gets the latest T&C version
    final theme = _themeStore.isDarkMode ? 'dark' : 'light';
    final latestTermsConditions = await _termsConditionsRepository.getLatestVersion(theme);
    // if user is not authenticated, stop the flow
    if (!_authSessionStore.isAuthenticated) {
      _isLoading = false;
      return;
    }
    if (latestTermsConditions != null) {
      _latestTermsConditions = latestTermsConditions;
    }

    // if T&C is null and user accepted version is null - no internet connectivity
    if (_latestTermsConditions == null && _userAcceptedVersion == null) {
      _isLoading = false;
      return;
    }
    // if T&C is null and user accepted version is not null - load T&C failure
    else if (_latestTermsConditions == null && _userAcceptedVersion != null) {
      _isLoading = false;
      _requiresTermsConditionsApproval = true;
      _failure = TermsConditionsFailureType.loading;
      return;
    }

    _failure = null;
    _requiresTermsConditionsApproval = _latestTermsConditions!.version != _userAcceptedVersion;
    _isLoading = false;
  }

  @action
  Future<void> acceptTermsConditions() async {
    if (_latestTermsConditions == null) {
      return;
    }

    _isLoading = true;

    try {
      await _termsConditionsRepository.acceptVersion(
        acceptedVersion: _latestTermsConditions!.version,
      );
      _userAcceptedVersion = _latestTermsConditions!.version;
      _requiresTermsConditionsApproval = false;
    } catch (e) {
      _failure = TermsConditionsFailureType.saving;
    } finally {
      _isLoading = false;
    }
  }

  @override
  FutureOr<void> dispose() {
    _disposer();
  }
}
