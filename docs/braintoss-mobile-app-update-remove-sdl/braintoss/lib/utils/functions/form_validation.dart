import 'package:braintoss/utils/functions/email_validation.dart';

class FormValidation {
  static bool validate(String email,
      [bool allowTopLevelDomains = false, bool allowInternational = true]) {
    if (!email.startsWith(RegExp(r'[a-zA-Z0-9]'))) {
      return false;
    }

    return EmailValidator.validate(email);
  }
}
