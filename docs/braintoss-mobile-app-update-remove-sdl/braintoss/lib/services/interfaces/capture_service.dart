import 'package:braintoss/models/status_request_response.dart';
import 'package:braintoss/services/interfaces/base_service.dart';
import '../../models/capture_entity.dart';
import '../../models/capture_upload_model.dart';

enum ImageSource { camera, album, share, download }

abstract class CaptureService extends BaseService {
  Future<StatusRequestResponse?> sendCapture(CaptureUploadModel capture);
  Future<StatusRequestResponse?> resendCapture(CaptureEntity capture);
  void playSoundAndVibrate();
}
