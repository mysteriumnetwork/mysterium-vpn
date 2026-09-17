/// Per-user persistence for the residential-IP education feature.
///
/// Intentionally narrow so stores can depend on it (and tests can fake it)
/// without pulling in the whole LocalDBService. State is scoped to the
/// logged-in user (stored in `UserData`), so it is read asynchronously and
/// resets when a different account signs in on the device.
abstract interface class ResidentialEducationStorage {
  Future<bool> getEducationModalShown();
  Future<void> setEducationModalShown({required bool value});

  Future<DateTime?> getEducationReminderAt();
  Future<void> setEducationReminderAt(DateTime value);

  Future<int> getResidentialConnectCount();
  Future<void> setResidentialConnectCount(int value);

  /// Clears all education state (QA / "show again" reset).
  Future<void> clearEducationState();
}
