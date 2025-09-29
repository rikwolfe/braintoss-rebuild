import 'package:braintoss/services/interfaces/base_service.dart';

import '../../models/capture_entity.dart';

abstract class CaptureDataManager extends BaseService {
  void saveCapture(CaptureEntity capture);
  Future<CaptureEntity?> getCapture(String messageID);
  Future<List<CaptureEntity>> getAllCaptures();
  Future<void> deleteCaptureById(String messageID);
  Future<void> deleteCapture(CaptureEntity item, {bool deleteFile = true});
  Future<void> deleteAllCaptures();
  Future<void> deleteOldCaptures();
  void deleteLeftoverCaptures();
}
