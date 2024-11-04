//
//
//
//

import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

final kernel32 = DynamicLibrary.open('kernel32.dll');
final getSessionID =
    kernel32.lookupFunction<Uint32 Function(), int Function()>('WTSGetActiveConsoleSessionId');
const pipeName = r'\\.\pipe\myst-launcher-helper';
const commandName = 'mystnodes-helper';

class MystNodesHelperCommand extends Command<void> {
  MystNodesHelperCommand({required this.mystExePath});
  final String mystExePath;
  @override
  String get name => commandName;
  @override
  String get description => 'Execute the named pipe client.';

  @override
  void run() {
    final lpPipeName = pipeName.toNativeUtf16();
    final sessionId = getSessionID();

    final json = jsonEncode({
      "cmd": "setup-fw",
      "sid": sessionId,
      "exe": mystExePath,
      "version": "2",
    });
    final message = '$json\n'.toNativeUtf8();
    final lpBuffer = wsalloc(2000);
    final lpNumBytesRead = calloc<DWORD>();
    final lpNumBytesWritten = calloc<DWORD>();

    try {
      stdout.writeln('Connecting to pipe...');
      final pipe = CreateFile(
          lpPipeName,
          GENERIC_ACCESS_RIGHTS.GENERIC_READ | GENERIC_ACCESS_RIGHTS.GENERIC_WRITE,
          FILE_SHARE_MODE.FILE_SHARE_READ | FILE_SHARE_MODE.FILE_SHARE_WRITE,
          nullptr,
          FILE_CREATION_DISPOSITION.OPEN_EXISTING,
          FILE_FLAGS_AND_ATTRIBUTES.FILE_ATTRIBUTE_NORMAL,
          NULL);
      if (pipe == INVALID_HANDLE_VALUE) {
        stderr.writeln('Failed to connect to pipe.');
        throw Exception('Failed to connect to pipe.');
      }
      stdout.writeln('Writing data from pipe...');

      var result = WriteFile(pipe, message.cast(), message.length, lpNumBytesWritten, nullptr);
      if (result == NULL) {
        stderr.writeln('Failed to send data.');
        throw Exception('Failed to send data.');
      } else {
        final numBytesWritten = lpNumBytesWritten.value;
        stdout.writeln('Number of bytes sent: $numBytesWritten');
      }

      stdout.writeln('Reading data from pipe...');
      result = ReadFile(pipe, lpBuffer.cast(), 2000, lpNumBytesRead, nullptr);
      if (result == NULL) {
        stderr.writeln('Failed to read data from the pipe.');
        throw Exception('Failed to read data from the pipe.');
      } else {
        final numBytesRead = lpNumBytesRead.value;
        final jsonData = lpBuffer.cast<Utf8>().toDartString();

        stdout
          ..writeln('Number of bytes read: $numBytesRead')
          ..writeln('Message: $jsonData');
      }

      CloseHandle(pipe);

      stdout.writeln('Done.');
    } catch (e) {
      stderr.writeln('Error: $e');
      rethrow;
    } finally {
      free(lpPipeName);
      free(lpBuffer);
      free(lpNumBytesRead);
    }
  }
}
