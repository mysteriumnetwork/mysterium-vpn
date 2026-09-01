import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/repositories/notifications/notifications_repository.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:talker/talker.dart';

import 'push_notifications_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<NotificationsRepository>(),
  MockSpec<AnalyticsStore>(),
  MockSpec<Talker>(),
  MockSpec<LocalDBService>(),
  MockSpec<RemoteConfigStore>(),
])
void main() {
  late PushNotificationsStore store;
  late MockNotificationsRepository repository;
  late MockAnalyticsStore analyticsStore;
  late MockTalker logger;
  late MockLocalDBService localDb;
  late MockRemoteConfigStore remoteConfigStore;

  late StreamController<bool> permissionController;
  late StreamController<PushNotification> openedController;
  late StreamController<PushNotification> receivedController;

  PushNotification notification({String id = 'notif_1', String? campaignId}) => PushNotification(
    id: id,
    title: 'Test',
    body: 'Body',
    launchUrl: null,
    rawPayload: const {},
    category: campaignId,
    additionalData: const {},
  );

  PushNotificationsStore build({bool supportsPush = true}) => PushNotificationsStore(
    logger,
    repository,
    analyticsStore,
    localDb,
    remoteConfigStore,
    supportsPush: () => supportsPush,
  );

  setUp(() {
    repository = MockNotificationsRepository();
    analyticsStore = MockAnalyticsStore();
    logger = MockTalker();
    localDb = MockLocalDBService();
    remoteConfigStore = MockRemoteConfigStore();

    permissionController = StreamController<bool>.broadcast();
    openedController = StreamController<PushNotification>.broadcast();
    receivedController = StreamController<PushNotification>.broadcast();

    when(repository.init()).thenAnswer((_) async {});
    when(repository.getPermissionStatusStream()).thenAnswer((_) => permissionController.stream);
    when(repository.getNotificationsStream()).thenAnswer((_) => openedController.stream);
    when(repository.getReceivedStream()).thenAnswer((_) => receivedController.stream);
    when(repository.getPermissionStatus()).thenReturn(false);
    when(repository.requestPermission()).thenAnswer((_) async => true);
    when(repository.canRequestPermission()).thenAnswer((_) async => true);
    when(repository.openAppNotificationsSettings()).thenAnswer((_) async {});

    when(localDb.getPushNotificationsPromptLastShownAt()).thenAnswer((_) async => null);
    when(localDb.setPushNotificationsPromptLastShownAt(any)).thenAnswer((_) async {});
    when(remoteConfigStore.pushNotifPermissionPromptCooldown).thenReturn(24);

    store = build();
  });

  tearDown(() async {
    await store.dispose();
    await permissionController.close();
    await openedController.close();
    await receivedController.close();
  });

  group('initialization', () {
    test('initializes the repository', () async {
      await Future<void>.delayed(Duration.zero);

      verify(repository.init()).called(1);
    });

    test('knows nothing about Notifier — reporting goes through the repository', () async {
      await Future<void>.delayed(Duration.zero);

      receivedController.add(notification(campaignId: 'campaign-1'));
      await Future<void>.delayed(Duration.zero);

      // The store never sees a device token; the repository fills it in.
      verifyNever(repository.currentToken);
    });
  });

  group('permission prompt', () {
    test('should show when not granted and the cooldown has passed', () async {
      expect(await store.shouldShowPushNotificationsPermissionPrompt(), isTrue);
    });

    test('should not show during the cooldown', () async {
      when(localDb.getPushNotificationsPromptLastShownAt()).thenAnswer((_) async => DateTime.now());

      expect(await store.shouldShowPushNotificationsPermissionPrompt(), isFalse);
    });

    test('should not show when permission is already granted', () async {
      when(repository.getPermissionStatus()).thenReturn(true);

      expect(await store.shouldShowPushNotificationsPermissionPrompt(), isFalse);
    });

    test('should not show when the prompt can no longer be requested', () async {
      when(repository.canRequestPermission()).thenAnswer((_) async => false);

      expect(await store.shouldShowPushNotificationsPermissionPrompt(), isFalse);
    });

    test('should not show on an unsupported platform', () async {
      await store.dispose();
      store = build(supportsPush: false);

      expect(await store.shouldShowPushNotificationsPermissionPrompt(), isFalse);
    });
  });

  group('requesting permission', () {
    test('setPushNotificationsShown requests permission when the user allowed it', () async {
      await store.setPushNotificationsShown(userAllowed: true);

      verify(repository.requestPermission()).called(1);
      verify(localDb.setPushNotificationsPromptLastShownAt(any)).called(1);
    });

    test('logs push_permission_requested before showing the system prompt', () async {
      await store.setPushNotificationsShown(userAllowed: true);

      verify(
        analyticsStore.logEvent(
          AnalyticsEvent.pushPermissionRequested,
          parameters: anyNamed('parameters'),
        ),
      ).called(1);
    });

    test('does not request permission when the user declined', () async {
      await store.setPushNotificationsShown(userAllowed: false);

      verifyNever(repository.requestPermission());
      verify(localDb.setPushNotificationsPromptLastShownAt(any)).called(1);
    });

    test('requests permission when it can still be requested', () async {
      await store.updatePushNotificationsPermissions();

      verify(repository.requestPermission()).called(1);
      verifyNever(repository.openAppNotificationsSettings());
    });

    test('opens system settings when the prompt can no longer be shown', () async {
      when(repository.canRequestPermission()).thenAnswer((_) async => false);

      await store.updatePushNotificationsPermissions();

      verify(repository.openAppNotificationsSettings()).called(1);
      verifyNever(repository.requestPermission());
    });

    test('does nothing on an unsupported platform', () async {
      await store.dispose();
      store = build(supportsPush: false);

      await store.updatePushNotificationsPermissions();

      verifyNever(repository.openAppNotificationsSettings());
      verifyNever(repository.requestPermission());
    });
  });

  group('permission status', () {
    test('falls back to the repository before the stream emits', () {
      when(repository.getPermissionStatus()).thenReturn(true);

      expect(store.pushNotificationsPermissionGranted, isTrue);
    });

    test('reflects the stream once it emits', () async {
      permissionController.add(true);
      await Future<void>.delayed(Duration.zero);

      expect(store.pushNotificationsPermissionGranted, isTrue);
    });

    test('reports a permission change to analytics', () async {
      permissionController.add(true);
      await Future<void>.delayed(Duration.zero);

      verify(
        analyticsStore.logPushNotificationsPermissionsChanged(permissionsGranted: true),
      ).called(1);
    });
  });

  group('received notifications', () {
    test('logs push_received', () async {
      receivedController.add(notification(campaignId: 'campaign-1'));
      await Future<void>.delayed(Duration.zero);

      verify(
        analyticsStore.logEvent(AnalyticsEvent.pushReceived, parameters: anyNamed('parameters')),
      ).called(1);
    });

    test('delegates a delivered event to the repository', () async {
      final sent = notification(campaignId: 'campaign-1');
      receivedController.add(sent);
      await Future<void>.delayed(Duration.zero);

      verify(repository.reportEvent(sent, NotifierEventType.delivered)).called(1);
    });

    test('a failing report does not escape the listener', () async {
      when(
        repository.reportEvent(any, any),
      ).thenThrow(const NotifierException(category: 'network'));

      receivedController.add(notification(campaignId: 'campaign-1'));

      await expectLater(Future<void>.delayed(Duration.zero), completes);
    });
  });

  group('opened notifications', () {
    test('exposes the notification as lastNotification', () async {
      openedController.add(notification(id: 'notif_9'));
      await Future<void>.delayed(Duration.zero);

      expect(store.lastNotification?.id, 'notif_9');
    });

    test('logs push_opened', () async {
      openedController.add(notification(campaignId: 'campaign-1'));
      await Future<void>.delayed(Duration.zero);

      verify(
        analyticsStore.logEvent(AnalyticsEvent.pushOpened, parameters: anyNamed('parameters')),
      ).called(1);
    });

    test('delegates an open event to the repository', () async {
      final sent = notification(campaignId: 'campaign-1');
      openedController.add(sent);
      await Future<void>.delayed(Duration.zero);

      verify(repository.reportEvent(sent, NotifierEventType.open)).called(1);
    });

    test('never puts the device token in analytics parameters', () async {
      openedController.add(notification(campaignId: 'campaign-1'));
      await Future<void>.delayed(Duration.zero);

      final captured = verify(
        analyticsStore.logEvent(any, parameters: captureAnyNamed('parameters')),
      ).captured;
      for (final params in captured) {
        expect(params.toString(), isNot(contains('fcm-token')));
      }
    });
  });

  test('supportsPushNotifications follows the injected platform predicate', () async {
    expect(store.supportsPushNotifications, isTrue);

    await store.dispose();
    store = build(supportsPush: false);
    expect(store.supportsPushNotifications, isFalse);
  });
}
