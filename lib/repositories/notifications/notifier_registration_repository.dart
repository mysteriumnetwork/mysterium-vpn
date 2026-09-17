import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/data/storage.dart';

/// Single source of truth for the device's Notifier registration state.
abstract class NotifierRegistrationRepository {
  /// The last registration we persisted, or null if the device has never
  /// registered on this install.
  NotifierRegistration? read();

  Future<void> save(NotifierRegistration value);

  Future<void> clear();
}

/// [NotifierRegistrationRepository] backed by [SharedPreferenceService].
class LocalNotifierRegistrationRepository implements NotifierRegistrationRepository {
  LocalNotifierRegistrationRepository(this._prefs);

  final SharedPreferenceService _prefs;

  @override
  NotifierRegistration? read() => _prefs.getNotifierRegistration();

  @override
  Future<void> save(NotifierRegistration value) => _prefs.setNotifierRegistration(value);

  @override
  Future<void> clear() => _prefs.clearNotifierRegistration();
}
