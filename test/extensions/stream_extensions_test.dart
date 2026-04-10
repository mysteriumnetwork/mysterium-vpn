import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/core/extensions/stream_extensions.dart';

void main() {
  group('StreamExtensions', () {
    test('doOnListen triggers onListen callback', () async {
      var onListenCalled = false;

      final stream = Stream<int>.fromIterable([1, 2, 3]).doOnListen(() {
        onListenCalled = true;
      });

      await stream.toList();

      expect(onListenCalled, isTrue);
    });

    test('doOnListen propagates stream events correctly', () async {
      final stream = Stream<int>.fromIterable([1, 2, 3]).doOnListen(() {});

      final result = await stream.toList();

      expect(result, [1, 2, 3]);
    });

    test('doOnListen handles errors in onListen callback', () async {
      final stream = Stream<int>.fromIterable([1, 2, 3]).doOnListen(
        () {
          throw Exception('onListen error');
        },
        onError: (error, stack) {
          expect(error, isA<Exception>());
          expect((error as Exception).toString(), contains('onListen error'));
        },
      );

      await stream.toList();
    });

    test('doOnListen rethrows error if onError is not provided', () async {
      final stream = Stream<int>.fromIterable([1, 2, 3]).doOnListen(() {
        throw Exception('onListen error');
      });

      // Consume the stream to trigger the onListen callback
      expect(
        () async {
          await for (final _ in stream) {}
        },
        throwsA(
          isA<Exception>().having((e) => e.toString(), 'message', contains('onListen error')),
        ),
      );
    });
  });
}
