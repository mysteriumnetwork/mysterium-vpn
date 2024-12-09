import 'package:hooks_riverpod/hooks_riverpod.dart';

class TesttopicNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  Future<void> receive(String payload) async {
    state = payload;
  }
}
