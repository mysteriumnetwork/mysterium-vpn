class DeviceLimitReachedException implements Exception {
  const DeviceLimitReachedException();

  static const code = 'err_fetch_connect_config_allowed_devices_limit';
}
