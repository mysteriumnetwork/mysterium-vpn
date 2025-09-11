import 'dart:math';

String generateUuidV4() {
  int rand() =>
      (DateTime.now().microsecondsSinceEpoch + (1000000 * (Random().nextDouble()))).toInt();
  final bytes = List<int>.generate(16, (_) => rand() & 0xff);

  // Set version (4) and variant bits
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;

  String toHex(int n) => n.toRadixString(16).padLeft(2, '0');
  final hex = bytes.map(toHex).join();

  return '${hex.substring(0, 8)}-'
      '${hex.substring(8, 12)}-'
      '${hex.substring(12, 16)}-'
      '${hex.substring(16, 20)}-'
      '${hex.substring(20, 32)}';
}
