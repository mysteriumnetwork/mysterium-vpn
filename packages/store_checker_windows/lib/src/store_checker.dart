import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

final _kernel32 = DynamicLibrary.open('kernel32.dll');

typedef _GetCurrentPackageFullNameC = Int32 Function(
    Pointer<Uint32> packageFullNameLength, Pointer<Utf16> packageFullName);
typedef _GetCurrentPackageFullNameDart = int Function(
    Pointer<Uint32> packageFullNameLength, Pointer<Utf16> packageFullName);

final _getCurrentPackageFullName =
    _kernel32.lookupFunction<_GetCurrentPackageFullNameC, _GetCurrentPackageFullNameDart>(
  'GetCurrentPackageFullName',
);

String? getCurrentPackageFullName() {
  return using((arena) {
    final length = arena<Uint32>();

    if (_getCurrentPackageFullName(length, nullptr) != ERROR_INSUFFICIENT_BUFFER) {
      return null;
    }

    final fullName = arena<Uint16>(length.value).cast<Utf16>();
    if (_getCurrentPackageFullName(length, fullName) != ERROR_SUCCESS) {
      return null;
    }

    return fullName.toDartString();
  });
}
