import 'dart:io';

import 'package:braintoss/models/capture_entity.dart';
import 'package:braintoss/repositories/interfaces/local_db_repository.dart';
import 'package:braintoss/services/impl/base_service_impl.dart';
import 'package:braintoss/services/interfaces/logger_service.dart';
import 'package:braintoss/services/interfaces/capture_data_manager.dart';
import 'package:braintoss/utils/functions/file_path_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class CaptureDataManagerImpl extends BaseServiceImpl
    implements CaptureDataManager {
  CaptureDataManagerImpl(this._repository, this._loggerService);

  final LoggerService _loggerService;
  final LocalDBRepository _repository;

  @override
  void saveCapture(CaptureEntity capture) {
    _repository.create(capture);
  }

  @override
  Future<CaptureEntity?> getCapture(String messageID) async {
    return _repository.getById(messageID);
  }

  @override
  Future<List<CaptureEntity>> getAllCaptures() async {
    return _repository.getAll();
  }

  @override
  Future<void> deleteCaptureById(String id) async {
    final box = await Hive.openBox<CaptureEntity>('captures');
    try {
      final capture =
          box.values.firstWhere((capture) => capture.messageID == id);
      await capture.delete();
    } catch (e) {
      if (kDebugMode) {
        print("Capture with ID $id not found: $e");
      }
      _loggerService.recordError("Capture with ID $id not found: $e");
    }
  }

  void _deleteFile(String path) {
    File captureFile;
    try {
      captureFile = File(path);
      captureFile.deleteSync();
    } catch (e) {
      _loggerService.recordError(e.toString());
    }
  }

  @override
  Future<void> deleteCapture(CaptureEntity item,
      {bool deleteFile = true}) async {
    if (deleteFile) {
      _deleteFile(getFullFilePath(item.filename));
    }
    return await _repository.deleteById(item.messageID);
  }

  @override
  Future<void> deleteAllCaptures() async {
    for (CaptureEntity capture in await getAllCaptures()) {
      await deleteCapture(capture);
    }
    return;
  }

  @override
  void deleteLeftoverCaptures() async {
    List<String> knownFiles = (await getAllCaptures())
        .map((capture) => capture.fullFilePath)
        .toList();

    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    final List<FileSystemEntity> allFiles =
        documentsDirectory.listSync(recursive: true);

    final List<FileSystemEntity> unknownFiles = allFiles
        .where((file) =>
            file is File &&
            !knownFiles.any((knownFile) =>
                p.basename(file.path) == p.basename(knownFile)) &&
            p.basename(file.path) != "captures.hive" &&
            p.basename(file.path) != "captures.lock" &&
            !file.path.contains("flutter_assets") &&
            !file.path.contains("res_timestamp-"))
        .toList();

    for (var file in unknownFiles) {
      try {
        (file as File).deleteSync();
      } catch (e) {
        if (kDebugMode) {
          print("Failed to delete $file");
        }
      }
    }
  }

  @override
  Future<void> deleteOldCaptures() async {
    List<CaptureEntity> captures = await getAllCaptures();
    final now = DateTime.now();

    List<CaptureEntity> capturesToDelete = captures.where((capture) {
      final captureDate = capture.dateAndTime;
      return now.difference(captureDate).inDays >= 14;
    }).toList();

    for (CaptureEntity oldCapture in capturesToDelete) {
      await deleteCaptureById(oldCapture.messageID);
    }
  }
}
