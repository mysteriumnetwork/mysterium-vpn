// Dart imports:
import 'dart:async' show Future;

// Package imports:
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mysterium_vpn/common/enums/storage_keys.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
// Project imports:

class SecureStorageService {
  static const FlutterSecureStorage _securedStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

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

  Future<void> write(String key, String value) async =>
      _securedStorage.write(key: key, value: value);

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
}
