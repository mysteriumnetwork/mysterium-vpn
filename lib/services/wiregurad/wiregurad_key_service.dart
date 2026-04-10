import 'dart:async';

import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:wireguard_dart/wireguard_dart.dart';

class WireguradKeyService {
  const WireguradKeyService({
    required this.wireguardService,
    required this.secureStorageService,
    required this.analyticsStore,
  });

  final WireguardDart wireguardService;
  final SecureStorageService secureStorageService;
  final AnalyticsStore analyticsStore;

  Future<KeyPair> getWireguradKey() async {
    try {
      final wireguradKey = await _getKeyFromStorage();
      if (wireguradKey != null) {
        return wireguradKey;
      } else {
        analyticsStore.logEvent(
          AnalyticsEvent.wireguardKeyUnavailable,
          parameters: {
            'description': 'Wireguard keys not found in secure storage, generating new keys',
            'method': 'getWireguradKey',
          },
        );
        final key = await _generateWireguradKey();
        await _saveWireguardKey(publicKey: key.publicKey, privateKey: key.privateKey);
        return key;
      }
    } catch (_) {
      rethrow;
    }
  }

  Future<KeyPair> regenerateWireguardKeys() async {
    try {
      final key = await _generateWireguradKey();
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
      analyticsStore.logEvent(
        AnalyticsEvent.getWireguradKeyError,
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
        analyticsStore.logEvent(
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
        analyticsStore.logEvent(
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

  Future<KeyPair> _generateWireguradKey() async {
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
