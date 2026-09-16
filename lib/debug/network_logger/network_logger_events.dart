import 'dart:async';

import 'package:dio/dio.dart' as dio;

/// List that contains network events and notifies dependents on updates.
class NetworkEventList {
  final _controller = StreamController<UpdateEvent>.broadcast();

  /// Logged network events
  final events = <NetworkEvent>[];

  /// A source of asynchronous network events.
  Stream<UpdateEvent> get stream => _controller.stream;

  /// Notify dependents that [event] is updated.
  void updated(NetworkEvent event) {
    _controller.add(UpdateEvent(event));
  }

  /// Add [event] to [events] list and notify dependents.
  void add(NetworkEvent event) {
    events.insert(0, event);
    _controller.add(UpdateEvent(event));
  }

  /// Clear [events] and notify dependents.
  void clear() {
    events.clear();
    _controller.add(const UpdateEvent.clear());
  }

  /// Dispose resources.
  void dispose() {
    _controller.close();
  }
}

/// Event notified by [NetworkEventList.stream].
class UpdateEvent {
  const UpdateEvent(this.event);

  const UpdateEvent.clear() : event = null;

  final NetworkEvent? event;
}

/// Network logger interface.
class DioNetworkLogger extends NetworkEventList {
  static final DioNetworkLogger instance = DioNetworkLogger();
  static void Function(dio.DioException error)? onError;
}

/// Network event log entry.
class NetworkEvent {
  NetworkEvent({required this.request}) : startTime = DateTime.now();

  Request request;
  DateTime startTime;

  Response? response;
  NetworkError? error;
  DateTime? endTime;

  void completed({Response? res, NetworkError? err}) {
    response = res;
    error = err;
    endTime = DateTime.now();
  }
}

/// Used for storing [Request] and [Response] headers.
class Headers {
  Headers(Iterable<MapEntry<String, String>> entries) : entries = entries.toList();

  final List<MapEntry<String, String>> entries;

  bool get isNotEmpty => entries.isNotEmpty;

  bool get isEmpty => entries.isEmpty;

  Iterable<T> map<T>(T Function(String key, String value) cb) =>
      entries.map((e) => cb(e.key, e.value));
}

/// Http request details.
class Request {
  Request({required this.uri, required this.method, required this.headers, this.data});

  final String uri;
  final String method;
  final Headers headers;
  final dynamic data;
}

/// Http response details.
class Response {
  Response({
    required this.headers,
    required this.statusCode,
    required this.statusMessage,
    this.data,
  });

  final Headers headers;
  final int statusCode;
  final String statusMessage;
  final dynamic data;
}

/// Network error details.
class NetworkError {
  NetworkError({required this.message});

  final String message;

  @override
  String toString() => message;
}
