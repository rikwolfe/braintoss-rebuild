import 'package:braintoss/services/impl/base_service_impl.dart';
import 'package:braintoss/services/interfaces/share_service.dart';
import 'package:share_plus/share_plus.dart';

class ShareServiceImpl extends BaseServiceImpl
    implements ShareService {
  @override
  void shareText(String text) {
    Share.share(text);
  }
}
