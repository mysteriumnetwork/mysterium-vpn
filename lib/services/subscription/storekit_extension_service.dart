import 'dart:io';

import 'package:flutter/services.dart';

class StoreKitExtensionService {
  const StoreKitExtensionService();

  static const MethodChannel _channel = MethodChannel('storekit_extension');

  void _requireStoreKit() {
    if (!Platform.isIOS && !Platform.isMacOS) {
      throw UnsupportedError('This method is only available on iOS and macOS');
    }
  }

  Future<bool> isEligibleForIntroOffer(String productId) async {
    _requireStoreKit();
    final isEligible = await _channel.invokeMethod<bool>(
      'isEligibleForIntroOffer',
      {'productId': productId},
    );

    return isEligible ?? false;
  }
}
