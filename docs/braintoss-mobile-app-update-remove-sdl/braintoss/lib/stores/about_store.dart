import 'package:braintoss/services/interfaces/navigation_service.dart';
import 'package:braintoss/stores/base_store.dart';

import 'package:html/dom.dart' as dom;
import 'package:mobx/mobx.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/interfaces/content_service.dart';

part 'about_store.g.dart';

class AboutStore = _AboutStore with _$AboutStore;

abstract class _AboutStore extends BaseStore with Store {
  _AboutStore(
      {required NavigationService navigationService,
      required this.contentService})
      : super(navigationService: navigationService);

  ContentService contentService;

  void onGoBack() {
    navigationService?.goBack();
  }

  Future<String?> getContent() async {
    return await contentService.getAboutPage();
  }

  void onLinkTap(
    String? url,
    Map<String, String> attributes,
    dom.Element? element,
  ) async {
    if (!await (url != null ? launchUrl(Uri.parse(url)) : Future.value(true))) {
      throw 'Could not launch $url';
    }
  }
}
