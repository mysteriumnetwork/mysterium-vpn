import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/terms_conditions.dart';
import 'package:mysterium_vpn/repositories/terms_conditions/terms_conditions_repository.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/stores/terms_conditions_store.dart';

import '../support/test_prefs.dart';
import '../support/test_repositories.dart';
import 'terms_conditions_store_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthSessionStore>(), MockSpec<RemoteConfigStore>()])
class _TermsRepository implements TermsConditionsRepository {
  String? acceptedVersion;
  TermsAndConditions? latest = const TermsAndConditions(content: '<p>terms</p>', version: '2');
  Completer<String?>? acceptedVersionGate;
  Completer<TermsAndConditions?>? latestGate;
  int acceptedVersionCalls = 0;
  int latestCalls = 0;
  final List<String> themes = [];
  Exception? acceptError;
  Exception? acceptedVersionError;
  Exception? latestError;
  String? savedVersion;

  @override
  Future<String?> checkUserAcceptedVersion() {
    acceptedVersionCalls++;
    final gate = acceptedVersionGate;
    if (gate != null) {
      return gate.future;
    }
    final error = acceptedVersionError;
    if (error != null) {
      return Future<String?>.error(error);
    }
    return Future<String?>.value(acceptedVersion);
  }

  @override
  Future<TermsAndConditions?> getLatestVersion(String theme) {
    latestCalls++;
    themes.add(theme);
    final gate = latestGate;
    if (gate != null) {
      return gate.future;
    }
    final error = latestError;
    if (error != null) {
      return Future<TermsAndConditions?>.error(error);
    }
    return Future<TermsAndConditions?>.value(latest);
  }

  @override
  Future<void> acceptVersion({required String acceptedVersion}) async {
    final error = acceptError;
    if (error != null) {
      throw error;
    }
    savedVersion = acceptedVersion;
  }
}

void main() {
  late Observable<bool> isAuthenticated;
  late Observable<bool> termsEnabled;
  late MockAuthSessionStore authSession;
  late MockRemoteConfigStore remoteConfig;
  late _TermsRepository repository;
  late ThemeStore themeStore;
  late TermsConditionsStore store;

  TermsConditionsStore buildStore() {
    final built = TermsConditionsStore(
      termsConditionsRepository: repository,
      themeStore: themeStore,
      authSessionStore: authSession,
      remoteConfigStore: remoteConfig,
    );
    addTearDown(built.dispose);
    return built;
  }

  Future<void> signIn() async {
    runInAction(() => isAuthenticated.value = true);
    await pumpEventQueue();
  }

  setUp(() async {
    isAuthenticated = Observable(false);
    termsEnabled = Observable(true);
    authSession = MockAuthSessionStore();
    remoteConfig = MockRemoteConfigStore();
    when(authSession.isAuthenticated).thenAnswer((_) => isAuthenticated.value);
    when(remoteConfig.termsConditionsEnabled).thenAnswer((_) => termsEnabled.value);
    repository = _TermsRepository();
    themeStore = ThemeStore(settings: appSettings(await initTestPrefs()));
    store = buildStore();
  });

  test('does not check while signed out', () async {
    await pumpEventQueue();

    expect(repository.acceptedVersionCalls, 0);
    expect(repository.latestCalls, 0);
    expect(store.requiresTermsConditionsApproval, isFalse);
  });

  test('asks for approval when the signed-in user has not accepted the latest version', () async {
    repository.acceptedVersion = '1';

    await signIn();

    expect(store.requiresTermsConditionsApproval, isTrue);
    expect(store.failure, isNull);
    expect(store.isLoading, isFalse);
    expect(store.latestTermsConditions?.version, '2');
  });

  test('does not ask when the signed-in user already accepted the latest version', () async {
    repository.acceptedVersion = '2';

    await signIn();

    expect(store.requiresTermsConditionsApproval, isFalse);
    expect(store.isLoading, isFalse);
  });

  test('treats a missing accepted version as not accepted', () async {
    repository.acceptedVersion = null;

    await signIn();

    expect(store.requiresTermsConditionsApproval, isTrue);
  });

  test('treats an empty accepted version as not accepted', () async {
    repository.acceptedVersion = '';

    await signIn();

    expect(store.requiresTermsConditionsApproval, isTrue);
  });

  test('shows a load failure when there is no terms text', () async {
    repository
      ..acceptedVersion = null
      ..latest = null;

    await signIn();

    expect(store.requiresTermsConditionsApproval, isTrue);
    expect(store.failure, TermsConditionsFailureType.loading);
    expect(store.isLoading, isFalse);
  });

  test('stays quiet when a request throws', () async {
    repository.acceptedVersionError = Exception('offline');

    await signIn();

    expect(repository.latestCalls, 0);
    expect(store.requiresTermsConditionsApproval, isFalse);
    expect(store.failure, isNull);
    expect(store.isLoading, isFalse);
  });

  test('stays quiet when the latest request throws', () async {
    repository
      ..acceptedVersion = null
      ..latestError = Exception('offline');

    await signIn();

    expect(store.requiresTermsConditionsApproval, isFalse);
    expect(store.failure, isNull);
    expect(store.isLoading, isFalse);
  });

  test('shows a load failure when the user version exists but the latest text does not', () async {
    repository
      ..acceptedVersion = '1'
      ..latest = null;

    await signIn();

    expect(store.requiresTermsConditionsApproval, isTrue);
    expect(store.failure, TermsConditionsFailureType.loading);
    expect(store.isLoading, isFalse);
  });

  test('passes the dark theme when dark mode is on', () async {
    themeStore.themeMode = ThemeMode.dark;

    await signIn();

    expect(repository.themes, ['dark']);
  });

  test('passes the light theme when dark mode is off', () async {
    themeStore.themeMode = ThemeMode.light;

    await signIn();

    expect(repository.themes, ['light']);
  });

  test('accepting saves the latest version and hides the prompt', () async {
    repository.acceptedVersion = '1';
    await signIn();

    await store.acceptTermsConditions();

    expect(repository.savedVersion, '2');
    expect(store.requiresTermsConditionsApproval, isFalse);
    expect(store.failure, isNull);
    expect(store.isLoading, isFalse);
  });

  test('a failed accept keeps the prompt and records a save failure', () async {
    repository
      ..acceptedVersion = '1'
      ..acceptError = Exception('offline');
    await signIn();

    await store.acceptTermsConditions();

    expect(store.requiresTermsConditionsApproval, isTrue);
    expect(store.failure, TermsConditionsFailureType.saving);
    expect(store.isLoading, isFalse);
  });

  test('accept does nothing when there is no latest version', () async {
    await store.acceptTermsConditions();

    expect(repository.savedVersion, isNull);
    expect(store.requiresTermsConditionsApproval, isFalse);
  });

  test('logout hides the prompt', () async {
    repository.acceptedVersion = '1';
    await signIn();
    expect(store.requiresTermsConditionsApproval, isTrue);

    runInAction(() => isAuthenticated.value = false);

    expect(store.requiresTermsConditionsApproval, isFalse);
    expect(store.failure, isNull);
    expect(store.isLoading, isFalse);
    expect(store.latestTermsConditions, isNull);
  });

  test('a later user who has not accepted is asked after the previous user logs out', () async {
    repository.acceptedVersion = '2';
    await signIn();
    expect(store.requiresTermsConditionsApproval, isFalse);

    runInAction(() => isAuthenticated.value = false);
    repository
      ..acceptedVersion = null
      ..latest = const TermsAndConditions(content: '<p>new</p>', version: '3');

    await signIn();

    expect(repository.acceptedVersionCalls, 2);
    expect(store.requiresTermsConditionsApproval, isTrue);
    expect(store.latestTermsConditions?.version, '3');
  });

  test('does not check while the flag is off', () async {
    runInAction(() => termsEnabled.value = false);
    repository.acceptedVersion = '1';

    await signIn();

    expect(repository.acceptedVersionCalls, 0);
    expect(repository.latestCalls, 0);
    expect(store.requiresTermsConditionsApproval, isFalse);
  });

  test('hides the prompt when the flag is turned off', () async {
    repository.acceptedVersion = '1';
    await signIn();
    expect(store.requiresTermsConditionsApproval, isTrue);

    runInAction(() => termsEnabled.value = false);

    expect(store.requiresTermsConditionsApproval, isFalse);
    expect(store.failure, isNull);
    expect(store.isLoading, isFalse);
    expect(store.latestTermsConditions, isNull);
  });

  test('checks after the flag is turned on for a signed-in user', () async {
    runInAction(() => termsEnabled.value = false);
    repository.acceptedVersion = '1';
    await signIn();
    expect(repository.acceptedVersionCalls, 0);

    runInAction(() => termsEnabled.value = true);
    await pumpEventQueue();

    expect(store.requiresTermsConditionsApproval, isTrue);
    expect(store.latestTermsConditions?.version, '2');
  });

  test('a successful reload clears a previous load failure', () async {
    repository
      ..acceptedVersion = '1'
      ..latest = null;
    await signIn();
    expect(store.failure, TermsConditionsFailureType.loading);

    repository.latest = const TermsAndConditions(content: '<p>terms</p>', version: '2');
    await store.checkForUpdatedTermsConditions();

    expect(store.failure, isNull);
    expect(store.requiresTermsConditionsApproval, isTrue);
    expect(store.latestTermsConditions?.version, '2');
  });

  test('a matching version hides a prompt that was already showing', () async {
    repository.acceptedVersion = '1';
    await signIn();
    expect(store.requiresTermsConditionsApproval, isTrue);

    repository.latest = const TermsAndConditions(content: '<p>terms</p>', version: '1');
    await store.checkForUpdatedTermsConditions();

    expect(store.requiresTermsConditionsApproval, isFalse);
    expect(store.failure, isNull);
  });

  test(
    'a check that finishes after logout does not show the prompt or keep the old version',
    () async {
      repository
        ..acceptedVersionGate = Completer<String?>()
        ..latestGate = Completer<TermsAndConditions?>();

      runInAction(() => isAuthenticated.value = true);
      expect(store.isLoading, isTrue);

      runInAction(() => isAuthenticated.value = false);
      repository.acceptedVersionGate!.complete('1');
      repository.latestGate!.complete(
        const TermsAndConditions(content: '<p>terms</p>', version: '2'),
      );
      await pumpEventQueue();

      expect(store.requiresTermsConditionsApproval, isFalse);
      expect(store.isLoading, isFalse);
      expect(store.latestTermsConditions, isNull);
      expect(repository.latestCalls, 0);

      repository
        ..acceptedVersionGate = null
        ..latestGate = null
        ..acceptedVersion = null;
      await signIn();

      expect(repository.acceptedVersionCalls, 2);
      expect(store.requiresTermsConditionsApproval, isTrue);
    },
  );
}
