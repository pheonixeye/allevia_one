import 'package:allevia_one/assets/assets.dart';
import 'package:just_audio/just_audio.dart';

class SoundHelper {
  const SoundHelper._();

  static final SoundHelper _instance = SoundHelper._();

  factory SoundHelper() {
    return _instance;
  }

  static Future<void> playSound(AudioPlayer player) async {
    await player.setAsset(AppAssets.notification_sound);
    await player.play();
  }
}
