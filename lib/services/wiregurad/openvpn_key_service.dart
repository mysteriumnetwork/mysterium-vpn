import 'dart:async';

import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/services/data/local/secured_storage_service.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:wireguard_dart/key_pair.dart';
import 'package:wireguard_dart/wireguard_dart.dart';

class OpenVpnKeyService {
  const OpenVpnKeyService({
    required this.wireguardService,
    required this.secureStorageService,
    required this.analyticsStore,
  });

  final WireguardDart wireguardService;
  final SecureStorageService secureStorageService;
  final AnalyticsStore analyticsStore;

  Future<String> getOpenVpnKey() async {
    try {
      final openVpnKey = await _getKeyFromStorage();
      if (openVpnKey != null) {
        return openVpnKey;
      } else {
        analyticsStore.logEvent(
          AnalyticsEvent.openVpnKeyUnavailable,
          parameters: {
            'description': 'OpenVPN keys not found in secure storage, generating new keys',
            'method': 'getOpenVpnKey',
          },
        );
        final key = await _generateOpenVpnKey();
        await _saveOpenVpnKey(
          publicKey: key.publicKey,
        );
        return key.publicKey;
      }
    } catch (_) {
      rethrow;
    }
  }

  Future<KeyPair> regenerateOpenVpnKeys() async {
    try {
      final key = await _generateOpenVpnKey();
      await _saveOpenVpnKey(
        publicKey: key.publicKey,
      );
      return key;
    } catch (_) {
      rethrow;
    }
  }

  Future<String?> _getKeyFromStorage() async {
    try {
      return await secureStorageService.getOpenVpnPublicKey();
    } catch (e, s) {
      Sentry.captureException(
        e,
        stackTrace: s,
        hint: Hint.withMap({
          'message': 'Failed to get OpenVPN keys from storage',
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

  Future<void> _saveOpenVpnKey({
    required String publicKey,
  }) async {
    try {
      await secureStorageService.saveOpenVpnPublicKey(publicKey: publicKey);
      final key = await _getKeyFromStorage(); // Verify that keys are saved correctly
      if (key == null) {
        analyticsStore.logEvent(
          AnalyticsEvent.openVpnKeyUnavailable,
          parameters: {
            'description': 'OpenVPN keys not found after saving, check secure storage',
            'method': 'saveOpenVpnKey',
          },
        );
        return;
      }
      if (publicKey != key) {
        await secureStorageService.removeOpenVpnPublicKey();
        analyticsStore.logEvent(
          AnalyticsEvent.openVpnKeysDoNotMatch,
          parameters: {
            'description': 'Stored OpenVPN keys do not match the provided keys',
          },
        );
      }
    } catch (e, s) {
      Sentry.captureException(
        e,
        stackTrace: s,
        hint: Hint.withMap({
          'publicKey': publicKey,
          'message': 'Failed to save OpenVPN keys',
        }),
      );
    }
  }

  Future<KeyPair> _generateOpenVpnKey() async {
    try {
      return await wireguardService.generateKeyPair();
    } catch (e, s) {
      Sentry.captureException(
        e,
        stackTrace: s,
        hint: Hint.withMap({
          'message': 'Failed to get OpenVPN keys',
        }),
      );
      rethrow;
    }
  }
}
