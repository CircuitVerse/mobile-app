import 'package:mobile_app/utils/enum_values.dart';

enum AuthType { EMAIL, GOOGLE, GITHUB }

final authTypeValues = EnumValues({
  'email': AuthType.EMAIL,
  'google': AuthType.GOOGLE,
  'github': AuthType.GITHUB,
});
