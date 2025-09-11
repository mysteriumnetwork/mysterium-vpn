import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';

void main() {
  group('StringExtensions.capitalize', () {
    test('capitalizes single lowercase word', () {
      expect('hello'.capitalize(), 'Hello');
    });

    test('capitalizes single uppercase word', () {
      expect('HELLO'.capitalize(), 'Hello');
    });

    test('returns empty string unchanged', () {
      expect(''.capitalize(), '');
    });

    test('capitalizes single character', () {
      expect('h'.capitalize(), 'H');
    });

    test('handles already capitalized word', () {
      expect('Hello'.capitalize(), 'Hello');
    });
  });

  group('StringExtensions.capitalizeWords', () {
    test('capitalizes each word in a sentence', () {
      expect('hello world'.capitalizeWords(), 'Hello World');
    });

    test('handles multiple spaces between words', () {
      expect('hello   world'.capitalizeWords(), 'Hello World');
    });

    test('handles tabs and newlines', () {
      expect('hello\tworld\nfoo'.capitalizeWords(), 'Hello World Foo');
    });

    test('handles single word', () {
      expect('hello'.capitalizeWords(), 'Hello');
    });

    test('returns empty string unchanged', () {
      expect(''.capitalizeWords(), '');
    });

    test('handles already capitalized words', () {
      expect('Hello World'.capitalizeWords(), 'Hello World');
    });
  });
}
