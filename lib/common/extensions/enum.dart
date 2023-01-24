import 'package:flutter/foundation.dart';

import './string.dart';

extension StorageKeysEx on Enum {
  String get value => describeEnum(this);

  String get toDashCase {
    var sb = StringBuffer();
    var first = true;
    for (var rune in value.runes) {
      var char = String.fromCharCode(rune);
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

  String get toRoute {
    return "/$toDashCase";
  }
}
