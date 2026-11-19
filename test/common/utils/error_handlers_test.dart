import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:talker/talker.dart';

class _RecordingObserver extends TalkerObserver {
  final List<Object?> reported = [];

  @override
  void onError(TalkerError err) => reported.add(err.error);

  @override
  void onException(TalkerException err) => reported.add(err.exception);
}

void main() {
  late _RecordingObserver observer;
  late Talker logger;
  late List<Object?> chained;

  setUp(() {
    observer = _RecordingObserver();
    logger = Talker(settings: TalkerSettings(useConsoleLogs: false), observer: observer);
    chained = [];

    final flutterOnError = FlutterError.onError;
    final platformOnError = PlatformDispatcher.instance.onError;
    addTearDown(() {
      FlutterError.onError = flutterOnError;
      PlatformDispatcher.instance.onError = platformOnError;
    });
  });

  void install({ErrorReportThrottle? throttle}) => installErrorHandlers(
    logger: () => logger,
    flutterOnError: (details) => chained.add(details.exception),
    platformOnError: (error, stack) {
      chained.add(error);
      return true;
    },
    reportThrottle: throttle,
  );

  FlutterErrorDetails details(Object error) =>
      FlutterErrorDetails(exception: error, stack: StackTrace.empty);

  test('a repeated unhandled error reaches the chained handler once per window', () {
    install(throttle: ErrorReportThrottle());

    PlatformDispatcher.instance.onError!(Exception('boom'), StackTrace.empty);
    PlatformDispatcher.instance.onError!(Exception('boom'), StackTrace.empty);

    expect(chained, hasLength(1));
  });

  test('a repeated framework error reaches the chained handler once per window', () {
    install(throttle: ErrorReportThrottle());

    FlutterError.onError!(details(Exception('boom')));
    FlutterError.onError!(details(Exception('boom')));

    expect(chained, hasLength(1));
  });

  // The logger stays unthrottled: its observer keeps exact error counts and
  // applies its own throttle to Crashlytics.
  test('every unhandled error still reaches the logger', () {
    install(throttle: ErrorReportThrottle());

    PlatformDispatcher.instance.onError!(Exception('boom'), StackTrace.empty);
    PlatformDispatcher.instance.onError!(Exception('boom'), StackTrace.empty);

    expect(observer.reported, hasLength(2));
  });

  test('one window covers both handlers', () {
    install(throttle: ErrorReportThrottle());

    FlutterError.onError!(details(const FormatException('boom')));
    PlatformDispatcher.instance.onError!(const FormatException('boom'), StackTrace.empty);

    expect(chained, hasLength(1));
  });

  test('without a throttle every report is chained', () {
    install();

    PlatformDispatcher.instance.onError!(Exception('boom'), StackTrace.empty);
    PlatformDispatcher.instance.onError!(Exception('boom'), StackTrace.empty);

    expect(chained, hasLength(2));
  });

  test('the platform handler reports the error as handled', () {
    install(throttle: ErrorReportThrottle());

    expect(PlatformDispatcher.instance.onError!(Exception('boom'), StackTrace.empty), isTrue);
  });

  test('a suppressed error is still handled', () {
    install(throttle: ErrorReportThrottle());

    PlatformDispatcher.instance.onError!(Exception('boom'), StackTrace.empty);

    expect(PlatformDispatcher.instance.onError!(Exception('boom'), StackTrace.empty), isTrue);
  });
}
