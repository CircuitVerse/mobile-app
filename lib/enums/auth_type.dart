import 'package:mobile_app/utils/enum_values.dart';

enum AuthType { email, facebook, google, github }

final authTypeValues = EnumValues({
  'email': AuthType.email,
  'facebook': AuthType.facebook,
  'google': AuthType.google,
  'github': AuthType.github,
});
