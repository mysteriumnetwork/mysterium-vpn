// Dart imports:
import 'dart:async' show Future;
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:retry/retry.dart';
// Project imports:

class SecureStorageService {
  factory SecureStorageService() => instance;

  SecureStorageService._internal();

  late FlutterSecureStorage _securedStorage;

  static final SecureStorageService instance = SecureStorageService._internal();

  Future<void> init() async {
    _securedStorage = const FlutterSecureStorage(
      iOptions: IOSOptions(accountName: Env.accountName),
      mOptions: MacOsOptions(accountName: Env.accountName, synchronizable: true),
      wOptions: WindowsOptions(useBackwardCompatibility: true),
      aOptions: AndroidOptions(resetOnError: true),
    );
  }

  Future<Map<String, dynamic>> readAll() async {
    try {
      final allValues = await _securedStorage.readAll();
      if (allValues.isEmpty) {
        return {};
      }
      return allValues;
    } catch (e) {
      return {};
    }
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
      await _remove(key: key);
    }
  }

  Future<String?> removeAndReturnValue(String key) async {
    if (await checkExistance(key)) {
      final value = await _securedStorage.read(key: key);
      await _remove(key: key);
      return value;
    }
    return null;
  }

  Future<void> _remove({required String key}) async {
    await retry(
      () => _securedStorage.delete(key: key),
      maxAttempts: 3,
      maxDelay: const Duration(seconds: 3),
    );
  }

  Future<bool> checkExistance(String key) async {
    try {
      return await _securedStorage.containsKey(key: key);
    } catch (e) {
      return false;
    }
  }

  Future<void> write(String key, String value) async {
    await retry(
      () => _write(key, value),
      maxAttempts: 3,
      maxDelay: const Duration(seconds: 3),
    );
  }

  /// in case it fails to write, we try to delete first and then write again. Based on:
  /// https://github.com/juliansteenbakker/flutter_secure_storage/issues/785#issuecomment-2603053482
  Future<void> _write(String key, String value) async {
    try {
      await _securedStorage.write(key: key, value: value);
    } catch (e) {
      await remove(key);
      await _securedStorage.write(key: key, value: value);
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

  Future<String?> getWireguardPublicKey() async => readOrNull(StorageKeys.wireguardPublicKey.name);

  Future<void> saveWireguardPublicKey({required String publicKey}) async =>
      write(StorageKeys.wireguardPublicKey.name, publicKey);

  Future<void> removeWireguardPublicKey() async => remove(StorageKeys.wireguardPublicKey.name);

  Future<String?> getWireguardPrivateKey() async =>
      readOrNull(StorageKeys.wireguardPrivateKey.name);

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
    await write(StorageKeys.subscriptionPaymentInfo.name, jsonEncode(value));
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

  Future<String?> getDeviceId() async {
    try {
      return await read(StorageKeys.deviceId.name);
    } catch (e) {
      return null;
    }
  }

  Future<void> saveDeviceId(String deviceId) async {
    await write(StorageKeys.deviceId.name, deviceId);
  }

  Future<void> removeDeviceId() async {
    await remove(StorageKeys.deviceId.name);
  }

  Future<void> clearAll() async {
    await _securedStorage.deleteAll();
  }
}
