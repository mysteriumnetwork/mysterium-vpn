import 'dart:math';
import 'dart:typed_data';

class StunBindingRequest {
  StunBindingRequest._(this.transactionId);

  factory StunBindingRequest.create() {
    final random = Random.secure();
    final transactionId = List<int>.generate(12, (_) => random.nextInt(256));
    return StunBindingRequest._(transactionId);
  }
  final int messageType = 0x0001; // Binding Request
  final int magicCookie = 0x2112A442; // Magic Cookie
  final List<int> transactionId;

  Uint8List get toBytes {
    final buffer = ByteData(20)
      ..setUint16(0, messageType) // Message Type
      ..setUint16(2, 0) // Message Length (no attributes)
      ..setUint32(4, magicCookie); // Magic Cookie
    for (var i = 0; i < 12; i++) {
      buffer.setUint8(8 + i, transactionId[i]); // Transaction ID
    }
    return buffer.buffer.asUint8List();
  }
}
