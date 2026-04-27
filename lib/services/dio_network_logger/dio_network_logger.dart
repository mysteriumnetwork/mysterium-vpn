// Copied from https://pub.dev/packages/network_logger

import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/core/device/device_id_store.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/features/notifications/store/push_notifications_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/ab_testing_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/config_cat_user_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart' hide Palette, Radius;

/// Overlay for [NetworkLoggerButton].
class NetworkLoggerOverlay extends StatefulWidget {
  const NetworkLoggerOverlay._({
    required this.right,
    required this.bottom,
    required this.draggable,
  });

  static const double _defaultPadding = 30;

  final double bottom;
  final double right;
  final bool draggable;

  /// Attach overlay to specified [context]. The FAB will be draggable unless
  /// [draggable] set to `false`. Initial distance from the button to the screen
  /// edge can be configured using [bottom] and [right] parameters.
  static OverlayEntry attachTo(
    BuildContext context, {
    bool rootOverlay = true,
    double bottom = _defaultPadding,
    double right = _defaultPadding,
    bool draggable = true,
  }) {
    // create overlay entry
    final entry = OverlayEntry(
      builder: (context) =>
          NetworkLoggerOverlay._(bottom: bottom, right: right, draggable: draggable),
    );
    // insert on next frame
    Future.delayed(Duration.zero, () {
      // ignore: use_build_context_synchronously
      final overlay = Overlay.maybeOf(context, rootOverlay: rootOverlay);

      if (overlay == null) {
        throw FlutterError(
          'FlutterNetworkLogger:  No Overlay widget found. '
          'The most common way to add an Overlay to an application is to '
          'include a MaterialApp or Navigator above widget that calls '
          'NetworkLoggerOverlay.attachTo()',
        );
      }

      overlay.insert(entry);
    });
    // return
    return entry;
  }

  @override
  State<NetworkLoggerOverlay> createState() => _NetworkLoggerOverlayState();
}

class _NetworkLoggerOverlayState extends State<NetworkLoggerOverlay> {
  static const Size buttonSize = Size(57, 57);

  late double bottom = widget.bottom;
  late double right = widget.right;

  late MediaQueryData screen;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screen = MediaQuery.of(context);
  }

  Offset? lastPosition;

  void onPanUpdate(LongPressMoveUpdateDetails details) {
    final delta = lastPosition! - details.localPosition;

    bottom += delta.dy;
    right += delta.dx;

    lastPosition = details.localPosition;

    /// Checks if the button went of screen
    if (bottom < 0) {
      bottom = 0;
    }

    if (right < 0) {
      right = 0;
    }

    if (bottom + buttonSize.height > screen.size.height) {
      bottom = screen.size.height - buttonSize.height;
    }

    if (right + buttonSize.width > screen.size.width) {
      right = screen.size.width - buttonSize.width;
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.draggable) {
      return Positioned(
        right: right,
        bottom: bottom,
        child: GestureDetector(
          onLongPressMoveUpdate: onPanUpdate,
          onLongPressUp: () {
            if (mounted) {
              setState(() {
                lastPosition = null;
              });
            }
          },
          onLongPressDown: (details) {
            if (mounted) {
              setState(() {
                lastPosition = details.localPosition;
              });
            }
          },
          child: Material(
            elevation: lastPosition == null ? 0 : 30,
            borderRadius: BorderRadius.all(Radius.circular(buttonSize.width)),
            child: NetworkLoggerButton(),
          ),
        ),
      );
    }

    return Positioned(
      right: widget.right + screen.padding.right,
      bottom: widget.bottom + screen.padding.bottom,
      child: NetworkLoggerButton(),
    );
  }
}

/// [FloatingActionButton] that opens [NetworkLoggerScreen] when pressed.
class NetworkLoggerButton extends StatefulWidget {
  NetworkLoggerButton({
    super.key,
    this.globalNavKey,
    this.color = Colors.deepPurple,
    this.blinkPeriod = const Duration(seconds: 1, microseconds: 500),
    this.showOnlyOnDebug = false,
    NetworkEventList? eventList,
  }) : eventList = eventList ?? DioNetworkLogger.instance;

  /// Source event list (default: [DioNetworkLogger.instance])
  final NetworkEventList eventList;

  /// Blink animation period
  final Duration blinkPeriod;

  // Button background color
  final Color color;

  /// If set to true this button will be hidden on non-debug builds.
  final bool showOnlyOnDebug;

  final GlobalKey<NavigatorState>? globalNavKey;

  @override
  State<NetworkLoggerButton> createState() => _NetworkLoggerButtonState();
}

class _NetworkLoggerButtonState extends State<NetworkLoggerButton> {
  bool _visible = true;

  void _press() {
    if (mounted) {
      setState(() {
        _visible = false;
      });
    }

    // Use Future.delayed to ensure navigation happens after current frame completes
    Future.delayed(Duration.zero, () async {
      try {
        await NetworkLoggerScreen.open(
          widget.globalNavKey?.currentState?.context ?? context,
          eventList: widget.eventList,
        );
      } finally {
        if (mounted) {
          setState(() {
            _visible = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible) {
      return const SizedBox();
    }

    return StreamBuilder<UpdateEvent>(
      stream: widget.eventList.stream,
      builder: (context, snapshot) {
        final isLoading = widget.eventList.events.any(
          (networkEvent) => networkEvent.response == null && networkEvent.error == null,
        );

        return _DebugOnly(
          enabled: widget.showOnlyOnDebug,
          child: FloatingActionButton(
            onPressed: _press,
            backgroundColor: widget.color,
            child: isLoading
                ? const LoadingIndicator(color: Colors.white)
                : const Icon(Icons.cloud, color: Colors.white),
          ),
        );
      },
    );
  }
}

/// Screen that displays log entries list.
class NetworkLoggerScreen extends StatefulWidget {
  NetworkLoggerScreen({super.key, NetworkEventList? eventList})
    : eventList = eventList ?? DioNetworkLogger.instance;

  /// Event list to listen for event changes.
  final NetworkEventList eventList;

  /// Opens screen.
  static Future<void> open(BuildContext context, {NetworkEventList? eventList}) => Navigator.push(
    context,
    MaterialPageRoute(
      settings: const RouteSettings(name: 'network_logger'),
      builder: (context) => NetworkLoggerScreen(eventList: eventList),
    ),
  );

  @override
  State<NetworkLoggerScreen> createState() => _NetworkLoggerScreenState();
}

class _NetworkLoggerScreenState extends State<NetworkLoggerScreen> {
  final TextEditingController searchController = TextEditingController();

  String _query = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final textStyles = theme.textStyles;
    final events = _query.isEmpty
        ? widget.eventList.events
        : widget.eventList.events
              .where((it) => it.request.uri.toLowerCase().contains(_query))
              .toList();
    return Scaffold(
      backgroundColor: palette.bgPrimary,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: Navigator.of(context).pop,
          color: palette.textPrimary,
        ),
        forceMaterialTransparency: true,
        title: Text('Network Logs', style: textStyles.textLg.semibold),
        actions: <Widget>[
          _ActionButton(
            onTap: () => _ConfigPage.show(context: context),
            child: Icon(Icons.settings, color: palette.textWarningPrimary),
          ),
          _ActionButton(
            onTap: () => _DeviceInfo.show(context: context),
            child: Icon(Icons.info_outline, color: palette.textWarningPrimary),
          ),
          _ActionButton(
            onTap: () => _SecuredStorageValues.show(context: context),
            child: Icon(Icons.key, color: palette.textWarningPrimary),
          ),
          _ActionButton(
            onTap: widget.eventList.clear,
            child: Icon(Icons.delete, color: palette.textWarningPrimary),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: widget.eventList.stream,
        builder: (context, snapshot) => Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: (text) {
                if (mounted) {
                  setState(() {
                    _query = text;
                  });
                }
              },
              autocorrect: false,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: palette.textTertiary),
                suffix: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: searchController,
                  builder: (context, value, child) => value.text.isNotEmpty
                      ? Text('${events.length} results', style: textStyles.textSm.regular)
                      : const SizedBox(),
                ),
                hintText: 'enter keyword to search',
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: events.length,
                itemBuilder: enumerateItems<NetworkEvent>(
                  events,
                  (context, item) => ListTile(
                    key: ValueKey(item.request),
                    title: Row(
                      children: [
                        Text(item.request.method, style: textStyles.textSm.bold),
                        const SizedBox(width: 4),
                        _AutoUpdate(
                          duration: const Duration(seconds: 1),
                          builder: (context) => Text(
                            '${_timeDifference(item.startTime)} ago',
                            style: textStyles.textXs.medium.copyWith(fontSize: 11),
                          ),
                        ),
                        if (item.endTime != null) ...[
                          const SizedBox(width: 4),
                          Text(
                            '''Took ${item.endTime!.difference(item.startTime).inMilliseconds} ms''',
                            style: textStyles.textXs.regular.copyWith(fontSize: 9),
                          ),
                        ],
                        const SizedBox(width: 8),
                        Text(
                          "sc: ${item.response?.statusCode ?? ''}",
                          style: textStyles.textXs.bold.copyWith(
                            fontSize: 9,
                            color: palette.textBrandPrimary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Tooltip(
                          message: item.error?.message ?? '',
                          child: Icon(
                            item.error == null
                                ? (item.response == null ? Icons.hourglass_empty : Icons.done)
                                : Icons.error,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      item.request.uri,
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                      style: textStyles.textSm.regular,
                    ),
                    onTap: () => NetworkLoggerEventScreen.open(context, item, widget.eventList),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _timeDifference(DateTime time, [DateTime? origin]) {
  origin ??= DateTime.now();
  final delta = origin.difference(time);
  if (delta.inSeconds < 90) {
    return '${delta.inSeconds} s';
  } else if (delta.inMinutes < 90) {
    return '${delta.inMinutes} m';
  } else {
    return '${delta.inHours} h';
  }
}

const _jsonEncoder = JsonEncoder.withIndent('  ');

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;
  static const EdgeInsets padding = EdgeInsets.all(4);
  static const HitTestBehavior hitTestBehavior = HitTestBehavior.opaque;

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: hitTestBehavior,
    onTap: onTap,
    child: Padding(padding: padding, child: child),
  );
}

/// Screen that displays log entry details.
class NetworkLoggerEventScreen extends StatelessWidget {
  const NetworkLoggerEventScreen({required this.event, super.key});

  static Route<void> route({required NetworkEvent event, required NetworkEventList eventList}) =>
      MaterialPageRoute(
        settings: const RouteSettings(name: 'network_logger'),
        builder: (context) => StreamBuilder(
          stream: eventList.stream.where((item) => item.event == event),
          builder: (context, snapshot) => NetworkLoggerEventScreen(event: event),
        ),
      );

  /// Opens screen.
  static void open(BuildContext context, NetworkEvent event, NetworkEventList eventList) {
    // Use Future.delayed to ensure navigation happens after current frame completes
    Future.delayed(Duration.zero, () {
      if (!context.mounted) {
        return;
      }
      Navigator.of(context).push(route(event: event, eventList: eventList));
    });
  }

  /// Which event to display details for.
  final NetworkEvent event;

  // ignore: type_annotate_public_apis
  Widget buildBodyViewer(BuildContext context, body) {
    final theme = Theme.of(context);
    String text;
    if (body == null) {
      text = '';
    } else if (body is String) {
      text = body;
    } else if (body is List || body is Map) {
      text = _jsonEncoder.convert(body);
    } else {
      text = body.toString();
    }
    return GestureDetector(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: text));
        showSnackbar('Copied to clipboard', type: SnackbarType.info);
      },
      child: Text(
        text.replaceAll('","', '"\n"'),
        maxLines: 100,
        overflow: TextOverflow.ellipsis,
        style: theme.textStyles.textSm.regular,
      ),
    );
  }

  Widget buildHeadersViewer(BuildContext context, List<MapEntry<String, String>> headers) {
    final palette = Theme.of(context).palette;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: headers
                .map((e) => SelectableText(e.key, style: TextStyle(color: palette.textPrimary)))
                .toList(),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: headers
                .map((e) => SelectableText(e.value, style: TextStyle(color: palette.textPrimary)))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget buildRequestView(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final textStyles = theme.textStyles;
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 15),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
          child: Text('URL', style: textStyles.textMd.regular),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(event.request.method, style: textStyles.textMd.regular),
              const SizedBox(width: 15),
              Expanded(
                child: SelectableText(
                  event.request.uri,
                  style: TextStyle(color: palette.textPrimary),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
          child: Text('TIMESTAMP', style: textStyles.textMd.regular),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(event.startTime.toString(), style: textStyles.textMd.regular),
        ),
        if (event.request.headers.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
            child: Text('HEADERS', style: textStyles.textMd.regular),
          ),
          buildHeadersViewer(context, event.request.headers.entries),
        ],
        if (event.error != null) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
            child: Text('ERROR', style: textStyles.textMd.regular),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              event.error.toString(),
              maxLines: 100,
              overflow: TextOverflow.ellipsis,
              style: textStyles.textMd.regular.copyWith(color: palette.textErrorPrimary),
            ),
          ),
        ],
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
          child: Text('BODY', style: textStyles.textMd.regular),
        ),
        buildBodyViewer(context, event.request.data),
      ],
    );
  }

  Widget buildResponseView(BuildContext context) {
    final textStyles = Theme.of(context).textStyles;
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 15),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
          child: Text('RESULT', style: textStyles.textMd.regular),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(event.response!.statusCode.toString(), style: textStyles.textMd.regular),
              const SizedBox(width: 15),
              Expanded(
                child: Text(event.response!.statusMessage, style: textStyles.textMd.regular),
              ),
            ],
          ),
        ),
        if (event.response?.headers.isNotEmpty ?? false) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
            child: Text('HEADERS', style: textStyles.textMd.regular),
          ),
          buildHeadersViewer(context, event.response?.headers.entries ?? []),
        ],
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
          child: Text('BODY', style: textStyles.textMd.regular),
        ),
        buildBodyViewer(context, event.response?.data),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final showResponse = event.response != null;

    Widget? bottom;
    if (showResponse) {
      bottom = TabBar(
        labelColor: palette.textBrandPrimary,
        unselectedLabelColor: palette.textSecondary,
        tabs: const [
          Tab(text: 'Request'),
          Tab(text: 'Response'),
        ],
      );
    }

    return DefaultTabController(
      length: showResponse ? 2 : 1,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: Navigator.of(context).pop,
            color: palette.textPrimary,
          ),
          title: Text('Log Entry', style: theme.textStyles.textLg.semibold),
          bottom: bottom as PreferredSizeWidget?,
        ),
        body: Builder(
          builder: (context) => TabBarView(
            children: <Widget>[
              buildRequestView(context),
              if (showResponse) buildResponseView(context),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget builder that re-builds widget repeatedly with [duration] interval.
class _AutoUpdate extends StatefulWidget {
  const _AutoUpdate({required this.duration, required this.builder});

  /// Re-build interval.
  final Duration duration;

  /// Widget builder to build widget.
  final WidgetBuilder builder;

  @override
  _AutoUpdateState createState() => _AutoUpdateState();
}

class _AutoUpdateState extends State<_AutoUpdate> {
  Timer? _timer;

  void _setTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.duration, (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void didUpdateWidget(_AutoUpdate old) {
    if (old.duration != widget.duration) {
      _setTimer();
    }
    super.didUpdateWidget(old);
  }

  @override
  void initState() {
    _setTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context);
}

class _DebugOnly extends StatelessWidget {
  const _DebugOnly({required this.enabled, required this.child});

  final bool enabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (enabled) {
      if (!kDebugMode) {
        return const SizedBox();
      }
    }
    return child;
  }
}

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

  Headers.fromMap(Map<String, String> map)
    : entries = map.entries as List<MapEntry<String, String>>;

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

typedef IndexBuilder = Widget Function(BuildContext context, int index);
typedef ItemBuilder<T> = Widget Function(BuildContext context, T item);

IndexBuilder enumerateItems<T>(List<T> items, ItemBuilder<T> builder) =>
    (BuildContext context, int index) => builder(context, items[index]);

extension DioNetworkLoggerX on dio.Dio {
  void addNetworkLogger() {
    interceptors.add(DioNetworkLoggerInterceptor());
  }
}

class DioNetworkLoggerInterceptor extends dio.Interceptor {
  DioNetworkLoggerInterceptor({NetworkEventList? eventList})
    : eventList = eventList ?? DioNetworkLogger.instance;
  final NetworkEventList eventList;
  final _requests = <dio.RequestOptions, NetworkEvent>{};

  @override
  Future<void> onRequest(dio.RequestOptions options, dio.RequestInterceptorHandler handler) async {
    super.onRequest(options, handler);
    eventList.add(_requests[options] = NetworkEvent(request: options.toRequest()));
  }

  @override
  void onResponse(dio.Response<dynamic> response, dio.ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
    final event = _requests.remove(response.requestOptions);
    if (event != null) {
      event.completed(res: response.toResponse());

      eventList.updated(event);
    }
  }

  @override
  void onError(dio.DioException err, dio.ErrorInterceptorHandler handler) {
    super.onError(err, handler);
    DioNetworkLogger.onError?.call(err);
    final event = _requests.remove(err.requestOptions);
    if (event != null) {
      eventList.updated(
        event..completed(err: err.toNetworkError(), res: err.response?.toResponse()),
      );
    }
  }
}

extension _RequestOptionsX on dio.RequestOptions {
  Request toRequest() => Request(
    uri: uri.toString(),
    data: data,
    method: method,
    headers: Headers(headers.entries.map((kv) => MapEntry(kv.key, '${kv.value}'))),
  );
}

extension _ResponseX on dio.Response<dynamic> {
  Response toResponse() => Response(
    data: data,
    statusCode: statusCode ?? -1,
    statusMessage: statusMessage ?? 'unkown',
    headers: Headers(
      headers.map.entries.fold<List<MapEntry<String, String>>>(
        [],
        (p, e) => p..addAll(e.value.map((v) => MapEntry(e.key, v))),
      ),
    ),
  );
}

extension _DioErrorX on dio.DioException {
  NetworkError toNetworkError() => NetworkError(message: toString());
}

class _ConfigPage extends StatelessWidget {
  const _ConfigPage._();

  static void show({required BuildContext context}) {
    Future.delayed(Duration.zero, () {
      if (!context.mounted) {
        return;
      }
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => const _ConfigPage._(),
          settings: const RouteSettings(name: 'configPage'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final textStyles = theme.textStyles;
    final remoteConfigs = getIt<RemoteConfigStore>();
    final configcatUser = getIt<ConfigCatUserStore>();
    final abTesting = getIt<ABTestingStore>();
    final pushNotificationStore = getIt<PushNotificationsStore>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: Navigator.of(context).pop,
          color: palette.textPrimary,
        ),
        forceMaterialTransparency: true,
        title: Text('Current Configs', style: textStyles.textLg.semibold),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Observer(
            builder: (context) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Environment: ',
                  style: textStyles.textMd.bold.copyWith(color: palette.textBrandPrimary),
                ),
                Text(
                  Env.stringify(),
                  maxLines: 20,
                  overflow: TextOverflow.ellipsis,
                  style: textStyles.textMd.regular,
                ),
                const SizedBox(height: 8),
                Text(
                  'Remote Configs: ',
                  style: textStyles.textMd.bold.copyWith(color: palette.textBrandPrimary),
                ),
                Text(
                  remoteConfigs.asUserProperties.toString(),
                  maxLines: 20,
                  overflow: TextOverflow.ellipsis,
                  style: textStyles.textMd.regular,
                ),
                const SizedBox(height: 8),
                Text(
                  'ConfigCat User: ',
                  style: textStyles.textMd.bold.copyWith(color: palette.textBrandPrimary),
                ),
                Text(
                  configcatUser.user ?? 'Loading...',
                  maxLines: 100,
                  overflow: TextOverflow.ellipsis,
                  style: textStyles.textMd.regular,
                ),
                const SizedBox(height: 8),
                Text(
                  'Push Notifications User: ',
                  style: textStyles.textMd.bold.copyWith(color: palette.textBrandPrimary),
                ),
                Text(
                  pushNotificationStore.user ?? 'Loading...',
                  maxLines: 100,
                  overflow: TextOverflow.ellipsis,
                  style: textStyles.textMd.regular,
                ),
                const SizedBox(height: 8),
                Text(
                  'AB Testing: ',
                  style: textStyles.textMd.bold.copyWith(color: palette.textBrandPrimary),
                ),
                Text(
                  abTesting.asUserProperties.toString(),
                  maxLines: 20,
                  overflow: TextOverflow.ellipsis,
                  style: textStyles.textMd.regular,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DeviceInfo extends StatelessWidget {
  const _DeviceInfo._();

  static void show({required BuildContext context}) {
    Future.delayed(Duration.zero, () {
      if (!context.mounted) {
        return;
      }
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => const _DeviceInfo._(),
          settings: const RouteSettings(name: 'deviceInfoPage'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final textStyles = theme.textStyles;
    final deviceIDStore = getIt<DeviceIDStore>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: Navigator.of(context).pop,
          color: palette.textPrimary,
        ),
        forceMaterialTransparency: true,
        title: Text('Device infos', style: textStyles.textLg.semibold),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Observer(
            builder: (context) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Persistent Device ID (We will track this one to analytics): ',
                  style: textStyles.textMd.bold.copyWith(color: palette.textBrandPrimary),
                ),
                Text(
                  deviceIDStore.deviceId,
                  maxLines: 20,
                  overflow: TextOverflow.ellipsis,
                  style: textStyles.textMd.regular,
                ),
                Text(
                  'Device info: ',
                  style: textStyles.textMd.bold.copyWith(color: palette.textBrandPrimary),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...Env.deviceInfo.data.entries.map(
                      (e) => Text(
                        '${e.key}: ${e.value}',
                        maxLines: 20,
                        overflow: TextOverflow.ellipsis,
                        style: textStyles.textMd.regular,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SecuredStorageValues extends StatelessWidget {
  const _SecuredStorageValues._();

  static void show({required BuildContext context}) {
    Future.delayed(Duration.zero, () {
      if (!context.mounted) {
        return;
      }
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => const _SecuredStorageValues._(),
          settings: const RouteSettings(name: 'securedStorageValuesPage'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final textStyles = theme.textStyles;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: Navigator.of(context).pop,
          color: palette.textPrimary,
        ),
        forceMaterialTransparency: true,
        title: Text('Secured stored keys', style: textStyles.textLg.semibold),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: FutureBuilder<Map<String, dynamic>>(
            future: SecureStorageService.instance.readAll(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...data.entries.map(
                      (e) => RichText(
                        maxLines: 20,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${e.key}: ',
                              style: textStyles.textSm.bold.copyWith(
                                color: palette.textBrandPrimary,
                              ),
                            ),
                            TextSpan(
                              text: '${e.value}',
                              style: textStyles.textSm.regular.copyWith(color: palette.textPrimary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}', style: textStyles.textMd.regular);
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
