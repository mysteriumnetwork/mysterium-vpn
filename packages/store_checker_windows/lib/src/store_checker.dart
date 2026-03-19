import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

final _kernel32 = DynamicLibrary.open('kernel32.dll');

// Define the GetCurrentPackageFullName function
typedef GetCurrentPackageFullNameC = Int32 Function(
    Pointer<Uint32> packageFullNameLength, Pointer<Utf16> packageFullName);
typedef GetCurrentPackageFullNameDart = int Function(
    Pointer<Uint32> packageFullNameLength, Pointer<Utf16> packageFullName);

final _getCurrentPackageFullName = _kernel32
    .lookupFunction<GetCurrentPackageFullNameC, GetCurrentPackageFullNameDart>(
  'GetCurrentPackageFullName',
);

String? getCurrentPackageFullName() {
  final length = calloc<Uint32>();
  final result = _getCurrentPackageFullName(length, nullptr);

  if (result != ERROR_INSUFFICIENT_BUFFER) {
    if (result == APPMODEL_ERROR_NO_PACKAGE) {
      print('Process has no package identity');
      calloc.free(length);
      return null;
    } else {
      print('Error $result in GetCurrentPackageFullName');
      calloc.free(length);
      return null;
    }
  }

  final fullName = calloc<Uint16>(length.value).cast<Utf16>();
  final result2 = _getCurrentPackageFullName(length, fullName);

  if (result2 != ERROR_SUCCESS) {
    print('Error $result2 retrieving PackageFullName');
    calloc.free(fullName);
    calloc.free(length);
    return null;
  }

  final packageFullName = fullName.toDartString();

  calloc.free(fullName);
  calloc.free(length);

  return packageFullName;
}

void main() {
  final packageFullName = getCurrentPackageFullName();
  print('Package Full Name: $packageFullName');
}
