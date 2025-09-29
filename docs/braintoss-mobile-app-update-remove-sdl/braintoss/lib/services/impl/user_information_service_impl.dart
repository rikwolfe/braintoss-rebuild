import 'dart:convert';

import 'package:braintoss/models/email_model.dart';
import 'package:braintoss/services/impl/base_service_impl.dart';
import 'package:braintoss/services/interfaces/shared_preferences_service.dart';
import 'package:braintoss/services/interfaces/user_information_service.dart';
import '../../constants/app_constants.dart';
import '../../utils/functions/generators.dart';

class UserInformationServiceImpl extends BaseServiceImpl
    implements UserInformationService {
  final SharedPreferencesService _sharedPreferencesService;

  UserInformationServiceImpl(this._sharedPreferencesService);

  @override
  String getUserId() {
    return _sharedPreferencesService
            .getString(SharedPreferencesConstants.userId) ??
        _createUserID();
  }

  String _createUserID() {
    String userId = generateUUIDv4();
    _sharedPreferencesService.saveString(
        SharedPreferencesConstants.userId, userId);
    return userId;
  }

  @override
  void saveDefaultUserEmail(Email userEmail) {
    _sharedPreferencesService.saveString(
        SharedPreferencesConstants.email, jsonEncode(userEmail.toJson()));
  }

  @override
  Email getDefaultUserEmail() {
    dynamic userEmail = jsonDecode(
        _sharedPreferencesService.getString(SharedPreferencesConstants.email)!);

    return Email.fromJson(userEmail);
  }

  @override
  void saveUserEmails(List<Email> userEmails) {
    String jsonEmails =
        jsonEncode(userEmails.map((i) => i.toJson()).toList()).toString();
    _sharedPreferencesService.saveString(
        SharedPreferencesConstants.emailList, jsonEmails);
  }

  @override
  List<Email> getUserEmails() {
    List<Email> userEmails = [];
    userEmails.add(getDefaultUserEmail());
    String? jsonEmails = _sharedPreferencesService
        .getString(SharedPreferencesConstants.emailList);

    if (jsonEmails == null) return [];

    List<Email> emails = List<Email>.from(
        jsonDecode(jsonEmails).map((model) => Email.fromJson(model)));

    userEmails.addAll(emails);

    return userEmails;
  }
}
