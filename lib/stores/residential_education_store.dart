import 'package:mysterium_vpn/services/data/local/residential_education_storage.dart';

/// What the education trigger should present after a residential connection
/// has been confirmed connected for the dwell window.
enum EducationAction { none, showModal, showReminder }

/// Owns the residential-IP education policy plus a non-persisted
/// single-instance guard.
///
/// Persisted state is read through [ResidentialEducationStorage] (per-user, in
/// `UserData`) on each call rather than cached, so it always reflects the
/// currently signed-in account.
class ResidentialEducationStore {
  ResidentialEducationStore(this._storage);

  final ResidentialEducationStorage _storage;

  /// Defaults used when remote config does not override them.
  static const defaultReminderInterval = Duration(days: 30);
  static const defaultConnectThreshold = 2;

  /// Non-persisted, global single-instance guard so at most one education
  /// surface is presented at a time (e.g. under rapid reconnects).
  bool _uiInFlight = false;

  /// Pure decision over the supplied state — no I/O, unit-testable.
  ///
  /// [connectThreshold] and [reminderInterval] are supplied by remote config
  /// (with the static defaults as fallback) so the cadence and the connection
  /// count that triggers the modal can be tuned without an app release.
  EducationAction decide({
    required bool modalShown,
    required int connectCount,
    required DateTime? lastReminderAt,
    required DateTime now,
    int connectThreshold = defaultConnectThreshold,
    Duration reminderInterval = defaultReminderInterval,
  }) {
    if (!modalShown && connectCount >= connectThreshold) {
      return EducationAction.showModal;
    }
    if (modalShown &&
        (lastReminderAt == null || now.difference(lastReminderAt) >= reminderInterval)) {
      return EducationAction.showReminder;
    }
    return EducationAction.none;
  }

  /// Records one qualifying residential connection (increments + persists the
  /// per-user count) and returns what to present, reading the latest persisted
  /// state. Call once per connection that has stayed connected-on-residential
  /// for the dwell window.
  Future<EducationAction> recordConnectAndDecide(
    DateTime now, {
    int connectThreshold = defaultConnectThreshold,
    Duration reminderInterval = defaultReminderInterval,
  }) async {
    final count = await _storage.getResidentialConnectCount() + 1;
    await _storage.setResidentialConnectCount(count);
    final modalShown = await _storage.getEducationModalShown();
    final lastReminderAt = await _storage.getEducationReminderAt();
    return decide(
      modalShown: modalShown,
      connectCount: count,
      lastReminderAt: lastReminderAt,
      now: now,
      connectThreshold: connectThreshold,
      reminderInterval: reminderInterval,
    );
  }

  /// Marks the full modal as shown and seeds the reminder clock so a reminder
  /// cannot fire on the connection immediately following the modal.
  Future<void> markModalShown(DateTime now) async {
    await _storage.setEducationModalShown(value: true);
    await _storage.setEducationReminderAt(now);
  }

  /// Records that a reminder was shown now, resetting the reminder clock.
  Future<void> markReminderShown(DateTime now) => _storage.setEducationReminderAt(now);

  /// Claims the single-instance guard. Returns false if a surface is already
  /// in flight, in which case the caller must not present anything.
  bool tryBeginUi() {
    if (_uiInFlight) {
      return false;
    }
    _uiInFlight = true;
    return true;
  }

  void endUi() => _uiInFlight = false;

  /// Resets all education state for the current user. QA / debugging only.
  Future<void> reset() => _storage.clearEducationState();
}
