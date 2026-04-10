enum GrantType {
  refreshToken('refresh_token'),
  email('authorization_code'),
  apple('apple'),
  google('google');

  const GrantType(this.value);

  bool get isRefreshToken => this == GrantType.refreshToken;

  final String value;
}
