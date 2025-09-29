import 'dart:io';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:braintoss/services/impl/base_service_impl.dart';
import 'package:braintoss/services/interfaces/sound_service.dart';
import 'package:flutter/services.dart';
import '../../constants/app_constants.dart';

class SoundServiceImpl extends BaseServiceImpl implements SoundService {
  @override
  void playSound(String audioPath) async {
    //AudioCache cache = AudioCache();
    if (Platform.isIOS) {
      final isPlaying = await isMusicPlaying();
      if (isPlaying) {
        return;
      }
    }
    final DeviceFileSource source = DeviceFileSource(audioPath);
    AudioPlayer().play(source);
  }

  Future<bool> isMusicPlaying() async {
    const platform = MethodChannel(methodChannelName);
    try {
      final isPlaying = await platform.invokeMethod('isMusicPlaying');
      if (isPlaying) {
        return true;
      } else {
        return false;
      }
    } on PlatformException {
      return false;
    }
  }
}
