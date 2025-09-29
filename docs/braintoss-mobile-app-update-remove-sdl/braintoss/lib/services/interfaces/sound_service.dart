import 'package:braintoss/services/interfaces/base_service.dart';

abstract class SoundService extends BaseService {
  void playSound(String audioPath);
}
