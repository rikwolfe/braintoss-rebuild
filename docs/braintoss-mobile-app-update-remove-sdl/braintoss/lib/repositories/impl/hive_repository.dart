import 'package:braintoss/models/capture_entity.dart';
import 'package:braintoss/repositories/interfaces/local_db_repository.dart';
import 'package:hive/hive.dart';

class HiveRepository implements LocalDBRepository {
  HiveRepository() {
    _historyBox = Hive.box<CaptureEntity>('captures');
  }
  late Box _historyBox;

  @override
  Future<void> create(CaptureEntity item) async {
    _historyBox.put(item.messageID, item);
  }

  @override
  Future<void> delete(CaptureEntity item) async {
    item.delete();
  }

  @override
  Future<void> deleteById(String id) async {
    return _historyBox.delete(id);
  }

  @override
  Future<List<CaptureEntity>> getAll() async {
    return Future.value(
      _historyBox.keys
          .map((e) => _historyBox.get(e))
          .toList()
          .cast<CaptureEntity>(),
    );
  }

  @override
  Future<CaptureEntity?> getById(String id) async {
    return _historyBox.get(id);
  }

  @override
  Future<bool> itemExists(String id) async {
    return _historyBox.containsKey(id);
  }

  @override
  Future<void> update(CaptureEntity item) async {
    item.save();
  }

  @override
  Future<void> deleteAll() async {
    _historyBox.deleteAll(_historyBox.keys);
  }
}
