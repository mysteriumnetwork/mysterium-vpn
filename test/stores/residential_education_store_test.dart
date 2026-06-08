import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/services/data/local/residential_education_storage.dart';
import 'package:mysterium_vpn/stores/residential_education_store.dart';

/// In-memory [ResidentialEducationStorage] for deterministic unit tests.
class _FakeStorage implements ResidentialEducationStorage {
  _FakeStorage({this.modalShown = false, this.reminderAt, this.connectCount = 0});

  bool modalShown;
  DateTime? reminderAt;
  int connectCount;

  @override
  Future<bool> getEducationModalShown() async => modalShown;
  @override
  Future<void> setEducationModalShown({required bool value}) async => modalShown = value;

  @override
  Future<DateTime?> getEducationReminderAt() async => reminderAt;
  @override
  Future<void> setEducationReminderAt(DateTime value) async => reminderAt = value;

  @override
  Future<int> getResidentialConnectCount() async => connectCount;
  @override
  Future<void> setResidentialConnectCount(int value) async => connectCount = value;

  @override
  Future<void> clearEducationState() async {
    modalShown = false;
    reminderAt = null;
    connectCount = 0;
  }
}

void main() {
  final now = DateTime(2026, 6, 8, 12);
  final store = ResidentialEducationStore(_FakeStorage());

  group('ResidentialEducationStore.decide (pure)', () {
    test('1st connect, modal not shown → none', () {
      expect(
        store.decide(modalShown: false, connectCount: 1, lastReminderAt: null, now: now),
        EducationAction.none,
      );
    });

    test('2nd connect, modal not shown → showModal', () {
      expect(
        store.decide(modalShown: false, connectCount: 2, lastReminderAt: null, now: now),
        EducationAction.showModal,
      );
    });

    test('modal shown, reminder seeded just now → none', () {
      expect(
        store.decide(
          modalShown: true,
          connectCount: 3,
          lastReminderAt: now.subtract(const Duration(seconds: 1)),
          now: now,
        ),
        EducationAction.none,
      );
    });

    test('modal shown, last reminder 29 days ago → none', () {
      expect(
        store.decide(
          modalShown: true,
          connectCount: 4,
          lastReminderAt: now.subtract(const Duration(days: 29)),
          now: now,
        ),
        EducationAction.none,
      );
    });

    test('modal shown, last reminder 31 days ago → showReminder', () {
      expect(
        store.decide(
          modalShown: true,
          connectCount: 4,
          lastReminderAt: now.subtract(const Duration(days: 31)),
          now: now,
        ),
        EducationAction.showReminder,
      );
    });

    test('modal shown, no reminder ever → showReminder', () {
      expect(
        store.decide(modalShown: true, connectCount: 4, lastReminderAt: null, now: now),
        EducationAction.showReminder,
      );
    });

    test('remote-config connectThreshold gates the modal', () {
      expect(
        store.decide(modalShown: false, connectCount: 2, lastReminderAt: null, now: now),
        EducationAction.showModal,
      );
      expect(
        store.decide(
          modalShown: false,
          connectCount: 2,
          lastReminderAt: null,
          now: now,
          connectThreshold: 3,
        ),
        EducationAction.none,
      );
    });

    test('remote-config reminderInterval gates the reminder', () {
      final tenDaysAgo = now.subtract(const Duration(days: 10));
      // 10 days since last reminder: not due under 30-day default...
      expect(
        store.decide(modalShown: true, connectCount: 4, lastReminderAt: tenDaysAgo, now: now),
        EducationAction.none,
      );
      // ...but due under a 7-day interval.
      expect(
        store.decide(
          modalShown: true,
          connectCount: 4,
          lastReminderAt: tenDaysAgo,
          now: now,
          reminderInterval: const Duration(days: 7),
        ),
        EducationAction.showReminder,
      );
    });
  });

  group('recordConnectAndDecide', () {
    test('increments the persisted count and decides on the new count', () async {
      final storage = _FakeStorage(connectCount: 1);
      final store = ResidentialEducationStore(storage);
      final action = await store.recordConnectAndDecide(now);
      expect(storage.connectCount, 2); // persisted
      expect(action, EducationAction.showModal); // count now 2 ≥ threshold
    });

    test('first qualifying connect records but shows nothing', () async {
      final storage = _FakeStorage();
      final store = ResidentialEducationStore(storage);
      final action = await store.recordConnectAndDecide(now);
      expect(storage.connectCount, 1);
      expect(action, EducationAction.none);
    });
  });

  group('mutations + persistence', () {
    test('markModalShown sets flag and seeds reminder clock', () async {
      final storage = _FakeStorage(connectCount: 2);
      await ResidentialEducationStore(storage).markModalShown(now);
      expect(storage.modalShown, isTrue);
      expect(storage.reminderAt, now);
      // Immediately after the modal, no reminder is due.
      expect(
        store.decide(
          modalShown: true,
          connectCount: 2,
          lastReminderAt: now,
          now: now.add(const Duration(seconds: 1)),
        ),
        EducationAction.none,
      );
    });

    test('markReminderShown advances the clock', () async {
      final storage = _FakeStorage(modalShown: true, connectCount: 4);
      await ResidentialEducationStore(storage).markReminderShown(now);
      expect(storage.reminderAt, now);
    });

    test('reset clears persisted state', () async {
      final storage = _FakeStorage(modalShown: true, connectCount: 5, reminderAt: now);
      await ResidentialEducationStore(storage).reset();
      expect(storage.modalShown, isFalse);
      expect(storage.connectCount, 0);
      expect(storage.reminderAt, isNull);
    });

    test('tryBeginUi guards single instance', () {
      final store = ResidentialEducationStore(_FakeStorage());
      expect(store.tryBeginUi(), isTrue);
      expect(store.tryBeginUi(), isFalse);
      store.endUi();
      expect(store.tryBeginUi(), isTrue);
    });
  });
}
