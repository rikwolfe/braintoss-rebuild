import 'package:braintoss/pages/photo_page.dart';
import 'package:braintoss/pages/stateless_page.dart';
import 'package:braintoss/pages/voice_page.dart';
import 'package:braintoss/routes.dart';
import 'package:braintoss/stores/capture_store.dart';
import 'package:flutter/material.dart';
import 'package:loop_page_view/loop_page_view.dart';
import 'package:seafarer/seafarer.dart';

import 'note_page.dart';

enum CaptureMode { note, voice, photo }

class CapturePageArgs extends BaseStoreArguments {
  final CaptureMode captureMode;
  final String? noteText;
  CapturePageArgs(this.captureMode, {this.noteText});
}

CaptureMode _intToCaptureMode(int int) {
  return CaptureMode
      .values[int >= 0 && int <= CaptureMode.values.length ? int : 0];
}

class CapturePage extends StatelessPage<CaptureStore> {
  CapturePage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Seafarer.args<CapturePageArgs>(context);

    LoopPageController loopPageController = LoopPageController(
      initialPage: args?.captureMode.index ?? 0,
      keepPage: false,
    );
    loopPageController.addListener(
      () {
        store.dismissKeyboard();
      },
    );

    return LoopPageView.builder(
        controller: loopPageController,
        itemBuilder: (_, index) {
          if (index >= CaptureMode.values.length) {
            return const SizedBox.shrink();
          }
          switch (_intToCaptureMode(index)) {
            case CaptureMode.note:
              return NotePage();
            case CaptureMode.photo:
              return const PhotoPage();
            case CaptureMode.voice:
              return const VoicePage();
          }
        },
        itemCount: 3);
  }
}
