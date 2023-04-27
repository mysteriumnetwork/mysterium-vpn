import 'package:flutter/foundation.dart';
import 'package:mysterium_vpn/common/extensions/string.dart';

extension StorageKeysEx on Enum {
  String get value => describeEnum(this);

  String get toDashCase {
    final sb = StringBuffer();
    var first = true;
    for (final rune in value.runes) {
      final char = String.fromCharCode(rune);
      if (char.isUpperCase() && !first) {
        if (char != '-') {
          sb.write('-');
        }
        sb.write(char.toLowerCase());
      } else {
        first = false;
        sb.write(char.toLowerCase());
      }
    }
    return sb.toString();
  }

  String get toSnakeCase {
    final sb = StringBuffer();
    var first = true;
    for (final rune in value.runes) {
      final char = String.fromCharCode(rune);
      if (char.isUpperCase() && !first) {
        if (char != '_') {
          sb.write('_');
        }
        sb.write(char.toLowerCase());
      } else {
        first = false;
        sb.write(char.toLowerCase());
      }
    }
    return sb.toString();
  }

  String get toRoute => '/$toDashCase';
}
