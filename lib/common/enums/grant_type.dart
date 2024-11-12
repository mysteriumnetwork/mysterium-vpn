enum GrantType {
  refreshToken('refresh_token'),
  email('authorization_code'),
  apple('apple'),
  google('google'),
  savedToken('saved_token');

  const GrantType(this.value);

  final String value;
}
