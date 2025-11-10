import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:talker/talker.dart';

part 'texts_store.g.dart';

// ignore: library_private_types_in_public_api
class TextsStore = _TextsStore with _$TextsStore;

abstract class _TextsStore extends ConfigCatStore with Store {
  _TextsStore(super.client, super.logger, super.ipInfoStore) : _logger = logger;

  final Talker _logger;

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
