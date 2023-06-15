final _uuidRegex = RegExp(r'^[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}$');

extension StringExtensions on String {
  bool isUpperCase() => this == toUpperCase();

  bool isUUID() => _uuidRegex.hasMatch(toUpperCase());

  String capitalize() => '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
}
