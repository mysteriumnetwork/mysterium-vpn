final _uuidRegex = RegExp(r'^[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}$');

extension StringExtensions on String {
  bool isUpperCase() => this == toUpperCase();

  bool isNumeric() => double.tryParse(this) != null;

  bool isUUID() => _uuidRegex.hasMatch(toUpperCase());

  String capitalize() {
    if (isEmpty) {
      return this;
    }
    if (length == 1) {
      return toUpperCase();
    }
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  String capitalizeWords() {
    if (isEmpty) {
      return this;
    }
    return split(RegExp(r'\s+')).map((word) => word.capitalize()).join(' ');
  }

  bool get hasMultipleWords {
    final words = split(RegExp(r'\s+'));
    return words.length > 1;
  }

  String truncate(int length) {
    if (length >= this.length) {
      return this;
    } else {
      return substring(0, length);
    }
  }

  String get toSnakeCase {
    final sb = StringBuffer();
    var first = true;
    var isFirstNumber = true;
    for (final rune in runes) {
      final char = String.fromCharCode(rune);
      if (char.isNumeric()) {
        if (isFirstNumber) {
          sb.write('_');
          isFirstNumber = false;
        }
        sb.write(char);
      } else {
        isFirstNumber = true;
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
    }
    return sb.toString();
  }
}

extension NullableStringExtensions on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  bool get isNotNullOrEmpty => !isNullOrEmpty;
}
