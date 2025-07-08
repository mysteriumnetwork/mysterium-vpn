import 'dart:async';

import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/services/data/local/secured_storage_service.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:wireguard_dart/key_pair.dart';
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
        final key = await _generateWireguradKey();
        unawaited(
          _saveWireguardKey(
            publicKey: key.publicKey,
            privateKey: key.privateKey,
          ),
        );
        return key;
      }
    } catch (_) {
      rethrow;
    }
  }

  Future<KeyPair> regenerateWireguardKeys() async {
    try {
      final key = await _generateWireguradKey();
      unawaited(
        _saveWireguardKey(
          publicKey: key.publicKey,
          privateKey: key.privateKey,
        ),
      );
      return key;
    } catch (_) {
      rethrow;
    }
  }

  Future<KeyPair?> _getKeyFromStorage() async {
    try {
      final [publicKey, privateKey] = await Future.wait<String?>(
        [
          secureStorageService.getWireguardPublicKey(),
          secureStorageService.getWireguardPrivateKey(),
        ],
        eagerError: true,
      );

      if ((publicKey?.isNotEmpty ?? false) && (privateKey?.isNotEmpty ?? false)) {
        return KeyPair(publicKey!, privateKey!);
      }
      analyticsStore.logEvent(
        AnalyticsEvent.wireguardKeyUnavailable,
        parameters: {
          'description': 'Wireguard keys not found in secure storage, generating new keys',
        },
      );
      return null;
    } catch (e, s) {
      Sentry.captureException(
        e,
        stackTrace: s,
        hint: Hint.withMap({
          'message': 'Failed to get Wireguard keys from storage',
        }),
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

  Future<void> _saveWireguardKey({
    required String publicKey,
    required String privateKey,
  }) async {
    try {
      await Future.wait([
        secureStorageService.saveWireguardPublicKey(publicKey: publicKey),
        secureStorageService.saveWireguardPrivateKey(privateKey: privateKey),
      ]);
      final key = await _getKeyFromStorage(); // Verify that keys are saved correctly
      if (publicKey != key?.publicKey && privateKey != key?.privateKey) {
        await Future.wait([
          secureStorageService.removeWireguardPrivateKey(),
          secureStorageService.removeWireguardPublicKey(),
        ]);
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
        hint: Hint.withMap({
          'message': 'Failed to get Wireguard keys',
        }),
      );
      rethrow;
    }
  }
}
