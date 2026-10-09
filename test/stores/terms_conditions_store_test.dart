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

import '../support/test_prefs.dart';
import '../support/test_repositories.dart';
import 'terms_conditions_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AuthSessionStore>(),
  MockSpec<RemoteConfigStore>(),
  MockSpec<AnalyticsStore>(),
])
class _TermsRepository implements TermsConditionsRepository {
  String? acceptedVersion;
  TermsAndConditions? latest = const TermsAndConditions(content: '<p>terms</p>', version: '2');

  /// Version the consent endpoint advertises. Defaults to [latest]'s version;
  /// set it explicitly to model "a version is due but its text won't load".
  String? advertisedLatestVersion;
  Completer<TermsConsent>? consentGate;
  Completer<TermsAndConditions?>? latestGate;
  int consentCalls = 0;
  int latestCalls = 0;
  final List<String> themes = [];
  Exception? acceptError;
  Completer<void>? acceptGate;
  Exception? consentError;
  Exception? latestError;
  String? savedVersion;

  @override
  Future<TermsConsent> getConsent() {
    consentCalls++;
    final gate = consentGate;
    if (gate != null) {
      return gate.future;
    }
    final error = consentError;
    if (error != null) {
      return Future<TermsConsent>.error(error);
    }
    return Future<TermsConsent>.value(
      TermsConsent(
        acceptedVersion: acceptedVersion,
        latestVersion: advertisedLatestVersion ?? latest?.version,
      ),
    );
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
    final gate = acceptGate;
    if (gate != null) {
      await gate.future;
    }
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
  late MockAnalyticsStore analytics;
  late _TermsRepository repository;
  late ThemeStore themeStore;
  late TermsConditionsStore store;

  TermsConditionsStore buildStore() {
    final built = TermsConditionsStore(
      termsConditionsRepository: repository,
      themeStore: themeStore,
      authSessionStore: authSession,
      remoteConfigStore: remoteConfig,
      analyticsStore: analytics,
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
    analytics = MockAnalyticsStore();
    when(authSession.isAuthenticated).thenAnswer((_) => isAuthenticated.value);
    when(remoteConfig.termsConditionsEnabled).thenAnswer((_) => termsEnabled.value);
    repository = _TermsRepository();
    themeStore = ThemeStore(settings: appSettings(await initTestPrefs()));
    store = buildStore();
  });

  test('does not check while signed out', () async {
    await pumpEventQueue();

    expect(repository.consentCalls, 0);
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
    verify(analytics.logTermsAcceptancePromptShown()).called(1);
    verify(analytics.logTermsAcceptanceTermsOpened()).called(1);
    verifyNever(analytics.logTermsAcceptanceError(any));
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

  test('shows a load failure when the due terms text is missing', () async {
    repository
      ..acceptedVersion = null
      ..advertisedLatestVersion = '2'
      ..latest = null;

    await signIn();

    expect(store.requiresTermsConditionsApproval, isTrue);
    expect(store.failure, TermsConditionsFailureType.loading);
    expect(store.isLoading, isFalse);
    verify(analytics.logTermsAcceptancePromptShown()).called(1);
    verify(analytics.logTermsAcceptanceError(TermsConditionsFailureType.loading.name)).called(1);
    verifyNever(analytics.logTermsAcceptanceTermsOpened());
  });

  test('leaves the app alone when consent cannot be loaded', () async {
    repository.consentError = Exception('offline');

    await signIn();

    expect(repository.latestCalls, 0);
    expect(store.requiresTermsConditionsApproval, isFalse);
    expect(store.failure, isNull);
    expect(store.isLoading, isFalse);
    verifyNever(analytics.logTermsAcceptancePromptShown());
    verifyNever(analytics.logTermsAcceptanceError(any));
  });

  test('keeps the gate up when the terms text request throws', () async {
    repository
      ..acceptedVersion = null
      ..latestError = Exception('offline');

    await signIn();

    expect(store.requiresTermsConditionsApproval, isTrue);
    expect(store.failure, TermsConditionsFailureType.loading);
    expect(store.isLoading, isFalse);
  });

  test('shows a load failure when the user version exists but the latest text does not', () async {
    repository
      ..acceptedVersion = '1'
      ..advertisedLatestVersion = '2'
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

  test('refetches themed terms when dark mode changes while the prompt is showing', () async {
    themeStore.themeMode = ThemeMode.light;
    repository.acceptedVersion = '1';
    await signIn();
    expect(repository.themes, ['light']);
    expect(store.requiresTermsConditionsApproval, isTrue);

    themeStore.themeMode = ThemeMode.dark;
    await pumpEventQueue();

    expect(repository.themes, ['light', 'dark']);
    expect(store.requiresTermsConditionsApproval, isTrue);
  });

  test('refetches when the theme changes during an in-flight check', () async {
    themeStore.themeMode = ThemeMode.light;
    repository
      ..acceptedVersion = '1'
      ..latestGate = Completer<TermsAndConditions?>();

    runInAction(() => isAuthenticated.value = true);
    await pumpEventQueue();
    expect(repository.themes, ['light']);
    expect(store.isLoading, isTrue);

    themeStore.themeMode = ThemeMode.dark;
    repository.latestGate!.complete(
      const TermsAndConditions(content: '<p>terms</p>', version: '2'),
    );
    await pumpEventQueue();

    expect(repository.themes, ['light', 'dark']);
    expect(store.requiresTermsConditionsApproval, isTrue);
    expect(store.isLoading, isFalse);
  });

  test('does not refetch on theme change once the terms are accepted', () async {
    themeStore.themeMode = ThemeMode.light;
    repository.acceptedVersion = '2';
    await signIn();
    expect(store.requiresTermsConditionsApproval, isFalse);
    expect(repository.latestCalls, 0);
    final consentCalls = repository.consentCalls;

    themeStore.themeMode = ThemeMode.dark;
    await pumpEventQueue();

    expect(repository.consentCalls, consentCalls);
    expect(repository.latestCalls, 0);
  });

  test('does not refetch on theme change while signed out', () async {
    themeStore.themeMode = ThemeMode.light;
    await pumpEventQueue();
    expect(repository.latestCalls, 0);

    themeStore.themeMode = ThemeMode.dark;
    await pumpEventQueue();

    expect(repository.latestCalls, 0);
  });

  test('accepting saves the latest version and hides the prompt', () async {
    repository.acceptedVersion = '1';
    await signIn();

    await store.acceptTermsConditions();

    expect(repository.savedVersion, '2');
    expect(store.requiresTermsConditionsApproval, isFalse);
    expect(store.failure, isNull);
    expect(store.isLoading, isFalse);
    expect(store.isAccepting, isFalse);
    verify(analytics.logTermsAcceptanceClicked()).called(1);
    verify(analytics.logTermsAcceptanceSuccess()).called(1);
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
    expect(store.isAccepting, isFalse);
    verify(analytics.logTermsAcceptanceClicked()).called(1);
    verify(analytics.logTermsAcceptanceError(TermsConditionsFailureType.saving.name)).called(1);
    verifyNever(analytics.logTermsAcceptanceSuccess());
  });

  test('a resume re-check never looks like an acceptance in flight', () async {
    repository.acceptedVersion = '1';
    await signIn();
    expect(store.requiresTermsConditionsApproval, isTrue);

    repository.latestGate = Completer<TermsAndConditions?>();
    final resumeCheck = store.checkForUpdatedTermsConditions();

    expect(store.isLoading, isTrue);
    expect(store.isAccepting, isFalse);

    repository.latestGate!.complete(
      const TermsAndConditions(content: '<p>terms</p>', version: '2'),
    );
    await resumeCheck;

    expect(store.isLoading, isFalse);
    expect(store.isAccepting, isFalse);
  });

  test('accepting reports isAccepting, not isLoading', () async {
    repository
      ..acceptedVersion = '1'
      ..acceptGate = Completer<void>();
    await signIn();

    final accept = store.acceptTermsConditions();
    expect(store.isAccepting, isTrue);
    expect(store.isLoading, isFalse);

    repository.acceptGate!.complete();
    await accept;

    expect(store.isAccepting, isFalse);
  });

  test('a check that starts while accepting is ignored', () async {
    repository
      ..acceptedVersion = '1'
      ..acceptGate = Completer<void>();
    await signIn();
    final consentCalls = repository.consentCalls;

    final accept = store.acceptTermsConditions();
    await store.checkForUpdatedTermsConditions();

    expect(repository.consentCalls, consentCalls);

    repository.acceptGate!.complete();
    await accept;
  });

  test('a save failure after logout does not gate the next sign-in', () async {
    repository
      ..acceptedVersion = '1'
      ..acceptGate = Completer<void>()
      ..acceptError = Exception('offline');
    await signIn();

    final accept = store.acceptTermsConditions();
    runInAction(() => isAuthenticated.value = false);
    repository.acceptGate!.complete();
    await accept;

    expect(store.failure, isNull);

    repository
      ..acceptGate = null
      ..acceptError = null;
    await signIn();

    expect(store.requiresTermsConditionsApproval, isTrue);
    expect(store.failure, isNull, reason: 'stale save failure resurfaced');
  });

  test('accept does nothing when there is no latest version', () async {
    await store.acceptTermsConditions();

    expect(repository.savedVersion, isNull);
    expect(store.requiresTermsConditionsApproval, isFalse);
    verifyNever(analytics.logTermsAcceptanceClicked());
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

    expect(repository.consentCalls, 2);
    expect(store.requiresTermsConditionsApproval, isTrue);
    expect(store.latestTermsConditions?.version, '3');
  });

  test('does not check while the flag is off', () async {
    runInAction(() => termsEnabled.value = false);
    repository.acceptedVersion = '1';

    await signIn();

    expect(repository.consentCalls, 0);
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
    expect(repository.consentCalls, 0);

    runInAction(() => termsEnabled.value = true);
    await pumpEventQueue();

    expect(store.requiresTermsConditionsApproval, isTrue);
    expect(store.latestTermsConditions?.version, '2');
  });

  test('a successful reload clears a previous load failure', () async {
    repository
      ..acceptedVersion = '1'
      ..advertisedLatestVersion = '2'
      ..latest = null;
    await signIn();
    expect(store.failure, TermsConditionsFailureType.loading);

    repository.latest = const TermsAndConditions(content: '<p>terms</p>', version: '2');
    await store.checkForUpdatedTermsConditions();

    expect(store.failure, isNull);
    expect(store.requiresTermsConditionsApproval, isTrue);
    expect(store.latestTermsConditions?.version, '2');
    verify(analytics.logTermsAcceptancePromptShown()).called(1);
    verify(analytics.logTermsAcceptanceTermsOpened()).called(1);
    verify(analytics.logTermsAcceptanceError(TermsConditionsFailureType.loading.name)).called(1);
  });

  test(
    'resume re-check hides the gate after the user accepted the latest version on another client',
    () async {
      repository.acceptedVersion = '1';
      await signIn();
      expect(store.requiresTermsConditionsApproval, isTrue);
      expect(store.latestTermsConditions?.version, '2');

      repository.acceptedVersion = '2';
      await store.checkForUpdatedTermsConditions();

      expect(repository.consentCalls, 2);
      expect(store.requiresTermsConditionsApproval, isFalse);
      expect(store.failure, isNull);
    },
  );

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
        ..consentGate = Completer<TermsConsent>()
        ..latestGate = Completer<TermsAndConditions?>();

      runInAction(() => isAuthenticated.value = true);
      expect(store.isLoading, isTrue);

      runInAction(() => isAuthenticated.value = false);
      repository.consentGate!.complete(
        const TermsConsent(acceptedVersion: '1', latestVersion: '2'),
      );
      repository.latestGate!.complete(
        const TermsAndConditions(content: '<p>terms</p>', version: '2'),
      );
      await pumpEventQueue();

      expect(store.requiresTermsConditionsApproval, isFalse);
      expect(store.isLoading, isFalse);
      expect(store.latestTermsConditions, isNull);
      expect(repository.latestCalls, 0);

      repository
        ..consentGate = null
        ..latestGate = null
        ..acceptedVersion = null;
      await signIn();

      expect(repository.consentCalls, 2);
      expect(store.requiresTermsConditionsApproval, isTrue);
    },
  );
}
