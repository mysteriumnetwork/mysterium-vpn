// Dart imports:
import 'dart:async' show Future;

// Package imports:
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mysterium_vpn/common/enums/storage_keys.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/models/pkce.dart';
// Project imports:

class SecureStorageService {
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();
  late FlutterSecureStorage _securedStorage;

  static final SecureStorageService _instance = SecureStorageService._internal();

  Future<void> init() async {
    _securedStorage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(
        accountName: 'mysterium_vpn',
      ),
      mOptions: MacOsOptions(
        accountName: 'mysterium_vpn',
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
    _securedStorage.write(key: key, value: value);
  }

  Future<String> getAccessToken() async => read(StorageKeys.accessToken.value);
  Future<void> saveAccessToken({required String accessToken}) async =>
      write(StorageKeys.accessToken.value, accessToken);
  Future<void> removeAccessToken() async => remove(StorageKeys.accessToken.value);
  Future<String> getUsername() async => read(StorageKeys.username.value);
  Future<void> saveUsername({required String username}) async =>
      write(StorageKeys.username.value, username);
  Future<void> removeUsername() async => remove(StorageKeys.username.value);
  Future<String> getUserId() async => read(StorageKeys.userId.value);
  Future<void> saveUserId({required String userId}) async =>
      write(StorageKeys.userId.value, userId);
  Future<void> removeUserId() async => remove(StorageKeys.userId.value);
  Future<String?> getAppLink() async => readOrNull(StorageKeys.appLink.value);
  Future<void> saveAppLink({required String appLink}) async =>
      write(StorageKeys.appLink.value, appLink);
  Future<String> getWireguardPublicKey() async => read(StorageKeys.wireguardPublicKey.value);
  Future<void> saveWireguardPublicKey({required String publicKey}) async =>
      write(StorageKeys.accessToken.value, publicKey);
  Future<void> removeWireguardPublicKey() async => remove(StorageKeys.wireguardPrivateKey.value);
  Future<String> getWireguardPrivateKey() async => read(StorageKeys.wireguardPrivateKey.value);
  Future<void> saveWireguardPrivateKey({required String publicKey}) async =>
      write(StorageKeys.accessToken.value, publicKey);
  Future<void> removeWireguardPrivateKey() async => remove(StorageKeys.wireguardPrivateKey.value);
  Future<PkcePair?> getPkcePair() async {
    try {
      final codeChallenge = await read(StorageKeys.codeChallenge.value);
      final codeVerifier = await read(StorageKeys.codeVerifier.value);
      return PkcePair.fromStorage(codeChallenge: codeChallenge, codeVerifier: codeVerifier);
    } catch (e) {
      return null;
    }
  }

  Future<void> savePkcePair({
    required String codeChallenge,
    required String codeVerifier,
  }) async {
    write(StorageKeys.codeChallenge.value, codeChallenge);
    write(StorageKeys.codeVerifier.value, codeVerifier);
  }

  Future<void> removePkcePair() async {
    remove(StorageKeys.codeChallenge.value);
    remove(StorageKeys.codeVerifier.value);
  }
}
