import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/interceptors/refresh_token.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/providers/service_providers.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Guards the security boundary: the Notifier Dio must carry only the static
/// public API key, never the user's access token or the refresh-token retry.
void main() {
  late ProviderContainer container;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    PackageInfo.setMockInitialValues(
      appName: 'MysteriumVPN',
      packageName: 'com.mysteriumvpn.test',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
    // notifierDioPOD reads Env.userAgent / buildInfo, both late-initialized.
    await Env.init();
  });

  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  test('sends a bearer Authorization header built from the public API key', () {
    final dio = container.read(notifierDioPOD);

    expect(dio.options.headers['Authorization'], startsWith('Bearer '));
  });

  test('does not attach the refresh-token interceptor', () {
    final dio = container.read(notifierDioPOD);

    expect(dio.interceptors.whereType<RefreshTokenInterceptor>(), isEmpty);
  });

  test('does not attach an interceptor that could inject the access token', () {
    final dio = container.read(notifierDioPOD);

    expect(dio.interceptors.whereType<InterceptorsWrapper>(), isEmpty);
  });

  test('uses timeouts so a hung registration cannot stall forever', () {
    final dio = container.read(notifierDioPOD);

    expect(dio.options.connectTimeout, const Duration(seconds: 15));
    expect(dio.options.receiveTimeout, const Duration(seconds: 15));
    expect(dio.options.sendTimeout, const Duration(seconds: 15));
  });
}
