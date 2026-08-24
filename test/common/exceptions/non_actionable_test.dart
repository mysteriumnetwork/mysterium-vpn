import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';

void main() {
  final apiException = ApiException(
    RequestOptions(),
    'bad request',
    code: 400,
    identifier: 'identifier',
    endpoint: '/x',
    severity: ExceptionSeverity.low,
  );

  test('expected failures are dropped by both crash reporters', () {
    for (final error in <Object>[
      apiException,
      SignInAborted(),
      KeyDoesntExistsException(),
      TimeoutException('too slow'),
      TokenAlreadyUsedException(),
      OperationCancelledException(),
      const SubscriptionRequiredException(),
      RefreshTokenNotFoundException(),
    ]) {
      expect(isNonActionable(error), isTrue, reason: '$error must not be reported as a crash');
    }
  });

  test('genuine failures are still reported', () {
    expect(isNonActionable(Exception('boom')), isFalse);
    expect(isNonActionable(StateError('bad state')), isFalse);
    expect(isNonActionable(null), isFalse);
  });
}
