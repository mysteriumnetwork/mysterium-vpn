import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/utils/config_cat_client_wrapper.dart';
import 'package:talker/talker.dart';

part 'texts_store.g.dart';

// ignore: library_private_types_in_public_api
class TextsStore = _TextsStore with _$TextsStore;

abstract class _TextsStore with Store {
  _TextsStore(this._client, this._logger) {
    _init();
  }

  final ConfigCatService _client;
  final Talker _logger;

  @observable
  late ObservableFuture<Map<String, dynamic>> configFuture = ObservableFuture(_client.fetchTexts());

  @computed
  Map<String, dynamic> get config => configFuture.value ?? {};

  @action
  Future<void> _init() async {
    await configFuture;
    _client.watchTexts(() => configFuture = ObservableFuture(_client.fetchTexts()));
  }

  @computed
  Map<String, Map<String, String>> get texts {
    final texts = <String, Map<String, String>>{};
    for (final entry in config.entries) {
      final key = entry.key;
      final translations = _decode(entry.value, _logger);
      if (translations == null) {
        continue;
      }

      for (final translation in translations.entries) {
        final languageCode = translation.key;
        texts[languageCode] ??= {};
        texts[languageCode]![key] = translation.value;
      }
    }

    return texts;
  }
}

Map<String, String>? _decode(Object? value, Talker logger) {
  if (value is! String) {
    return null;
  }

  try {
    return {
      for (final entry in (jsonDecode(value) as Map).entries)
        entry.key.toString(): entry.value.toString(),
    };
  } catch (e, stack) {
    logger.log('Failed to decode translations', exception: e, stackTrace: stack);
    return null;
  }
}
