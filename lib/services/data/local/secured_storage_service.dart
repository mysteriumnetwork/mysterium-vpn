// Dart imports:
import 'dart:async' show Future;
import 'dart:convert';

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

  void init(FlavorConfig flavor) {
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
      wOptions: const WindowsOptions(
        useBackwardCompatibility: true,
      ),
    );
  }

  Future<String> read(String key) async {
    if (!await _securedStorage.containsKey(key: key)) {
      throw KeyDoesntExistsException();
    }
    final result = await _securedStorage.read(
      key: key,
    );
    if (result == null) {
      throw KeyDoesntExistsException();
    } else {
      return result;
    }
  }

  Future<String?> readOrNull(String key) async {
    if (!await checkExistance(key)) {
      return null;
    }
    final result = await _securedStorage.read(
      key: key,
    );
    if (result == null) {
      return null;
    } else {
      return result;
    }
  }

  Future<void> remove(String key) async {
    if (await checkExistance(key)) {
      await _securedStorage.delete(key: key);
    }
  }

  Future<String?> removeAndReturnValue(String key) async {
    if (await checkExistance(key)) {
      final value = await _securedStorage.read(key: key);
      await _securedStorage.delete(key: key);
      return value;
    }
    return null;
  }

  Future<bool> checkExistance(String key) async {
    try {
      return await _securedStorage.containsKey(key: key);
    } catch (e) {
      return false;
    }
  }

  Future<void> write(String key, String value) async {
    try {
      await _securedStorage.write(key: key, value: value);
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> getAccessToken() async => readOrNull(StorageKeys.accessToken.name);
  Future<void> saveAccessToken(String token) async => write(StorageKeys.accessToken.name, token);
  Future<void> removeAccessToken() async => remove(StorageKeys.accessToken.name);

  Future<String?> getRefreshToken() async => readOrNull(StorageKeys.refreshToken.name);
  Future<void> saveRefreshToken(String token) async => write(StorageKeys.refreshToken.name, token);
  Future<void> removeRefreshToken() async => remove(StorageKeys.refreshToken.name);

  Future<String?> getUserId() async => readOrNull(StorageKeys.userId.name);
  Future<void> saveUserId({required String userId}) async => write(StorageKeys.userId.name, userId);
  Future<void> removeUserId() async => remove(StorageKeys.userId.name);

  Future<String?> getUsername() async => readOrNull(StorageKeys.username.name);
  Future<void> saveUsername({required String username}) async =>
      write(StorageKeys.username.name, username);
  Future<void> removeUsername() async => remove(StorageKeys.username.name);

  Future<void> saveLastLoggedInUser({required String username}) async =>
      write(StorageKeys.lastLoggedInUser.name, username);
  Future<String?> getLastLoggedInUser() async => readOrNull(StorageKeys.lastLoggedInUser.name);
  Future<void> removeLastLoggedInUser() async => remove(StorageKeys.lastLoggedInUser.name);

  Future<String?> getAppLink() async => readOrNull(StorageKeys.appLink.name);
  Future<void> saveAppLink({required String appLink}) async =>
      write(StorageKeys.appLink.name, appLink);
  Future<String> getWireguardPublicKey() async => read(StorageKeys.wireguardPublicKey.name);
  Future<void> saveWireguardPublicKey({required String publicKey}) async =>
      write(StorageKeys.wireguardPublicKey.name, publicKey);
  Future<void> removeWireguardPublicKey() async => remove(StorageKeys.wireguardPublicKey.name);
  Future<String> getWireguardPrivateKey() async => read(StorageKeys.wireguardPrivateKey.name);
  Future<void> saveWireguardPrivateKey({required String privateKey}) async =>
      write(StorageKeys.wireguardPrivateKey.name, privateKey);
  Future<void> removeWireguardPrivateKey() async => remove(StorageKeys.wireguardPrivateKey.name);
  Future<PkcePair?> getPkcePair() async {
    try {
      final codeChallenge = await read(StorageKeys.codeChallenge.name);
      final codeVerifier = await read(StorageKeys.codeVerifier.name);
      return PkcePair.fromStorage(
        codeChallenge: codeChallenge,
        codeVerifier: codeVerifier,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> savePkcePair({
    required String codeChallenge,
    required String codeVerifier,
  }) async {
    await write(StorageKeys.codeChallenge.name, codeChallenge);
    await write(StorageKeys.codeVerifier.name, codeVerifier);
  }

  Future<void> removePkcePair() async {
    await remove(StorageKeys.codeChallenge.name);
    await remove(StorageKeys.codeVerifier.name);
  }

  Future<void> saveSubscriptionPaymentInfo({
    required String email,
    required DateTime? activeUntil,
  }) async {
    if (activeUntil == null) {
      return;
    }
    final value = {
      'email': email,
      'activeUntil': activeUntil.toIso8601String(),
    };
    write(StorageKeys.subscriptionPaymentInfo.name, jsonEncode(value));
  }

  Future<(String, DateTime)> getSubscriptionPaymentInfo() async {
    try {
      final subscriptionPaymentInfo = await read(StorageKeys.subscriptionPaymentInfo.name);
      final a = jsonDecode(subscriptionPaymentInfo) as Map<String, dynamic>;
      return (a['email']! as String, DateTime.parse(a['activeUntil']! as String));
    } catch (e) {
      throw KeyDoesntExistsException();
    }
  }

  Future<void> removeSubscriptionPaymentInfo() async {
    remove(StorageKeys.subscriptionPaymentInfo.name);
  }
}
