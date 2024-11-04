import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

typedef GetCurrentPackageFullNameC = Int32 Function(
    Pointer<Uint32> packageFullNameLength, Pointer<Utf16> packageFullName);
typedef GetCurrentPackageFullNameDart = int Function(
    Pointer<Uint32> packageFullNameLength, Pointer<Utf16> packageFullName);

final kernel32 = DynamicLibrary.open('kernel32.dll');

final getWindowsCurrentPackageFullName =
    kernel32.lookupFunction<GetCurrentPackageFullNameC, GetCurrentPackageFullNameDart>(
        'GetCurrentPackageFullName');

String getCurrentPackageFullName() {
  final packageFullNameLength = calloc<Uint32>();
  final packageFullName = calloc<Uint16>(MAX_PATH).cast<Utf16>();

  try {
    final hr = getWindowsCurrentPackageFullName(packageFullNameLength, packageFullName);

    if (hr == WIN32_ERROR.ERROR_INSUFFICIENT_BUFFER) {
      final newLength = packageFullNameLength.value;
      calloc.free(packageFullName);
      final newPackageFullName = calloc<Uint16>(newLength).cast<Utf16>();

      final newHr = getWindowsCurrentPackageFullName(packageFullNameLength, newPackageFullName);
      if (newHr == S_OK) {
        return newPackageFullName.toDartString();
      }
    } else if (hr == S_OK) {
      return packageFullName.toDartString();
    } else if (hr == WIN32_ERROR.APPMODEL_ERROR_NO_PACKAGE) {
      return 'App is not a packaged app';
    }
  } finally {
    calloc.free(packageFullNameLength);
    calloc.free(packageFullName);
  }

  return 'Failed to get package full name';
}

void main() {
  final packageFullName = getCurrentPackageFullName();
  print('Package Full Name: $packageFullName');
}
