import 'package:mysterium_vpn/core/extensions/string.dart';

extension StorageKeysEx on Enum {
  String get toDashCase {
    final sb = StringBuffer();
    var first = true;
    for (final rune in name.runes) {
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
}
