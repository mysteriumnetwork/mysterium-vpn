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
}

/// [ConnectionSettingsRepository] backed by [LocalDBService] (Hive).
class LocalConnectionSettingsRepository implements ConnectionSettingsRepository {
  LocalConnectionSettingsRepository(this._db);

  final LocalDBService _db;

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
}
