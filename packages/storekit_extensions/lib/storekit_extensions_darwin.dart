import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'storekit_extensions_platform_interface.dart';

/// An implementation of [StorekitExtensionsPlatform] that uses method channels.
class StorekitExtensionsDarwin extends StorekitExtensionsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('storekit_extensions');

  @override
  Future<bool> isEligibleForIntroOffer(String productId) async {
    final isEligible = await methodChannel.invokeMethod<bool>(
      'isEligibleForIntroOffer',
      {'productId': productId},
    );

    return isEligible ?? false;
  }
}
