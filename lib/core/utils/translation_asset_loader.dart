import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:mysterium_vpn/features/remote_config/store/texts_store.dart';

class TranslationAssetLoader extends AssetLoader {
  const TranslationAssetLoader(this._textsStore);

  static const RootBundleAssetLoader _defaultLoader = RootBundleAssetLoader();

  final TextsStore _textsStore;

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async {
    final all = await _defaultLoader.load(path, locale);
    await _textsStore.configFuture;
    final overrides = _textsStore.texts[locale.languageCode];

    return {...?all, ...?overrides};
  }
}
