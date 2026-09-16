import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/services/services.dart';

/// Single source of truth for the user's persisted VPN connection settings.
abstract class ConnectionSettingsRepository {
  Future<bool> malwareContentBlocker();

  Future<void> setMalwareContentBlocker({required bool value});

  Future<bool> notSafeContentBlocker();

  Future<void> setNotSafeContentBlocker({required bool value});

  Future<bool> refreshIpOnConnect();

  Future<void> setRefreshIpOnConnect({required bool value});

  Future<ProtocolType> protocolType();

  Future<void> setProtocolType(ProtocolType protocol);

  /// When the current tunnel was established, used to show session duration.
  DateTime? connectedAt();

  Future<void> setConnectedAt(DateTime value);

  Future<void> clearConnectedAt();
}

/// [ConnectionSettingsRepository] backed by [LocalDBService] (Hive).
class LocalConnectionSettingsRepository implements ConnectionSettingsRepository {
  LocalConnectionSettingsRepository({
    required LocalDBService db,
    required SharedPreferenceService prefs,
  }) : _db = db,
       _prefs = prefs;

  final LocalDBService _db;
  final SharedPreferenceService _prefs;

  @override
  Future<bool> malwareContentBlocker() => _db.getMalwareContentBlocker();

  @override
  Future<void> setMalwareContentBlocker({required bool value}) =>
      _db.setMalwareContentBlocker(value: value);

  @override
  Future<bool> notSafeContentBlocker() => _db.getNotSafeContentBlocker();

  @override
  Future<void> setNotSafeContentBlocker({required bool value}) =>
      _db.setNotSafeContentBlocker(value: value);

  @override
  Future<bool> refreshIpOnConnect() => _db.getRefreshIPConnection();

  @override
  Future<void> setRefreshIpOnConnect({required bool value}) =>
      _db.setRefreshIPConnection(refreshIPConnection: value);

  @override
  Future<ProtocolType> protocolType() => _db.getProtocolType();

  @override
  Future<void> setProtocolType(ProtocolType protocol) => _db.setProtocolType(protocol);

  @override
  DateTime? connectedAt() {
    final storedMs = _prefs.getInt(StorageKeys.connectedAt.name);
    return storedMs == null ? null : DateTime.fromMillisecondsSinceEpoch(storedMs);
  }

  @override
  Future<void> setConnectedAt(DateTime value) =>
      _prefs.setInt(StorageKeys.connectedAt.name, value.millisecondsSinceEpoch);

  @override
  Future<void> clearConnectedAt() => _prefs.remove(StorageKeys.connectedAt.name);
}
