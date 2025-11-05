import 'package:allevia_one/assets/assets.dart';
import 'package:web/web.dart' as web;

class SoundHelper {
  const SoundHelper._();

  static final SoundHelper _instance = SoundHelper._();

  factory SoundHelper() {
    return _instance;
  }

  static void playSound() {
    final audio = web.HTMLAudioElement()..src = AppAssets.notification_sound;
    audio.play();
  }
}
