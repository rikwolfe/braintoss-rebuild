import 'package:braintoss/models/capture_entity.dart';

abstract class LocalDBRepository {
  Future<List<CaptureEntity>> getAll();
  Future<CaptureEntity?> getById(String id);
  Future<void> create(CaptureEntity item);
  Future<void> delete(CaptureEntity item);
  Future<void> deleteById(String id);
  Future<void> deleteAll();
  Future<void> update(CaptureEntity item);
  Future<bool> itemExists(String id);
}
