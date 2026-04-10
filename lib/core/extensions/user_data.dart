import 'package:mysterium_vpn/models/models.dart';

typedef UserData = ({String id, String email});

extension AuthUserDataExtensions on AuthUser? {
  ({String id, String email}) toUserData() =>
      (id: this?.userId ?? 'null', email: this?.username ?? 'null');
}
