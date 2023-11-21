// Dart imports:
import 'dart:async' show Future;
import 'dart:io';

// Package imports:
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mysterium_vpn/common/enums/storage_keys.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/models/flavor_config.dart';
import 'package:mysterium_vpn/models/pkce.dart';
// Project imports:

class SecureStorageService {
  factory SecureStorageService() => instance;
  SecureStorageService._internal();
  late FlutterSecureStorage _securedStorage;

  static final SecureStorageService instance = SecureStorageService._internal();

  Future<void> init(FlavorConfig flavor) async {
    _securedStorage = FlutterSecureStorage(
      aOptions: const AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(
        accountName: flavor.values.accountName,
      ),
      mOptions: MacOsOptions(
        accountName: flavor.values.accountName,
        synchronizable: true,
      ),
    );
  }

  Future<String> read(String key) async {
    if (!await _securedStorage.containsKey(key: key)) {
      throw KeyDoesntExistsException();
    }
    final result = await _securedStorage.read(
      key: key,
      aOptions: const AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    );
    if (result == null) {
      throw KeyDoesntExistsException();
    } else {
      return result;
    }
  }

  Future<String?> readOrNull(String key) async {
    if (!await _securedStorage.containsKey(key: key)) {
      return null;
    }
    final result = await _securedStorage.read(
      key: key,
      aOptions: const AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    );
    if (result == null) {
      return null;
    } else {
      return result;
    }
  }

  Future<void> remove(String key) async {
    if (await _securedStorage.containsKey(key: key)) {
      await _securedStorage.delete(key: key);
    }
  }

  Future<bool> checkExistance(String key) async => _securedStorage.containsKey(key: key);

  Future<void> write(String key, String value) async {
    if (Platform.isMacOS) {
      await remove(key);
    }
    return _securedStorage.write(key: key, value: value);
  }

  Future<String> getAccessToken() async => read(StorageKeys.accessToken.name);
  Future<void> saveAccessToken({required String accessToken}) async =>
      write(StorageKeys.accessToken.name, accessToken);
  Future<void> removeAccessToken() async => remove(StorageKeys.accessToken.name);
  Future<String> getUsername() async => read(StorageKeys.username.name);
  Future<void> saveUsername({required String username}) async =>
      write(StorageKeys.username.name, username);
  Future<void> removeUsername() async => remove(StorageKeys.username.name);
  Future<String> getUserId() async => read(StorageKeys.userId.name);
  Future<void> saveUserId({required String userId}) async => write(StorageKeys.userId.name, userId);
  Future<void> removeUserId() async => remove(StorageKeys.userId.name);
  Future<String?> getAppLink() async => readOrNull(StorageKeys.appLink.name);
  Future<void> saveAppLink({required String appLink}) async =>
      write(StorageKeys.appLink.name, appLink);
  Future<String> getWireguardPublicKey() async => read(StorageKeys.wireguardPublicKey.name);
  Future<void> saveWireguardPublicKey({required String publicKey}) async =>
      write(StorageKeys.accessToken.name, publicKey);
  Future<void> removeWireguardPublicKey() async => remove(StorageKeys.wireguardPrivateKey.name);
  Future<String> getWireguardPrivateKey() async => read(StorageKeys.wireguardPrivateKey.name);
  Future<void> saveWireguardPrivateKey({required String publicKey}) async =>
      write(StorageKeys.accessToken.name, publicKey);
  Future<void> removeWireguardPrivateKey() async => remove(StorageKeys.wireguardPrivateKey.name);
  Future<PkcePair?> getPkcePair() async {
    try {
      final codeChallenge = await read(StorageKeys.codeChallenge.name);
      final codeVerifier = await read(StorageKeys.codeVerifier.name);
      return PkcePair.fromStorage(codeChallenge: codeChallenge, codeVerifier: codeVerifier);
    } catch (e) {
      return null;
    }
  }

  Future<void> savePkcePair({
    required String codeChallenge,
    required String codeVerifier,
  }) async {
    write(StorageKeys.codeChallenge.name, codeChallenge);
    write(StorageKeys.codeVerifier.name, codeVerifier);
  }

  Future<void> removePkcePair() async {
    remove(StorageKeys.codeChallenge.name);
    remove(StorageKeys.codeVerifier.name);
  }
}
