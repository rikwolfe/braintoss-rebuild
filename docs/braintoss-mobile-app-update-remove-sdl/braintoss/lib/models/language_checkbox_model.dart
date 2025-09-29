import 'package:braintoss/models/language_model.dart';

class LanguageCheckBox {
  final Language language;
  bool? value;
  LanguageCheckBox({
    required this.language,
    this.value = false,
  });
}
