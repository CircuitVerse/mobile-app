import 'package:mobile_app/utils/enum_values.dart';

enum AuthType { EMAIL, FACEBOOK, GOOGLE, GITHUB }

final authTypeValues = EnumValues({
  'email': AuthType.EMAIL,
  'facebook': AuthType.FACEBOOK,
  'google': AuthType.GOOGLE,
  'github': AuthType.GITHUB,
});
