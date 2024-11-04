// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

class AppxNamePath {
  bool? hasManifest;
  String? name;
  String? path;
}

class HwndPath {
  bool hasManifest = true;
  HwndPath();
  AppxNamePath GetAppxInstallLocation(hWnd) {
    //Ger Process Handle
    final ppID = calloc<Uint32>();
    GetWindowThreadProcessId(hWnd, ppID);
    var process =
        OpenProcess(PROCESS_ACCESS_RIGHTS.PROCESS_QUERY_LIMITED_INFORMATION, FALSE, ppID.value);
    free(ppID);

    //Get Text
    final cMax = calloc<Uint32>()..value = 512;
    var cAppName = wsalloc(cMax.value);
    GetApplicationUserModelId(process, cMax, cAppName);
    var name = cAppName.toDartString();
    free(cMax);

    //It's main Window Handle On EdgeView Apps, query first child
    if (name.isEmpty) {
      final parentHwnd = GetAncestor(hWnd, 2);
      final childWins = enumChildWins(parentHwnd);
      if (childWins.length > 1) {
        CloseHandle(process);
        hWnd = childWins[1];

        final ppID = calloc<Uint32>();
        GetWindowThreadProcessId(hWnd, ppID);
        process =
            OpenProcess(PROCESS_ACCESS_RIGHTS.PROCESS_QUERY_LIMITED_INFORMATION, FALSE, ppID.value);
        free(ppID);

        final cMax = calloc<Uint32>()..value = 512;
        GetApplicationUserModelId(process, cMax, cAppName);
        name = cAppName.toDartString();
        free(cMax);
      }
    }
    if (name.isEmpty) {
      return AppxNamePath()
        ..hasManifest = false
        ..name = "NoManifest"
        ..path = "C:\\";
    }

    //Get Package Name
    final familyLength = calloc<Uint32>()..value = 65 * 2;
    final familyName = wsalloc(familyLength.value);
    final packageLength = calloc<Uint32>()..value = 65 * 2;
    final packageName = wsalloc(familyLength.value);
    ParseApplicationUserModelId(cAppName, familyLength, familyName, packageLength, packageName);

    //Get Count
    final count = calloc<Uint32>();
    final buffer = calloc<Uint32>();
    FindPackagesByPackageFamily(
        familyName, 0x00000010 | 0x00000000, count, nullptr, buffer, nullptr, nullptr);
    final packageFullnames = calloc<Pointer<Utf16>>();
    final bufferString = wsalloc(buffer.value * 2);

    //Get Path
    FindPackagesByPackageFamily(familyName, 0x00000010 | 0x00000000, count, packageFullnames,
        buffer, bufferString, nullptr);
    final packageLocation = bufferString.toDartString();
    CloseHandle(process);
    print("Name: ${cAppName.toDartString()}");
    print("Family: ${familyName.toDartString()}");
    print("Package: ${packageName.toDartString()}");
    print("packageFullnames ${packageFullnames.toString()}");
    free(cAppName);
    free(familyLength);
    free(familyName);
    free(packageLength);
    free(packageName);
    free(count);
    free(buffer);
    free(packageFullnames);
    free(bufferString);
    return AppxNamePath()
      ..name = name
      ..path = "C:\\Program Files\\WindowsApps\\$packageLocation"
      ..hasManifest = true;
  }

  String getProcessExePath(processID) {
    String exePath = "";
    final hProcess = OpenProcess(
        PROCESS_ACCESS_RIGHTS.PROCESS_QUERY_INFORMATION | PROCESS_ACCESS_RIGHTS.PROCESS_VM_READ,
        FALSE,
        processID);
    if (hProcess == 0) {
      CloseHandle(hProcess);
      return "";
    }
    final imgName = wsalloc(MAX_PATH);
    final buff = calloc<Uint32>()..value = MAX_PATH;
    if (QueryFullProcessImageName(hProcess, 0, imgName, buff) != 0) {
      final szModName = wsalloc(MAX_PATH);
      GetModuleFileNameEx(hProcess, 0, szModName, MAX_PATH);
      exePath = szModName.toDartString();
      free(szModName);
    } else {
      exePath = "";
    }
    free(imgName);
    free(buff);
    CloseHandle(hProcess);
    return exePath;
  }

  String getWindowExePath(hWnd) {
    String result = "";
    final pId = calloc<Uint32>();
    GetWindowThreadProcessId(hWnd, pId);
    final processID = pId.value;
    free(pId);

    result = getProcessExePath(processID);
    if (result.contains("FrameHost.exe")) {
      final wins = enumChildWins(hWnd);
      final winsProc = <int>[];
      int mainWinProcs = 0;
      for (var e in wins) {
        final xpId = calloc<Uint32>();

        GetWindowThreadProcessId(e, xpId);
        winsProc.add(xpId.value);
        if (processID != xpId.value) {
          mainWinProcs = xpId.value;
        }
        free(xpId);
      }
      if (mainWinProcs > 0) {
        result = getProcessExePath(mainWinProcs);
      }
    }
    return result;
  }

  String getFullPath(hWnd) {
    var exePath = getWindowExePath(hWnd);
    if (exePath.contains('WWAHost')) {
      final appx = GetAppxInstallLocation(hWnd);
      if (appx.hasManifest == true) {
        exePath = "${appx.path}";
      } else {
        exePath = "";
      }
    }
    return exePath;
  }
}

var __helperWinsList = <int>[];
int helperEnumWindowFunc(int w, int p) {
  __helperWinsList.add(w);
  return 1;
}

final wndProc = Pointer.fromFunction<WNDENUMPROC>(helperEnumWindowFunc, 0);

List enumChildWins(hWnd) {
  __helperWinsList.clear();
  EnumChildWindows(hWnd, wndProc, 0);
  return __helperWinsList;
}

//DLL IMPORTS

final _kernel32 = DynamicLibrary.open('kernel32.dll');

int QueryFullProcessImageName(
        int hProcess, int dwFlags, Pointer<Utf16> lpExeName, Pointer<Uint32> lpdwSize) =>
    _QueryFullProcessImageName(hProcess, dwFlags, lpExeName, lpdwSize);

final _QueryFullProcessImageName = _kernel32.lookupFunction<
    Int32 Function(
        IntPtr hProcess, Uint32 dwFlags, Pointer<Utf16> lpExeName, Pointer<Uint32> lpdwSize),
    int Function(int hProcess, int dwFlags, Pointer<Utf16> lpExeName,
        Pointer<Uint32> lpdwSize)>('QueryFullProcessImageNameW');

int GetApplicationUserModelId(int hProcess, Pointer<Uint32> applicationUserModelIdLength,
        Pointer<Utf16> applicationUserModelId) =>
    _GetApplicationUserModelId(hProcess, applicationUserModelIdLength, applicationUserModelId);

final _GetApplicationUserModelId = _kernel32.lookupFunction<
    Uint32 Function(IntPtr hProcess, Pointer<Uint32> applicationUserModelIdLength,
        Pointer<Utf16> applicationUserModelId),
    int Function(int hProcess, Pointer<Uint32> applicationUserModelIdLength,
        Pointer<Utf16> applicationUserModelId)>('GetApplicationUserModelId');
int ParseApplicationUserModelId(
        Pointer<Utf16> applicationUserModelId,
        Pointer<Uint32> packageFamilyNameLength,
        Pointer<Utf16> packageFamilyName,
        Pointer<Uint32> packageRelativeApplicationIdLength,
        Pointer<Utf16> packageRelativeApplicationId) =>
    _ParseApplicationUserModelId(applicationUserModelId, packageFamilyNameLength, packageFamilyName,
        packageRelativeApplicationIdLength, packageRelativeApplicationId);

final _ParseApplicationUserModelId = _kernel32.lookupFunction<
    Uint32 Function(
        Pointer<Utf16> applicationUserModelId,
        Pointer<Uint32> packageFamilyNameLength,
        Pointer<Utf16> packageFamilyName,
        Pointer<Uint32> packageRelativeApplicationIdLength,
        Pointer<Utf16> packageRelativeApplicationId),
    int Function(
        Pointer<Utf16> applicationUserModelId,
        Pointer<Uint32> packageFamilyNameLength,
        Pointer<Utf16> packageFamilyName,
        Pointer<Uint32> packageRelativeApplicationIdLength,
        Pointer<Utf16> packageRelativeApplicationId)>('ParseApplicationUserModelId');

int lastHoveredHwnd = 0;
void main() {
  Timer.periodic(const Duration(milliseconds: 200), (timer) {
    final pos = calloc<POINT>();
    GetCursorPos(pos);
    final currentWin = WindowFromPoint(pos.ref);
    free(pos);
    final hWnd = GetAncestor(currentWin, 2);
    if (hWnd != lastHoveredHwnd) {
      lastHoveredHwnd = hWnd;
      final path = HwndPath().getFullPath(hWnd);
      print(path);
    }
  });
}
