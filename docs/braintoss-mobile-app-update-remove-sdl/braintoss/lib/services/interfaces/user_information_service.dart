import 'package:braintoss/models/email_model.dart';
import 'package:braintoss/services/interfaces/base_service.dart';

abstract class UserInformationService extends BaseService {
  String getUserId();
  void saveDefaultUserEmail(Email userEmail);
  Email getDefaultUserEmail();
  void saveUserEmails(List<Email> userEmails);
  List<Email> getUserEmails();
}
