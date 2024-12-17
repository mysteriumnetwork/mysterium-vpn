import 'storekit_extensions_platform_interface.dart';

class StorekitExtensions {
  const StorekitExtensions();

  Future<bool> isEligibleForIntroOffer(String productId) {
    return StorekitExtensionsPlatform.instance.isEligibleForIntroOffer(productId);
  }
}
