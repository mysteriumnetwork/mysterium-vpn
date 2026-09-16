import 'dart:async';

import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:wireguard_dart/wireguard_dart.dart';

class WireguardKeyRepository {
  const WireguardKeyRepository({
    required this.wireguardService,
    required this.secureStorageService,
    required this.analyticsLogger,
  });

  final WireguardDart wireguardService;
  final SecureStorageService secureStorageService;
  final AnalyticsEventLogger analyticsLogger;

  Future<KeyPair> getWireguardKey() async {
    try {
      final wireguardKey = await _getKeyFromStorage();
      if (wireguardKey != null) {
        return wireguardKey;
      } else {
        analyticsLogger(
          AnalyticsEvent.wireguardKeyUnavailable,
          parameters: {
            'description': 'Wireguard keys not found in secure storage, generating new keys',
            'method': 'getWireguardKey',
          },
        );
        final key = await _generateWireguardKey();
        await _saveWireguardKey(publicKey: key.publicKey, privateKey: key.privateKey);
        return key;
      }
    } catch (_) {
      rethrow;
    }
  }

  Future<KeyPair> regenerateWireguardKeys() async {
    try {
      final key = await _generateWireguardKey();
      await _saveWireguardKey(publicKey: key.publicKey, privateKey: key.privateKey);
      return key;
    } catch (_) {
      rethrow;
    }
  }

  Future<KeyPair?> _getKeyFromStorage() async {
    try {
      final publicKey = await secureStorageService.getWireguardPublicKey();
      final privateKey = await secureStorageService.getWireguardPrivateKey();
      if ((publicKey?.isNotEmpty ?? false) && (privateKey?.isNotEmpty ?? false)) {
        return KeyPair(publicKey!, privateKey!);
      }

      return null;
    } catch (e, s) {
      Sentry.captureException(
        e,
        stackTrace: s,
        hint: Hint.withMap({'message': 'Failed to get Wireguard keys from storage'}),
      );
      analyticsLogger(
        AnalyticsEvent.getWireguardKeyError,
        parameters: {
          'error': e.toString(),
          'stackTrace': s.toString(),
          'description': 'Failed to retrieve Wireguard keys from secure storage',
        },
      );
      return null;
    }
  }

  Future<void> _saveWireguardKey({required String publicKey, required String privateKey}) async {
    try {
      await secureStorageService.saveWireguardPublicKey(publicKey: publicKey);
      await secureStorageService.saveWireguardPrivateKey(privateKey: privateKey);
      final key = await _getKeyFromStorage(); // Verify that keys are saved correctly
      if (key == null) {
        analyticsLogger(
          AnalyticsEvent.wireguardKeyUnavailable,
          parameters: {
            'description': 'Wireguard keys not found after saving, check secure storage',
            'method': 'saveWireguardKey',
          },
        );
        return;
      }
      if (publicKey != key.publicKey || privateKey != key.privateKey) {
        await secureStorageService.removeWireguardPrivateKey();
        await secureStorageService.removeWireguardPublicKey();
        analyticsLogger(
          AnalyticsEvent.wireguardKeysDoNotMatch,
          parameters: {'description': 'Stored Wireguard keys do not match the provided keys'},
        );
      }
    } catch (e, s) {
      Sentry.captureException(
        e,
        stackTrace: s,
        hint: Hint.withMap({
          'publicKey': publicKey,
          'privateKey': privateKey,
          'message': 'Failed to save Wireguard keys',
        }),
      );
    }
  }

  Future<KeyPair> _generateWireguardKey() async {
    try {
      return await wireguardService.generateKeyPair();
    } catch (e, s) {
      Sentry.captureException(
        e,
        stackTrace: s,
        hint: Hint.withMap({'message': 'Failed to get Wireguard keys'}),
      );
      rethrow;
    }
  }
}
