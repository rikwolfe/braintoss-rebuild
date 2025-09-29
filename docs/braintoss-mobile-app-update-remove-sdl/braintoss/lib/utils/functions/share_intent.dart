import 'dart:async';

import 'package:braintoss/pages/capture_page.dart';
import 'package:braintoss/pages/image_page.dart';
import 'package:braintoss/routes.dart';
import 'package:braintoss/services/impl/navigation_service_impl.dart';
import 'package:braintoss/services/interfaces/capture_service.dart';
import 'package:braintoss/services/interfaces/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class ShareIntent {
  ShareIntent(this.context) {
    init();
  }

  NavigationService navigationService = NavigationServiceImpl();
  BuildContext context;

  void init() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      listenForSharedMediaFiles();
    });
  }

  void listenForSharedMediaFiles() {
    ReceiveSharingIntent.instance
        .getMediaStream()
        .listen((List<SharedMediaFile> media) {
      String text = media
          .where((element) =>
              element.type == SharedMediaType.text ||
              element.type == SharedMediaType.url)
          .map((element) => [element.message, element.path].nonNulls.join(" "))
          .where((element) => element.isNotEmpty)
          .join("\n");

      List<SharedMediaFile> nonText = media
          .where((element) =>
              element.type != SharedMediaType.text &&
              element.type != SharedMediaType.url)
          .toList();
      if (nonText.isEmpty && text.isEmpty) {
        return;
      }
      navigateToShareText(text);
      navigateToShareMedia(nonText);
    });
  }

  Future<bool> isMediaSharedFromClosedApp() async {
    List<SharedMediaFile> media =
        await ReceiveSharingIntent.instance.getInitialMedia();

    String text = media
        .where((element) =>
            element.type == SharedMediaType.text ||
            element.type == SharedMediaType.url)
        .map((element) => [element.message, element.path].nonNulls.join(" "))
        .where((element) => element.isNotEmpty)
        .join("\n");
    List<SharedMediaFile> nonText = media
        .where((element) =>
            element.type != SharedMediaType.text &&
            element.type != SharedMediaType.url)
        .toList();
    if (nonText.isEmpty && text.isEmpty) {
      return false;
    }
    navigateToShareMedia(nonText);
    navigateToShareText(text);

    return true;
  }

  void navigateToShareMedia(List<SharedMediaFile> images) {
    if (images.isNotEmpty) {
      navigationService.replaceWith(Routes.image,
          arguments: ImagePageArgs(
              images.map((image) => image.path).toList(), ImageSource.share));
    }
  }

  void navigateToShareText(String? text) {
    if (text != null && text.isNotEmpty) {
      navigationService.replaceWith<CapturePageArgs>(Routes.note,
          arguments:
              CapturePageArgs(CaptureMode.note, noteText: text.toString()));
    }
  }
}
