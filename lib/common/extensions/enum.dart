import 'package:flutter/foundation.dart';

extension StorageKeysEx on Enum {
  String get value => describeEnum(this);
}
